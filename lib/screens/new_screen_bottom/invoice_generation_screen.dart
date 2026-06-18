import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/localization/app_localizations.dart';
import 'package:hornvin/models/job_model/job_model.dart';
import 'package:hornvin/repositories/invoice_repository.dart';
import 'package:hornvin/repositories/job_repository.dart';
import 'package:hornvin/screens/new_screen_bottom/invoice_view_screen.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';

class InvoiceGenerationScreen extends StatefulWidget {
  const InvoiceGenerationScreen({super.key});

  @override
  State<InvoiceGenerationScreen> createState() =>
      _InvoiceGenerationScreenState();
}

class _InvoiceGenerationScreenState extends State<InvoiceGenerationScreen> {
  final InvoiceRepository _repository = InvoiceRepository();
  final JobRepository _jobRepository = JobRepository();
  final _formKey = GlobalKey<FormState>();

  final _jobCardIdController = TextEditingController();
  final _invoiceDateController = TextEditingController(text: '2026-05-24');
  final _placeOfSupplyController = TextEditingController(text: '07-Delhi');
  final _billNameController = TextEditingController(text: 'Mohit car centre');
  final _billAddressController = TextEditingController(text: 'Bhopura');
  final _billPhoneController = TextEditingController(text: '9760081892');
  final _billEmailController = TextEditingController();
  final _billGstinController = TextEditingController();
  final _companyNameController = TextEditingController(
    text: 'HORNVIN ENTERPRISES',
  );
  final _companyAddressController = TextEditingController(
    text: 'Amar Colony, Lajpat Nagar IV New Delhi',
  );
  final _companyPhoneController = TextEditingController(text: '9625910869');
  final _companyEmailController = TextEditingController(
    text: 'support.hornvin@gmail.com',
  );
  final _companyGstinController = TextEditingController(
    text: '07BHQPJ1731F1ZF',
  );
  final _companyStateController = TextEditingController(text: '07-Delhi');
  final _paymentModeController = TextEditingController(text: 'Cash');
  final _discountController = TextEditingController(text: '0');
  final _taxController = TextEditingController(text: '0');
  final _receivedController = TextEditingController(text: '2000');
  final _paymentStatusController = TextEditingController(text: 'Partial');
  final _termsController = TextEditingController(
    text: 'Thank you for doing business with us.',
  );

  final List<_InvoiceItemForm> _items = [_InvoiceItemForm.sample()];

  bool _isSubmitting = false;
  bool _isLoadingJobs = true;
  List<Job> _jobs = [];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  @override
  void dispose() {
    for (final controller in [
      _jobCardIdController,
      _invoiceDateController,
      _placeOfSupplyController,
      _billNameController,
      _billAddressController,
      _billPhoneController,
      _billEmailController,
      _billGstinController,
      _companyNameController,
      _companyAddressController,
      _companyPhoneController,
      _companyEmailController,
      _companyGstinController,
      _companyStateController,
      _paymentModeController,
      _discountController,
      _taxController,
      _receivedController,
      _paymentStatusController,
      _termsController,
    ]) {
      controller.dispose();
    }
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
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
          context.trText('Create Invoice'),
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
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _section(
              title: 'Invoice Details',
              icon: Icons.receipt_long_rounded,
              child: Column(
                children: [
                  _jobCardField(),
                  _field(_invoiceDateController, 'Invoice Date'),
                  _field(_placeOfSupplyController, 'Place Of Supply'),
                ],
              ),
            ),
            _section(
              title: 'Bill To',
              icon: Icons.person_outline_rounded,
              child: Column(
                children: [
                  _field(_billNameController, 'Name'),
                  _field(_billAddressController, 'Address'),
                  _field(_billPhoneController, 'Phone'),
                  _field(_billEmailController, 'Email', isRequired: false),
                  _field(_billGstinController, 'GSTIN', isRequired: false),
                ],
              ),
            ),
            _section(
              title: 'Company',
              icon: Icons.business_outlined,
              child: Column(
                children: [
                  _field(_companyNameController, 'Company Name'),
                  _field(_companyAddressController, 'Company Address'),
                  _field(_companyPhoneController, 'Company Phone'),
                  _field(_companyEmailController, 'Company Email'),
                  _field(_companyGstinController, 'Company GSTIN'),
                  _field(_companyStateController, 'Company State'),
                ],
              ),
            ),
            _section(
              title: 'Items',
              icon: Icons.inventory_2_outlined,
              action: TextButton.icon(
                onPressed: _addItem,
                icon: const Icon(Icons.add, size: 18),
                label: Text(context.trText('Add Item')),
              ),
              child: Column(
                children: List.generate(
                  _items.length,
                  (index) => _itemCard(index),
                ),
              ),
            ),
            _section(
              title: 'Payment',
              icon: Icons.payments_outlined,
              child: Column(
                children: [
                  _field(_paymentModeController, 'Payment Mode'),
                  Row(
                    children: [
                      Expanded(child: _field(_discountController, 'Discount')),
                      const SizedBox(width: 10),
                      Expanded(child: _field(_taxController, 'Tax')),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _field(_receivedController, 'Received')),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _field(
                          _paymentStatusController,
                          'Payment Status',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _section(
              title: 'Terms',
              icon: Icons.description_outlined,
              child: _field(_termsController, 'Terms And Conditions', lines: 3),
            ),
            _summaryCard(),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _createInvoice,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(
                context.trText(
                  _isSubmitting ? 'Creating...' : 'Create Invoice',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    required Widget child,
    Widget? action,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.75)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.trText(title),
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (action != null) action,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    bool isRequired = true,
    int lines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        minLines: lines,
        maxLines: lines,
        keyboardType: _keyboardType(label),
        decoration: InputDecoration(
          labelText: context.trText(label),
          filled: true,
          fillColor: AppColors.lightGrey,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
        ),
        validator: isRequired
            ? (value) =>
                  value == null || value.trim().isEmpty ? 'Required' : null
            : null,
      ),
    );
  }

  Widget _jobCardField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: _jobCardIdController,
        readOnly: true,
        onTap: _isLoadingJobs ? null : _showJobPicker,
        decoration: InputDecoration(
          labelText: _isLoadingJobs
              ? context.trText('Loading job cards...')
              : context.trText('Select Job Card'),
          filled: true,
          fillColor: AppColors.lightGrey,
          prefixIcon: const Icon(Icons.assignment_outlined),
          suffixIcon: _isLoadingJobs
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  onPressed: _showJobPicker,
                  icon: const Icon(Icons.arrow_drop_down_rounded),
                ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
        ),
        validator: (_) =>
            _jobCardIdController.text.trim().isEmpty ? 'Select job card' : null,
      ),
    );
  }

  Widget _itemCard(int index) {
    final item = _items[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${context.trText('Item')} ${index + 1}',
                  style: GoogleFonts.lato(fontWeight: FontWeight.w700),
                ),
              ),
              if (_items.length > 1)
                IconButton(
                  onPressed: () => _removeItem(index),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
            ],
          ),
          _field(item.itemName, 'Item Name'),
          _field(item.description, 'Description', lines: 3),
          Row(
            children: [
              Expanded(child: _field(item.count, 'Count')),
              const SizedBox(width: 10),
              Expanded(child: _field(item.quantity, 'Quantity')),
            ],
          ),
          Row(
            children: [
              Expanded(child: _field(item.unit, 'Unit')),
              const SizedBox(width: 10),
              Expanded(child: _field(item.pricePerUnit, 'Price Per Unit')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryCard() {
    final subtotal = _subtotal;
    final received = _num(_receivedController.text);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _summaryRow('Subtotal', 'Rs ${subtotal.toStringAsFixed(2)}'),
          _summaryRow('Received', 'Rs ${received.toStringAsFixed(2)}'),
          const Divider(color: Colors.white24),
          _summaryRow(
            'Balance',
            'Rs ${(subtotal - received).toStringAsFixed(2)}',
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.trText(label),
            style: GoogleFonts.lato(color: Colors.white70),
          ),
          Text(
            value,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: bold ? 17 : 14,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _addItem() {
    setState(() => _items.add(_InvoiceItemForm.empty()));
  }

  void _removeItem(int index) {
    final item = _items.removeAt(index);
    item.dispose();
    setState(() {});
  }

  Future<void> _createInvoice() async {
    if (!_formKey.currentState!.validate()) return;
    if (_items.isEmpty) {
      _message('Please add at least one item', Colors.red);
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final payload = _payload();
      await _repository.createInvoicePayload(payload);
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      _message('Invoice created successfully', Colors.green);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const InvoiceViewScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      _message('Invoice create failed: $e', Colors.red);
    }
  }

  Future<void> _loadJobs() async {
    setState(() => _isLoadingJobs = true);
    try {
      final response = await _jobRepository.getAllJobs(page: 1, limit: 100);
      if (!mounted) return;
      setState(() {
        _jobs = response.jobs;
        _isLoadingJobs = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingJobs = false);
      _message('Job cards load failed: $e', Colors.red);
    }
  }

  void _showJobPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: _jobs.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.assignment_outlined, size: 42),
                      const SizedBox(height: 12),
                      Text(
                        context.trText('No created jobs found'),
                        style: GoogleFonts.lato(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _loadJobs();
                        },
                        icon: const Icon(Icons.refresh),
                        label: Text(context.trText('Retry')),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _jobs.length,
                  separatorBuilder: (_, _) => const Divider(),
                  itemBuilder: (context, index) {
                    final job = _jobs[index];
                    final title = job.jobCardId.isEmpty
                        ? job.id
                        : job.jobCardId;
                    return ListTile(
                      leading: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.assignment_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(
                        title,
                        style: GoogleFonts.lato(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        [
                          job.customerName,
                          job.phoneNumber,
                          job.vehicleNumber,
                        ].where((value) => value.trim().isNotEmpty).join(' - '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(fontSize: 12),
                      ),
                      onTap: () {
                        _selectJob(job);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
        );
      },
    );
  }

  void _selectJob(Job job) {
    final address = job.address == null
        ? ''
        : [
                job.address?['address'],
                job.address?['city'],
                job.address?['state'],
                job.address?['pincode'],
              ]
              .where(
                (value) => value != null && value.toString().trim().isNotEmpty,
              )
              .join(', ');
    setState(() {
      _jobCardIdController.text = job.jobCardId.isNotEmpty
          ? job.jobCardId
          : job.id;
      _billNameController.text = job.customerName;
      _billPhoneController.text = job.phoneNumber;
      if (address.isNotEmpty) _billAddressController.text = address;
    });
  }

  Map<String, dynamic> _payload() {
    return {
      'jobCardId': _jobCardIdController.text.trim(),
      'invoiceDate': _invoiceDateController.text.trim(),
      'placeOfSupply': _placeOfSupplyController.text.trim(),
      'billTo': {
        'name': _billNameController.text.trim(),
        'address': _billAddressController.text.trim(),
        'phone': _billPhoneController.text.trim(),
        'email': _billEmailController.text.trim(),
        'gstin': _billGstinController.text.trim(),
      },
      'company': {
        'name': _companyNameController.text.trim(),
        'address': _companyAddressController.text.trim(),
        'phone': _companyPhoneController.text.trim(),
        'email': _companyEmailController.text.trim(),
        'gstin': _companyGstinController.text.trim(),
        'state': _companyStateController.text.trim(),
      },
      'items': _items.map((item) => item.toJson()).toList(),
      'payment': {
        'paymentMode': _paymentModeController.text.trim(),
        'discount': _num(_discountController.text),
        'tax': _num(_taxController.text),
        'received': _num(_receivedController.text),
        'paymentStatus': _paymentStatusController.text.trim(),
      },
      'termsAndConditions': _termsController.text.trim(),
    };
  }

  double get _subtotal {
    return _items.fold<double>(0, (sum, item) {
      return sum + (_num(item.count.text) * _num(item.pricePerUnit.text));
    });
  }

  double _num(String value) => double.tryParse(value.trim()) ?? 0;

  TextInputType _keyboardType(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('date')) return TextInputType.datetime;
    if (lower.contains('phone') ||
        lower.contains('tax') ||
        lower.contains('count') ||
        lower.contains('quantity') ||
        lower.contains('price') ||
        lower.contains('received') ||
        lower.contains('discount')) {
      return TextInputType.number;
    }
    return TextInputType.text;
  }

  void _message(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}

class _InvoiceItemForm {
  final TextEditingController itemName;
  final TextEditingController description;
  final TextEditingController count;
  final TextEditingController quantity;
  final TextEditingController unit;
  final TextEditingController pricePerUnit;

  _InvoiceItemForm({
    required this.itemName,
    required this.description,
    required this.count,
    required this.quantity,
    required this.unit,
    required this.pricePerUnit,
  });

  factory _InvoiceItemForm.sample() {
    return _InvoiceItemForm(
      itemName: TextEditingController(text: 'ENGINE OIL 900ML'),
      description: TextEditingController(
        text:
            'HORNVIN 4T 20W-40 Motor Oil is a premium-grade engine oil specially engineered for 4-stroke motorcycles.',
      ),
      count: TextEditingController(text: '20'),
      quantity: TextEditingController(text: '1'),
      unit: TextEditingController(text: 'Btl'),
      pricePerUnit: TextEditingController(text: '3700'),
    );
  }

  factory _InvoiceItemForm.empty() {
    return _InvoiceItemForm(
      itemName: TextEditingController(),
      description: TextEditingController(),
      count: TextEditingController(text: '1'),
      quantity: TextEditingController(text: '1'),
      unit: TextEditingController(text: 'Pcs'),
      pricePerUnit: TextEditingController(text: '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName.text.trim(),
      'description': description.text.trim(),
      'count': int.tryParse(count.text.trim()) ?? 0,
      'quantity': int.tryParse(quantity.text.trim()) ?? 0,
      'unit': unit.text.trim(),
      'pricePerUnit': double.tryParse(pricePerUnit.text.trim()) ?? 0,
    };
  }

  void dispose() {
    itemName.dispose();
    description.dispose();
    count.dispose();
    quantity.dispose();
    unit.dispose();
    pricePerUnit.dispose();
  }
}
