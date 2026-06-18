import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/repositories/invoice_repository.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';
import 'package:hornvin/localization/app_localizations.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BillPaymentScreen extends StatefulWidget {
  const BillPaymentScreen({super.key});

  @override
  State<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  final InvoiceRepository _repository = InvoiceRepository();

  List<Map<String, dynamic>> _invoices = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBillingData();
  }

  Future<void> _loadBillingData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        _repository.getInvoices(limit: 100),
        _repository.getRevenueStats(),
      ]);

      if (!mounted) return;
      setState(() {
        _invoices = List<Map<String, dynamic>>.from(results[0] as List);
        _stats = Map<String, dynamic>.from(results[1] as Map);
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.scaffold,
      child: RefreshIndicator(
        onRefresh: _loadBillingData,
        color: AppColors.primary,
        child: _isLoading
            ? ListView(
                padding: const EdgeInsets.all(16),
                children: List.generate(4, (_) => _buildLoadingBox()),
              )
            : _errorMessage != null
            ? ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildStateBox(
                    icon: Icons.error_outline_rounded,
                    titleKey: 'billing_load_error',
                    message: _errorMessage!,
                    actionTextKey: 'retry',
                    onTap: _loadBillingData,
                  ),
                ],
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 12),
                  _buildScannerOption(),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.95,
                    children: [
                      _BillingBox(
                        titleKey: 'total_business',
                        value: '₹${_formatAmount(_totalBusiness)}',
                        subtitleKey:
                            '${_invoices.length} bills', // Needs dynamic translation if required
                        icon: Icons.business_center_rounded,
                        color: const Color(0xFF1A237E),
                        onTap: _showBusinessDetails,
                      ),
                      _BillingBox(
                        titleKey: 'bill_generator',
                        value: 'Create', // Can be localized if needed
                        subtitleKey: 'New invoice',
                        icon: Icons.add_card_rounded,
                        color: const Color(0xFFE31E24),
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/create_invoice',
                        ).then((_) => _loadBillingData()),
                      ),
                      _BillingBox(
                        titleKey: 'total_pending',
                        value: '₹${_formatAmount(_pendingAmount)}',
                        subtitleKey: '${_pendingInvoices.length} pending',
                        icon: Icons.pending_actions_rounded,
                        color: Colors.orange.shade700,
                        onTap: () => _showInvoiceEnquiry(
                          titleKey: 'pending',
                          invoices: _pendingInvoices,
                        ),
                      ),
                      _BillingBox(
                        titleKey: 'bill_to_pay_enquiry',
                        value: _pendingInvoices.length.toString(),
                        subtitleKey: 'Check & update',
                        icon: Icons.manage_search_rounded,
                        color: Colors.green.shade700,
                        onTap: () => _showInvoiceEnquiry(
                          titleKey: 'bill_to_pay_enquiry',
                          invoices: _pendingInvoices.isEmpty
                              ? _invoices
                              : _pendingInvoices,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _buildStateBox(
                    icon: Icons.receipt_long_rounded,
                    titleKey: 'view_all_bills',
                    messageKey: 'view_all_bills_subtitle',
                    actionTextKey: 'view_all',
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/view_invoices',
                    ).then((_) => _loadBillingData()),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.payments_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('billing_dashboard'),
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  context.tr('billing_subtitle'),
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loadBillingData,
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerOption() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: _openGarageQrScanner,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.14)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.qr_code_scanner_rounded,
                  color: AppColors.primary,
                  size: 31,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scan Garage QR',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Garage payment QR scan karke bill pay kare',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Scan',
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openGarageQrScanner() async {
    final scannedValue = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const _GaragePaymentQrScannerPage()),
    );

    if (!mounted || scannedValue == null || scannedValue.trim().isEmpty) {
      return;
    }

    _showGarageQrPaymentSheet(_parseGaragePaymentQr(scannedValue));
  }

  _GaragePaymentQrPayload _parseGaragePaymentQr(String rawValue) {
    final raw = rawValue.trim();
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        return _GaragePaymentQrPayload(
          rawValue: raw,
          invoiceId: _firstPayloadText(decoded, [
            'invoice_id',
            'invoiceId',
            'bill_id',
            'billId',
            'id',
            '_id',
          ]),
          amount: _firstPayloadInt(decoded, [
            'amount',
            'totalAmount',
            'total_amount',
            'grandTotal',
            'total',
          ]),
          customerName: _firstPayloadText(decoded, [
            'customer',
            'customerName',
            'name',
          ]),
          vehicleNumber: _firstPayloadText(decoded, [
            'vehicle',
            'vehicleNumber',
            'vehicle_no',
          ]),
        );
      }
    } catch (_) {}

    final invoiceMatch = RegExp(
      r'(?:invoice|bill|id)[\s:=#-]+([A-Za-z0-9_\-]+)',
      caseSensitive: false,
    ).firstMatch(raw);
    final amountMatch = RegExp(
      r'(?:amount|amt|total|rs|inr)[\s:=₹-]+(\d+)',
      caseSensitive: false,
    ).firstMatch(raw);

    return _GaragePaymentQrPayload(
      rawValue: raw,
      invoiceId: invoiceMatch?.group(1) ?? raw,
      amount: int.tryParse(amountMatch?.group(1) ?? ''),
    );
  }

  String? _firstPayloadText(Map<dynamic, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty && text != 'null') return text;
    }
    return null;
  }

  int? _firstPayloadInt(Map<dynamic, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      final parsed = int.tryParse(value?.toString() ?? '');
      if (parsed != null) return parsed;
    }
    return null;
  }

  Map<String, dynamic>? _findInvoiceForQr(_GaragePaymentQrPayload payload) {
    final scannedId = payload.invoiceId?.toLowerCase().trim();
    if (scannedId != null && scannedId.isNotEmpty) {
      for (final invoice in _invoices) {
        final id = _idOf(invoice).toLowerCase();
        if (id == scannedId || id.endsWith(scannedId)) return invoice;
      }
    }

    final amount = payload.amount;
    if (amount != null) {
      final matches = _pendingInvoices
          .where((invoice) => _amountOf(invoice) == amount)
          .toList();
      if (matches.length == 1) return matches.first;
    }

    return null;
  }

  void _showGarageQrPaymentSheet(_GaragePaymentQrPayload payload) {
    final matchedInvoice = _findInvoiceForQr(payload);
    final pendingInvoices = _pendingInvoices;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.64,
            minChildSize: 0.38,
            maxChildSize: 0.88,
            builder: (context, scrollController) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: _sheetHandle()),
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.qr_code_2_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                matchedInvoice == null
                                    ? 'QR Scan Result'
                                    : 'Bill matched from QR',
                                style: GoogleFonts.lato(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                payload.invoiceId == null
                                    ? 'Scanned payment QR'
                                    : 'Invoice: ${payload.invoiceId}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (matchedInvoice != null) ...[
                      _buildQrMatchedInvoiceCard(sheetContext, matchedInvoice),
                    ] else ...[
                      _buildQrPayloadCard(payload),
                      const SizedBox(height: 12),
                      Text(
                        'Pending Bills',
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: pendingInvoices.isEmpty
                            ? Center(
                                child: Text(
                                  context.tr('no_pending_bills'),
                                  style: GoogleFonts.lato(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                controller: scrollController,
                                itemCount: pendingInvoices.length,
                                itemBuilder: (context, index) {
                                  final invoice = pendingInvoices[index];
                                  return _buildQrSelectableInvoiceTile(
                                    sheetContext,
                                    invoice,
                                  );
                                },
                              ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildQrPayloadCard(_GaragePaymentQrPayload payload) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5EAF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _qrInfoLine('Invoice', payload.invoiceId ?? 'Not found'),
          _qrInfoLine(
            'Amount',
            payload.amount == null ? 'Not found' : '₹${_formatAmount(payload.amount!)}',
          ),
          _qrInfoLine('Customer', payload.customerName ?? 'Not found'),
          _qrInfoLine('Vehicle', payload.vehicleNumber ?? 'Not found'),
          const SizedBox(height: 8),
          Text(
            payload.rawValue,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrMatchedInvoiceCard(
    BuildContext sheetContext,
    Map<String, dynamic> invoice,
  ) {
    final id = _idOf(invoice);
    final customer = _text(invoice['customerName'] ?? invoice['customer']);
    final vehicle = _text(invoice['vehicleNumber'], fallback: 'Vehicle N/A');
    final amount = _amountOf(invoice);
    final isPaid = _statusOf(invoice) == 'paid';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5EAF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _qrInfoLine('Customer', customer.isEmpty ? 'Customer' : customer),
          _qrInfoLine('Vehicle', vehicle),
          _qrInfoLine('Bill', id.isEmpty ? 'N/A' : _shortId(id)),
          _qrInfoLine('Amount', '₹${_formatAmount(amount)}'),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
                  isPaid || id.isEmpty ? null : () => _markInvoicePaid(sheetContext, id),
              icon: Icon(isPaid ? Icons.verified_rounded : Icons.payments_rounded),
              label: Text(isPaid ? 'Already Paid' : 'Mark Paid'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrSelectableInvoiceTile(
    BuildContext sheetContext,
    Map<String, dynamic> invoice,
  ) {
    final id = _idOf(invoice);
    final customer = _text(invoice['customerName'] ?? invoice['customer']);
    final vehicle = _text(invoice['vehicleNumber'], fallback: 'Vehicle N/A');
    final amount = _amountOf(invoice);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long_rounded, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.isEmpty ? 'Customer' : customer,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$vehicle | ₹${_formatAmount(amount)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: id.isEmpty ? null : () => _markInvoicePaid(sheetContext, id),
            child: const Text('Pay'),
          ),
        ],
      ),
    );
  }

  Widget _qrInfoLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          SizedBox(
            width: 78,
            child: Text(
              label,
              style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateBox({
    required IconData icon,
    required String titleKey,
    String? message,
    String? messageKey,
    required String actionTextKey,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr(titleKey),
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message ?? context.tr(messageKey ?? ''),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                context.tr(actionTextKey),
                style: GoogleFonts.lato(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingBox() {
    return Container(
      height: 126,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 16),
          Container(width: 160, height: 14, color: AppColors.lightGrey),
          const SizedBox(height: 8),
          Container(width: 110, height: 10, color: AppColors.lightGrey),
        ],
      ),
    );
  }

  void _showBusinessDetails() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _sheetHandle(),
                _detailRow(
                  'total_business',
                  '₹${_formatAmount(_totalBusiness)}',
                ),
                _detailRow('paid_business', '₹${_formatAmount(_paidAmount)}'),
                _detailRow(
                  'pending_amount',
                  '₹${_formatAmount(_pendingAmount)}',
                ),
                _detailRow('generated_bills', _invoices.length.toString()),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      '/view_invoices',
                    ).then((_) => _loadBillingData());
                  },
                  icon: const Icon(Icons.receipt_long_rounded),
                  label: Text(context.tr('view_bills')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showInvoiceEnquiry({
    required String titleKey,
    required List<Map<String, dynamic>> invoices,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.72,
            minChildSize: 0.42,
            maxChildSize: 0.92,
            builder: (context, scrollController) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  children: [
                    _sheetHandle(),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            context.tr(titleKey),
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                              context,
                              '/view_invoices',
                            ).then((_) => _loadBillingData());
                          },
                          icon: const Icon(Icons.open_in_new_rounded, size: 16),
                          label: Text(context.tr('all')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: invoices.isEmpty
                          ? Center(
                              child: Text(
                                context.tr('no_pending_bills'),
                                style: GoogleFonts.lato(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            )
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: invoices.length,
                              itemBuilder: (context, index) {
                                return _buildInvoiceTile(invoices[index]);
                              },
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildInvoiceTile(Map<String, dynamic> invoice) {
    final id = _idOf(invoice);
    final customer = _text(invoice['customerName'] ?? invoice['customer']);
    final vehicle = _text(invoice['vehicleNumber'], fallback: 'Vehicle N/A');
    final total = _amountOf(invoice);
    final status = _statusOf(invoice);
    final isPaid = status == 'paid';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (isPaid ? Colors.green : Colors.orange).withValues(
                alpha: 0.10,
              ),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              isPaid ? Icons.verified_rounded : Icons.schedule_rounded,
              color: isPaid ? Colors.green : Colors.orange.shade700,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.trData(customer.isEmpty ? 'Customer' : customer),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$vehicle - ${id.isEmpty ? 'Bill' : _shortId(id)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${_formatAmount(total)}',
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: isPaid || id.isEmpty
                    ? null
                    : () => _markInvoicePaid(context, id),
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 30),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: Text(isPaid ? 'Paid' : 'Pay'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _markInvoicePaid(BuildContext sheetContext, String id) async {
    try {
      await _repository.updatePaymentStatus(id: id, paymentStatus: 'paid');
      if (!mounted || !sheetContext.mounted) return;
      Navigator.pop(sheetContext);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('bill_payment_updated_msg'))),
      );
      await _loadBillingData();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context
                .tr('payment_update_failed_msg')
                .replaceAll('{error}', error.toString()),
          ),
        ),
      );
    }
  }

  Widget _sheetHandle() {
    return Container(
      width: 42,
      height: 4,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }

  Widget _detailRow(String labelKey, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.tr(labelKey),
            style: GoogleFonts.lato(color: AppColors.textSecondary),
          ),
          Text(
            context.trData(value),
            style: GoogleFonts.lato(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get _pendingInvoices =>
      _invoices.where((invoice) => _statusOf(invoice) != 'paid').toList();

  int get _totalBusiness {
    final statValue = _firstInt([
      _stats['totalBusiness'],
      _stats['totalRevenue'],
      _stats['totalAmount'],
      _stats['revenue'],
    ]);
    if (statValue > 0) return statValue;
    return _invoices.fold(0, (sum, invoice) => sum + _amountOf(invoice));
  }

  int get _pendingAmount =>
      _pendingInvoices.fold(0, (sum, invoice) => sum + _amountOf(invoice));

  int get _paidAmount => _invoices
      .where((invoice) => _statusOf(invoice) == 'paid')
      .fold(0, (sum, invoice) => sum + _amountOf(invoice));

  int _amountOf(Map<String, dynamic> invoice) {
    return _firstInt([
      invoice['totalAmount'],
      invoice['total_amount'],
      invoice['totalPrice'],
      invoice['amount'],
      invoice['total'],
      invoice['grandTotal'],
    ]);
  }

  int _firstInt(List<dynamic> values) {
    for (final value in values) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      final parsed = int.tryParse(value?.toString() ?? '');
      if (parsed != null) return parsed;
    }
    return 0;
  }

  String _statusOf(Map<String, dynamic> invoice) {
    return _text(
      invoice['payment_status'] ??
          invoice['paymentStatus'] ??
          invoice['status'],
      fallback: 'pending',
    ).toLowerCase();
  }

  String _idOf(Map<String, dynamic> invoice) {
    return _text(invoice['_id'] ?? invoice['id'] ?? invoice['invoiceId']);
  }

  String _text(dynamic value, {String fallback = ''}) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text == 'null' ? fallback : text;
  }

  String _shortId(String id) {
    final visible = id.length > 6 ? id.substring(id.length - 6) : id;
    return '#${visible.toUpperCase()}';
  }

  String _formatAmount(int value) {
    final text = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      final fromEnd = text.length - i;
      buffer.write(text[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
    }
    return buffer.toString();
  }
}

class _GaragePaymentQrPayload {
  final String rawValue;
  final String? invoiceId;
  final int? amount;
  final String? customerName;
  final String? vehicleNumber;

  const _GaragePaymentQrPayload({
    required this.rawValue,
    this.invoiceId,
    this.amount,
    this.customerName,
    this.vehicleNumber,
  });
}

class _GaragePaymentQrScannerPage extends StatefulWidget {
  const _GaragePaymentQrScannerPage();

  @override
  State<_GaragePaymentQrScannerPage> createState() =>
      _GaragePaymentQrScannerPageState();
}

class _GaragePaymentQrScannerPageState
    extends State<_GaragePaymentQrScannerPage> {
  late final MobileScannerController _controller;
  bool _isHandlingScan = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      formats: const [BarcodeFormat.qrCode],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.black,
        elevation: 0,
        title: Text(
          'Scan Garage QR',
          style: GoogleFonts.lato(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            onPressed: () => _controller.toggleTorch(),
            icon: const Icon(Icons.flash_on_rounded),
            tooltip: 'Flash',
          ),
          IconButton(
            onPressed: () => _controller.switchCamera(),
            icon: const Icon(Icons.cameraswitch_rounded),
            tooltip: 'Switch camera',
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            fit: BoxFit.cover,
            onDetect: _handleDetectedBarcode,
            errorBuilder: (context, error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Camera open nahi ho pa raha. Permission check kare ya Test QR use kare.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      height: 1.35,
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _GarageQrScanFramePainter()),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 28,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Text(
                    'Garage payment QR ko frame ke andar rakhe. Scan ke baad bill match/pay option dikhega.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _openTestQrDialog,
                    icon: const Icon(Icons.keyboard_rounded),
                    label: const Text('Test QR'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleDetectedBarcode(BarcodeCapture capture) {
    if (_isHandlingScan) return;

    final rawValue = capture.barcodes
        .map((barcode) => barcode.rawValue?.trim())
        .whereType<String>()
        .where((value) => value.isNotEmpty)
        .firstOrNull;

    if (rawValue == null) return;

    _isHandlingScan = true;
    Navigator.pop(context, rawValue);
  }

  Future<void> _openTestQrDialog() async {
    final controller = TextEditingController(
      text: '{"invoiceId":"TEST-BILL-001","amount":500}',
    );
    final value = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Test Garage QR',
            style: GoogleFonts.lato(fontWeight: FontWeight.w900),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: '{"invoiceId":"...","amount":500}',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Use'),
            ),
          ],
        );
      },
    );
    controller.dispose();

    if (!mounted || value == null || value.trim().isEmpty) return;
    Navigator.pop(context, value.trim());
  }
}

class _GarageQrScanFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.48)
      ..style = PaintingStyle.fill;
    final frameSize = (size.width * 0.72).clamp(220.0, 310.0);
    final frameRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.42),
      width: frameSize,
      height: frameSize,
    );
    final fullPath = Path()..addRect(Offset.zero & size);
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(frameRect, const Radius.circular(22)),
      );
    canvas.drawPath(
      Path.combine(PathOperation.difference, fullPath, cutoutPath),
      overlayPaint,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRRect(
      RRect.fromRectAndRadius(frameRect, const Radius.circular(22)),
      borderPaint,
    );

    final cornerPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    const cornerLength = 34.0;
    final corners = [
      (frameRect.topLeft, 1, 1),
      (frameRect.topRight, -1, 1),
      (frameRect.bottomLeft, 1, -1),
      (frameRect.bottomRight, -1, -1),
    ];
    for (final corner in corners) {
      final point = corner.$1;
      final horizontalDirection = corner.$2;
      final verticalDirection = corner.$3;
      canvas.drawLine(
        point,
        point + Offset(cornerLength * horizontalDirection, 0),
        cornerPaint,
      );
      canvas.drawLine(
        point,
        point + Offset(0, cornerLength * verticalDirection),
        cornerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BillingBox extends StatelessWidget {
  final String titleKey;
  final String value;
  final String subtitleKey;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _BillingBox({
    required this.titleKey,
    required this.value,
    required this.subtitleKey,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const Spacer(),
              Text(
                context.trData(value),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                context.tr(titleKey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                context.trData(
                  subtitleKey,
                ), // Since it might contain numbers, use trData
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
