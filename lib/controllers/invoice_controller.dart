import 'package:flutter/material.dart';
import 'package:hornvin/models/invoice_model.dart';
import 'package:hornvin/models/job_model/job_model.dart';
import 'package:hornvin/repositories/invoice_repository.dart';
import 'package:hornvin/repositories/job_repository.dart';
import 'package:hornvin/utils/friendly_error.dart';

class InvoiceController extends ChangeNotifier {
  final InvoiceRepository _invoiceRepository = InvoiceRepository();
  final JobRepository _jobRepository = JobRepository();

  List<Invoice> _invoices = [];
  List<Job> _jobs = [];
  bool _isLoading = false;
  bool _isCreating = false;
  String? _errorMessage;
  Map<String, dynamic>? _lastApiResponse;

  List<Invoice> get invoices => _invoices;
  List<Job> get jobs => _jobs;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get lastApiResponse => _lastApiResponse;

  Future<void> fetchInvoices({String search = ''}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _invoiceRepository.getInvoiceResponse(
        search: search,
      );
      _invoices = response.invoices;
      _lastApiResponse = response.raw;
    } catch (e) {
      _errorMessage = friendlyErrorMessage(
        e,
        fallback: 'Invoices could not be loaded right now. Please try again.',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchJobs() async {
    try {
      final response = await _jobRepository.getAllJobs(page: 1, limit: 100);
      _jobs = response.jobs;
      notifyListeners();
    } catch (e) {
      _errorMessage = friendlyErrorMessage(
        e,
        fallback: 'Jobs could not be loaded for invoice creation.',
      );
      notifyListeners();
    }
  }

  Future<bool> createInvoice({
    required Job job,
    required List<InvoiceItemPayload> items,
  }) async {
    if (items.isEmpty) {
      _errorMessage = 'Please add invoice items';
      notifyListeners();
      return false;
    }

    _isCreating = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _lastApiResponse = await _invoiceRepository.createInvoice(
        jobCard: job.jobCardId,
        customerName: job.customerName,
        phoneNumber: job.phoneNumber,
        vehicleNumber: job.vehicleNumber,
        parts: items
            .where((item) => !item.isService)
            .map((item) => item.toApiJson())
            .toList(),
        services: items
            .where((item) => item.isService)
            .map((item) => item.toApiJson())
            .toList(),
      );
      await fetchInvoices();
      return true;
    } catch (e) {
      _errorMessage = friendlyErrorMessage(
        e,
        fallback: 'Invoice could not be created right now. Please try again.',
      );
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  Future<void> getInvoice(String id) async {
    _lastApiResponse = await _invoiceRepository.getInvoice(id);
    notifyListeners();
  }

  Future<bool> deleteInvoice(String id) async {
    try {
      await _invoiceRepository.deleteInvoice(id);
      await fetchInvoices();
      return true;
    } catch (e) {
      _errorMessage = friendlyErrorMessage(
        e,
        fallback: 'Invoice could not be deleted right now. Please try again.',
      );
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePaymentStatus(String id, String status) async {
    try {
      _lastApiResponse = await _invoiceRepository.updatePaymentStatus(
        id: id,
        paymentStatus: status,
      );
      await fetchInvoices();
      return true;
    } catch (e) {
      _errorMessage = friendlyErrorMessage(
        e,
        fallback: 'Payment status could not be updated right now.',
      );
      notifyListeners();
      return false;
    }
  }
}
