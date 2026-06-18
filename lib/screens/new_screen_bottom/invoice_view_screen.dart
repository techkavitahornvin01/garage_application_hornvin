import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/localization/app_localizations.dart';
import 'package:hornvin/repositories/invoice_repository.dart';
import 'package:hornvin/utils/friendly_error.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoiceViewScreen extends StatefulWidget {
  const InvoiceViewScreen({super.key});

  @override
  State<InvoiceViewScreen> createState() => _InvoiceViewScreenState();
}

class _InvoiceViewScreenState extends State<InvoiceViewScreen> {
  final InvoiceRepository _repository = InvoiceRepository();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> invoices = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInvoices() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await _repository.getInvoices(
        search: _searchController.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        invoices = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = friendlyErrorMessage(
          e,
          fallback: 'Invoices could not be loaded right now. Please try again.',
        );
        isLoading = false;
      });
    }
  }

  Future<void> _openInvoice(Map<String, dynamic> invoice) async {
    final id = _idOf(invoice);
    if (id.isEmpty) return;

    try {
      final result = await _repository.getInvoice(id);
      if (!mounted) return;
      _showInvoiceDetails(result);
    } catch (e) {
      _showMessage('Invoice load failed: $e', Colors.red);
    }
  }

  Future<void> _deleteInvoice(Map<String, dynamic> invoice) async {
    final id = _idOf(invoice);
    if (id.isEmpty) return;

    try {
      await _repository.deleteInvoice(id);
      _showMessage('Invoice deleted', Colors.green);
      await _loadInvoices();
    } catch (e) {
      _showMessage('Delete failed: $e', Colors.red);
    }
  }

  Future<void> _markPaid(Map<String, dynamic> invoice) async {
    final id = _idOf(invoice);
    if (id.isEmpty) return;

    try {
      await _repository.updatePaymentStatus(id: id, paymentStatus: 'paid');
      _showMessage('Payment status updated', Colors.green);
      await _loadInvoices();
    } catch (e) {
      _showMessage('Payment update failed: $e', Colors.red);
    }
  }

  Future<void> _downloadInvoicePdf(Map<String, dynamic> invoice) async {
    final generatingText = context.trText('Generating invoice PDF...');
    final savedText = context.trText('Invoice PDF saved');
    final failedText = context.trText('Invoice PDF failed');
    try {
      _showMessage(generatingText, Colors.blue);
      final id = _idOf(invoice);
      final invoiceData = id.isEmpty
          ? invoice
          : await _repository.getInvoice(id);
      final file = await _createInvoicePdf(invoiceData);
      if (!mounted) return;
      _showMessage('$savedText: ${file.path}', Colors.green);
      await OpenFilex.open(file.path);
    } catch (e) {
      _showMessage('$failedText: $e', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          context.trText('Invoice List'),
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actionsIconTheme: const IconThemeData(color: AppColors.textPrimary),
        surfaceTintColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            color: AppColors.primary,
            onPressed: _loadInvoices,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: context.trText('Search invoices...'),
                  hintStyle: GoogleFonts.lato(color: AppColors.grey),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.primary,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onSubmitted: (_) => _loadInvoices(),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? _buildLoading()
                : errorMessage != null
                ? _buildMessage('Error loading invoices', errorMessage!)
                : invoices.isEmpty
                ? _buildMessage(
                    'No invoices found',
                    'Create an invoice to see it here',
                  )
                : RefreshIndicator(
                    onRefresh: _loadInvoices,
                    color: AppColors.primary,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: invoices.length,
                      itemBuilder: (context, index) {
                        return _buildInvoiceCard(invoices[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceCard(Map<String, dynamic> invoice) {
    final id = _idOf(invoice);
    final billTo = _mapOf(invoice['billTo']);
    final customer = _text(
      billTo['name'] ?? invoice['customerName'] ?? invoice['customer'],
    );
    final place = _text(invoice['placeOfSupply']);
    final total = _amountText(invoice);
    final status = _text(
      _mapOf(invoice['payment'])['paymentStatus'] ??
          invoice['payment_status'] ??
          invoice['paymentStatus'],
      fallback: 'pending',
    );
    final statusColor = status.toLowerCase() == 'paid'
        ? Colors.green
        : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openInvoice(invoice),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          _suffix(id),
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.trData(
                              customer.isEmpty ? 'Invoice' : customer,
                            ),
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.trData(
                              place.isEmpty ? 'Place: N/A' : place,
                            ),
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'view') _openInvoice(invoice);
                        if (value == 'download') _downloadInvoicePdf(invoice);
                        if (value == 'paid') _markPaid(invoice);
                        if (value == 'delete') _deleteInvoice(invoice);
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'view',
                          child: Text(context.trText('View')),
                        ),
                        PopupMenuItem(
                          value: 'download',
                          child: Text(context.trText('Download PDF')),
                        ),
                        PopupMenuItem(
                          value: 'paid',
                          child: Text(context.trText('Mark Paid')),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(context.trText('Delete')),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(color: Colors.grey.shade200, height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoChip(Icons.currency_rupee, total, Colors.green),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      Icons.payments_outlined,
                      status,
                      statusColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            context.trData(label),
            style: GoogleFonts.lato(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            context.trText('Loading invoices...'),
            style: GoogleFonts.lato(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              context.trData(title),
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.trData(subtitle),
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  void _showInvoiceDetails(Map<String, dynamic> invoice) {
    final parts = _listOfMaps(invoice['parts']);
    final services = _listOfMaps(invoice['services']);
    final billTo = _mapOf(invoice['billTo']);
    final company = _mapOf(invoice['company']);
    final payment = _mapOf(invoice['payment']);
    final items = _listOfMaps(invoice['items']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _text(
                    invoice['invoiceNumber'] ??
                        invoice['invoiceNo'] ??
                        invoice['invoice_number'],
                    fallback: 'Invoice Details',
                  ),
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                _detailRow(
                  'Bill To',
                  _text(
                    billTo['name'] ??
                        invoice['customerName'] ??
                        invoice['customer_name'],
                  ),
                ),
                _detailRow(
                  'Phone',
                  _text(billTo['phone'] ?? invoice['phoneNumber']),
                ),
                _detailRow('Address', _text(billTo['address'])),
                _detailRow('Company', _text(company['name'])),
                _detailRow('GSTIN', _text(company['gstin'])),
                _detailRow(
                  'Supply',
                  _text(invoice['placeOfSupply'] ?? company['state']),
                ),
                _detailRow('Total', 'Rs ${_amountText(invoice)}'),
                _detailRow(
                  'Payment',
                  _text(
                    payment['paymentStatus'] ??
                        invoice['payment_status'] ??
                        invoice['paymentStatus'],
                    fallback: 'pending',
                  ),
                ),
                _detailRow(
                  'Status',
                  _text(invoice['status'], fallback: 'pending'),
                ),
                if (parts.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _sectionTitle('Parts'),
                  ...parts.map(_lineItem),
                ],
                if (items.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _sectionTitle('Items'),
                  ...items.map(_lineItem),
                ],
                if (services.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _sectionTitle('Services'),
                  ...services.map(_lineItem),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              context.trData(label),
              style: GoogleFonts.lato(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              context.trData(value.isEmpty ? 'N/A' : value),
              style: GoogleFonts.lato(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      context.trData(title),
      style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w700),
    );
  }

  Widget _lineItem(Map<String, dynamic> item) {
    final name = _text(
      item['itemName'] ??
          item['partName'] ??
          item['name'] ??
          item['serviceName'],
    );
    final amount = _text(
      item['pricePerUnit'] ?? item['cost'] ?? item['price'] ?? item['amount'],
    );
    final qty = _text(item['count'] ?? item['quantity']);
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        '${name.isEmpty ? 'Item' : name}${qty.isEmpty ? '' : ' x $qty'}${amount.isEmpty ? '' : ' - Rs $amount'}',
        style: GoogleFonts.lato(fontSize: 13),
      ),
    );
  }

  Future<File> _createInvoicePdf(Map<String, dynamic> invoice) async {
    final pdf = pw.Document();
    final parts = _listOfMaps(invoice['parts']);
    final services = _listOfMaps(invoice['services']);
    final invoiceItems = _listOfMaps(invoice['items']);
    final billTo = _mapOf(invoice['billTo']);
    final company = _mapOf(invoice['company']);
    final payment = _mapOf(invoice['payment']);
    final customerDetails = _mapOf(invoice['customerDetails']);
    final items = [...invoiceItems, ...parts, ...services];
    final logo = await _loadPdfImage('assets/logo.png');

    final invoiceNumber = _text(
      invoice['invoiceNumber'] ??
          invoice['invoiceNo'] ??
          invoice['invoice_number'] ??
          invoice['_id'] ??
          invoice['id'] ??
          invoice['invoiceId'],
      fallback: 'Invoice',
    );
    final customer = _text(
      billTo['name'] ??
          customerDetails['name'] ??
          invoice['customerName'] ??
          invoice['customer_name'] ??
          invoice['customer'],
      fallback: 'N/A',
    );
    final phone = _text(
      billTo['phone'] ??
          customerDetails['phone'] ??
          invoice['phoneNumber'] ??
          invoice['phone'],
      fallback: 'N/A',
    );
    final address = _text(
      billTo['address'] ?? customerDetails['address'],
      fallback: 'N/A',
    );
    final paymentStatus = _text(
      payment['paymentStatus'] ??
          invoice['payment_status'] ??
          invoice['paymentStatus'],
      fallback: 'pending',
    );
    final subtotal = _invoiceSubtotal(invoice, items);
    final discount = _num(payment['discount']);
    final tax = _num(payment['tax']);
    final total = _invoiceTotal(invoice, subtotal, discount, tax);
    final received = _num(payment['received']);
    final balance = (total - received).clamp(0, double.infinity).toDouble();
    final date = _text(
      invoice['invoiceDate'] ?? invoice['createdAt'] ?? invoice['date'],
      fallback: DateTime.now().toString().split(' ').first,
    );
    final terms = _text(
      invoice['termsAndConditions'],
      fallback: 'Thank you for doing business with us.',
    );

    pdf.addPage(
      pw.MultiPage(
        pageTheme: const pw.PageTheme(
          margin: pw.EdgeInsets.all(28),
          pageFormat: PdfPageFormat.a4,
        ),
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'Tax Invoice',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 10),
          _pdfBorderBox(
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(12),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (logo != null) pw.Image(logo, width: 58, height: 36),
                  if (logo != null) pw.SizedBox(width: 14),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          _text(
                            company['name'],
                            fallback: 'HORNVIN ENTERPRISES',
                          ),
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(_text(company['address'])),
                        pw.Text('Phone: ${_text(company['phone'])}'),
                        pw.Text('GSTIN: ${_text(company['gstin'])}'),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Email: ${_text(company['email'])}'),
                        pw.Text('State: ${_text(company['state'])}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _pdfTwoColumnBox(
            leftTitle: 'Bill To:',
            left: [
              _text(customer, fallback: 'N/A'),
              address,
              'Contact No: $phone',
              if (_text(billTo['email']).isNotEmpty)
                'Email: ${_text(billTo['email'])}',
              if (_text(billTo['gstin']).isNotEmpty)
                'GSTIN: ${_text(billTo['gstin'])}',
              if (_text(customerDetails['vehicleNumber']).isNotEmpty)
                'Vehicle No: ${_text(customerDetails['vehicleNumber'])}',
              if (_text(customerDetails['vehicleName']).isNotEmpty)
                'Vehicle: ${_text(customerDetails['vehicleName'])}',
              if (_text(customerDetails['vehicleModel']).isNotEmpty)
                'Model: ${_text(customerDetails['vehicleModel'])}',
              if (_text(customerDetails['odometerReading']).isNotEmpty)
                'Odometer: ${_text(customerDetails['odometerReading'])}',
            ],
            rightTitle: 'Invoice Details:',
            right: [
              'No: $invoiceNumber',
              'Date: ${_formatPdfDate(date)}',
              'Place of Supply: ${_text(invoice['placeOfSupply'] ?? company['state'])}',
              'Payment Mode: ${_text(payment['paymentMode'])}',
              'Payment Status: $paymentStatus',
            ],
          ),
          pw.SizedBox(height: 8),
          if (items.isEmpty)
            pw.Text('No line items available')
          else
            _pdfItemsTable(items),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(child: pw.SizedBox(height: 92)),
              pw.Container(
                width: 220,
                child: pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.blueGrey900),
                  columnWidths: const {
                    0: pw.FlexColumnWidth(1.2),
                    1: pw.FlexColumnWidth(1),
                  },
                  children: [
                    _pdfSummaryRow('Sub Total', _money(subtotal)),
                    if (discount > 0)
                      _pdfSummaryRow('Discount', _money(discount)),
                    if (tax > 0) _pdfSummaryRow('Tax', _money(tax)),
                    _pdfSummaryRow('Total', _money(total), strong: true),
                    _pdfSummaryRow('Received', _money(received)),
                    _pdfSummaryRow('Balance', _money(balance)),
                  ],
                ),
              ),
            ],
          ),
          _pdfBorderBox(
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Payment Mode:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(_text(payment['paymentMode'], fallback: 'N/A')),
                ],
              ),
            ),
          ),
          pw.SizedBox(height: 6),
          _pdfBorderBox(
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Terms And Conditions:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(terms),
                ],
              ),
            ),
          ),
          pw.Row(
            children: [
              pw.Expanded(child: pw.SizedBox()),
              pw.Container(
                width: 280,
                height: 82,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.blueGrey900),
                ),
                padding: const pw.EdgeInsets.all(6),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'For ${_text(company['name'], fallback: 'HORNVIN ENTERPRISES')}:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Spacer(),
                    pw.Center(child: pw.Text('Authorized Signatory')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final fileName = _safeFileName('invoice_${_suffix(invoiceNumber)}.pdf');
    final file = File('${directory.path}${Platform.pathSeparator}$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<pw.MemoryImage?> _loadPdfImage(String assetPath) async {
    try {
      final data = await rootBundle.load(assetPath);
      return pw.MemoryImage(data.buffer.asUint8List());
    } catch (_) {
      return null;
    }
  }

  pw.Widget _pdfBorderBox({required pw.Widget child}) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blueGrey900),
      ),
      child: child,
    );
  }

  pw.Widget _pdfTwoColumnBox({
    required String leftTitle,
    required List<String> left,
    required String rightTitle,
    required List<String> right,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.blueGrey900),
      columnWidths: const {0: pw.FlexColumnWidth(1), 1: pw.FlexColumnWidth(1)},
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _pdfCell(leftTitle, bold: true),
            _pdfCell(rightTitle, bold: true),
          ],
        ),
        pw.TableRow(
          children: [
            _pdfCell(left.where((value) => value.trim().isNotEmpty).join('\n')),
            _pdfCell(
              right.where((value) => value.trim().isNotEmpty).join('\n'),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _pdfItemsTable(List<Map<String, dynamic>> items) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.blueGrey900),
      columnWidths: const {
        0: pw.FixedColumnWidth(28),
        1: pw.FlexColumnWidth(2.3),
        2: pw.FixedColumnWidth(50),
        3: pw.FixedColumnWidth(58),
        4: pw.FixedColumnWidth(50),
        5: pw.FixedColumnWidth(72),
        6: pw.FixedColumnWidth(72),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _pdfCell('#', bold: true, align: pw.TextAlign.center),
            _pdfCell('Item Name', bold: true),
            _pdfCell('Count', bold: true, align: pw.TextAlign.right),
            _pdfCell('Quantity', bold: true, align: pw.TextAlign.right),
            _pdfCell('Unit', bold: true, align: pw.TextAlign.right),
            _pdfCell('Price/ Unit', bold: true, align: pw.TextAlign.right),
            _pdfCell('Amount', bold: true, align: pw.TextAlign.right),
          ],
        ),
        ...items.asMap().entries.map((entry) {
          final item = entry.value;
          return pw.TableRow(
            children: [
              _pdfCell('${entry.key + 1}', align: pw.TextAlign.center),
              _pdfCell(_pdfItemName(item)),
              _pdfCell(_countText(item), align: pw.TextAlign.right),
              _pdfCell(_quantityText(item), align: pw.TextAlign.right),
              _pdfCell(_text(item['unit']), align: pw.TextAlign.right),
              _pdfCell(_money(_rate(item)), align: pw.TextAlign.right),
              _pdfCell(
                _money(_lineTotal(item) ?? 0),
                align: pw.TextAlign.right,
              ),
            ],
          );
        }),
        pw.TableRow(
          children: [
            _pdfCell(''),
            _pdfCell('Total', bold: true),
            _pdfCell(
              _numberText(
                items.fold<double>(0, (sum, item) => sum + _num(item['count'])),
              ),
              bold: true,
              align: pw.TextAlign.right,
            ),
            _pdfCell(
              _numberText(
                items.fold<double>(0, (sum, item) => sum + _quantity(item)),
              ),
              bold: true,
              align: pw.TextAlign.right,
            ),
            _pdfCell(''),
            _pdfCell(''),
            _pdfCell(
              _money(
                items.fold<double>(
                  0,
                  (sum, item) => sum + (_lineTotal(item) ?? 0),
                ),
              ),
              bold: true,
              align: pw.TextAlign.right,
            ),
          ],
        ),
      ],
    );
  }

  pw.TableRow _pdfSummaryRow(
    String label,
    String value, {
    bool strong = false,
  }) {
    final style = pw.TextStyle(
      fontSize: 9,
      fontWeight: strong ? pw.FontWeight.bold : pw.FontWeight.normal,
    );
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(label, style: style),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(value, textAlign: pw.TextAlign.right, style: style),
        ),
      ],
    );
  }

  pw.Widget _pdfCell(
    String value, {
    bool bold = false,
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        value,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: 8.5,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  String _pdfItemName(Map<String, dynamic> item) {
    final name = _text(
      item['itemName'] ??
          item['partName'] ??
          item['serviceName'] ??
          item['name'] ??
          item['title'],
      fallback: 'Item',
    );
    final description = _text(item['description']);
    return description.isEmpty ? name : '$name\n($description)';
  }

  String _countText(Map<String, dynamic> item) {
    return _numberText(_num(item['count']));
  }

  String _quantityText(Map<String, dynamic> item) {
    return _numberText(_quantity(item));
  }

  double _quantity(Map<String, dynamic> item) {
    final quantity = _num(item['quantity'] ?? item['qty']);
    return quantity > 0 ? quantity : 1;
  }

  double _rate(Map<String, dynamic> item) {
    return _num(
      item['pricePerUnit'] ??
          item['rate'] ??
          item['price'] ??
          item['cost'] ??
          item['amount'],
    );
  }

  double _invoiceSubtotal(
    Map<String, dynamic> invoice,
    List<Map<String, dynamic>> items,
  ) {
    final direct = _num(invoice['subTotal'] ?? invoice['subtotal']);
    if (direct > 0) return direct;
    return items.fold<double>(0, (sum, item) => sum + (_lineTotal(item) ?? 0));
  }

  double _invoiceTotal(
    Map<String, dynamic> invoice,
    double subtotal,
    double discount,
    double tax,
  ) {
    final direct = _num(
      invoice['totalAmount'] ??
          invoice['total_amount'] ??
          invoice['totalPrice'] ??
          invoice['grandTotal'] ??
          invoice['amount'] ??
          invoice['total'],
    );
    return direct > 0 ? direct : subtotal - discount + tax;
  }

  String _money(double value) {
    return 'Rs ${_numberText(value)}';
  }

  String _numberText(double value) {
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value.toStringAsFixed(2);
  }

  String _formatPdfDate(String value) {
    final parts = value.split('T').first.split('-');
    if (parts.length == 3 && parts.first.length == 4) {
      return '${parts[2]}-${parts[1]}-${parts[0]}';
    }
    return value;
  }

  String _amountText(Map<String, dynamic> invoice) {
    final direct = _text(
      invoice['totalAmount'] ??
          invoice['total_amount'] ??
          invoice['totalPrice'] ??
          invoice['grandTotal'] ??
          invoice['amount'] ??
          invoice['total'],
    );
    if (direct.isNotEmpty) return direct;

    final itemTotal = _listOfMaps(
      invoice['items'],
    ).fold<double>(0, (sum, item) => sum + (_lineTotal(item) ?? 0));
    return itemTotal.toStringAsFixed(2);
  }

  String _safeFileName(String value) {
    return value.replaceAll(RegExp(r'[\\/:*?"<>|]+'), '_');
  }

  List<Map<String, dynamic>> _listOfMaps(dynamic value) {
    if (value is! List) return const [];
    return value.whereType<Map>().map(Map<String, dynamic>.from).toList();
  }

  Map<String, dynamic> _mapOf(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return {};
  }

  double _num(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  double? _lineTotal(Map<String, dynamic> item) {
    final direct = _num(
      item['total'] ?? item['totalAmount'] ?? item['lineTotal'],
    );
    if (direct > 0) return direct;
    final total = _quantity(item) * _rate(item);
    return total > 0 ? total : null;
  }

  void _showMessage(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  String _idOf(Map<String, dynamic> data) =>
      _text(data['_id'] ?? data['id'] ?? data['invoiceId']);

  String _suffix(String value) {
    if (value.isEmpty) return 'INV';
    return value.length <= 4 ? value : value.substring(value.length - 4);
  }

  String _text(dynamic value, {String fallback = ''}) {
    final text = value?.toString() ?? '';
    return text.isEmpty ? fallback : text;
  }
}
