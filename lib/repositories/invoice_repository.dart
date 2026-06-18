import 'package:hornvin/services/api_service.dart';
import 'package:hornvin/utils/constants.dart';
import 'package:hornvin/models/invoice_model.dart';

class InvoiceRepository {
  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> getInvoices({
    int page = 1,
    int limit = 10,
    String search = '',
  }) async {
    final query = Uri(
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
        'search': search,
      },
    ).query;
    final endpoint = '${ApiConstants.garageInvoices}?$query';
    final response = await _apiService.get(endpoint);
    return _extractList(response);
  }

  Future<InvoiceResponse> getInvoiceResponse({
    int page = 1,
    int limit = 10,
    String search = '',
  }) async {
    final query = Uri(
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
        'search': search,
      },
    ).query;
    final endpoint = '${ApiConstants.garageInvoices}?$query';
    final response = await _apiService.get(endpoint);
    return InvoiceResponse.fromJson(response);
  }

  Future<Map<String, dynamic>> getInvoice(String id) async {
    final response = await _apiService.get(
      '${ApiConstants.garageInvoices}/$id',
    );
    return _extractMap(response);
  }

  Future<Map<String, dynamic>> createInvoice({
    required String customerName,
    required String phoneNumber,
    required String vehicleNumber,
    required List<Map<String, dynamic>> parts,
    required List<Map<String, dynamic>> services,
    String? jobCard,
  }) async {
    final body = {
      if (jobCard != null && jobCard.trim().isNotEmpty)
        'jobCard': jobCard.trim(),
      'customerName': customerName.trim(),
      'phoneNumber': phoneNumber.trim(),
      'vehicleNumber': vehicleNumber.trim(),
      'parts': parts,
      'services': services,
    };

    final response = await _apiService.post(
      ApiConstants.createGarageInvoice,
      body,
    );
    return _extractMap(response);
  }

  Future<Map<String, dynamic>> createInvoicePayload(
    Map<String, dynamic> payload,
  ) async {
    final response = await _apiService.post(
      ApiConstants.createGarageInvoice,
      payload,
    );
    return _extractMap(response);
  }

  Future<Map<String, dynamic>?> getInvoiceByJobCardId(String jobCardId) async {
    final id = jobCardId.trim();
    if (id.isEmpty) return null;
    final invoices = await getInvoices(limit: 100, search: id);
    for (final invoice in invoices) {
      final jobCard = invoice['jobCard'] is Map
          ? invoice['jobCard'] as Map
          : const {};
      final invoiceJobIds = [
        jobCard['_id'],
        jobCard['id'],
        jobCard['jobCardId'],
        jobCard['job_card_id'],
        jobCard['jobCard'],
        jobCard['jobCardNumber'],
        invoice['jobCardId'],
        invoice['job_card_id'],
        invoice['jobCardNumber'],
        invoice['jobCard'],
      ].map(_normalize).where((value) => value.isNotEmpty);
      if (!invoiceJobIds.contains(_normalize(id))) continue;

      final invoiceId = _text(
        invoice['_id'] ?? invoice['id'] ?? invoice['invoiceId'],
      );
      if (invoiceId.isEmpty) return invoice;
      return getInvoice(invoiceId);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getInvoiceForJob({
    required List<String> jobCardIds,
    required String customerName,
    required String phoneNumber,
    required String vehicleNumber,
  }) async {
    final ids = jobCardIds
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toSet();

    for (final id in ids) {
      final invoice = await getInvoiceByJobCardId(id);
      if (invoice != null && invoice.isNotEmpty) return invoice;
    }

    final searchTerms = [
      vehicleNumber,
      phoneNumber,
      customerName,
    ].map((value) => value.trim()).where((value) => value.isNotEmpty).toSet();

    for (final term in searchTerms) {
      final invoices = await getInvoices(limit: 100, search: term);
      for (final invoice in invoices) {
        if (!_matchesJobInvoice(
          invoice,
          customerName: customerName,
          phoneNumber: phoneNumber,
          vehicleNumber: vehicleNumber,
        )) {
          continue;
        }

        final invoiceId = _text(
          invoice['_id'] ?? invoice['id'] ?? invoice['invoiceId'],
        );
        if (invoiceId.isEmpty) return invoice;
        return getInvoice(invoiceId);
      }
    }

    return null;
  }

  Future<void> deleteInvoice(String id) async {
    await _apiService.delete('${ApiConstants.garageInvoices}/$id');
  }

  Future<Map<String, dynamic>> updatePaymentStatus({
    required String id,
    required String paymentStatus,
  }) async {
    final response = await _apiService.patch(
      '${ApiConstants.garageInvoices}/$id/payment',
      {'payment_status': paymentStatus},
    );
    return _extractMap(response);
  }

  Future<Map<String, dynamic>> getRevenueStats() async {
    final response = await _apiService.get(ApiConstants.invoiceStats);
    return _extractMap(response);
  }

  Map<String, dynamic> _extractMap(dynamic response) {
    if (response is Map<String, dynamic>) {
      final data = response['data'];
      if (data is Map<String, dynamic>) return data;
      return response;
    }
    return {'data': response};
  }

  List<Map<String, dynamic>> _extractList(dynamic response) {
    if (response is List) {
      return response.whereType<Map>().map(Map<String, dynamic>.from).toList();
    }

    if (response is Map<String, dynamic>) {
      final candidates = [
        response['data'],
        response['invoices'],
        response['items'],
        response['results'],
      ];

      for (final candidate in candidates) {
        if (candidate is List) {
          return candidate
              .whereType<Map>()
              .map(Map<String, dynamic>.from)
              .toList();
        }
        if (candidate is Map<String, dynamic>) {
          final nested = _extractList(candidate);
          if (nested.isNotEmpty) return nested;
        }
      }
    }

    return [];
  }

  bool _matchesJobInvoice(
    Map<String, dynamic> invoice, {
    required String customerName,
    required String phoneNumber,
    required String vehicleNumber,
  }) {
    final billTo = invoice['billTo'] is Map
        ? invoice['billTo'] as Map
        : const {};
    final customerDetails = invoice['customerDetails'] is Map
        ? invoice['customerDetails'] as Map
        : const {};
    final jobCard = invoice['jobCard'] is Map
        ? invoice['jobCard'] as Map
        : const {};

    final invoiceVehicle = _normalize(
      invoice['vehicleNumber'] ??
          invoice['registrationNumber'] ??
          invoice['vehicleNo'] ??
          invoice['vehicle_no'] ??
          invoice['vehicle_number'] ??
          invoice['vehicle_id'] ??
          customerDetails['vehicleNumber'] ??
          customerDetails['registrationNumber'] ??
          customerDetails['vehicleNo'] ??
          customerDetails['vehicle_no'] ??
          customerDetails['vehicle_number'] ??
          jobCard['vehicleNumber'] ??
          jobCard['registrationNumber'] ??
          jobCard['vehicleNo'] ??
          jobCard['vehicle_no'] ??
          jobCard['vehicle_number'],
    );
    final invoicePhone = _digits(
      invoice['phoneNumber'] ??
          invoice['phone'] ??
          billTo['phone'] ??
          billTo['phoneNumber'] ??
          billTo['mobile'] ??
          customerDetails['phone'] ??
          customerDetails['phoneNumber'] ??
          customerDetails['mobile'] ??
          jobCard['phoneNumber'] ??
          jobCard['phone'] ??
          jobCard['mobile'],
    );
    final invoiceCustomer = _normalize(
      invoice['customerName'] ??
          invoice['customer_name'] ??
          invoice['customer'] ??
          billTo['name'] ??
          billTo['customerName'] ??
          customerDetails['name'] ??
          customerDetails['customerName'] ??
          jobCard['customerName'] ??
          jobCard['customer_name'] ??
          jobCard['customer'],
    );

    final targetVehicle = _normalize(vehicleNumber);
    final targetPhone = _digits(phoneNumber);
    final targetCustomer = _normalize(customerName);

    final vehicleMatches =
        targetVehicle.isNotEmpty && invoiceVehicle == targetVehicle;
    final phoneMatches = targetPhone.isNotEmpty && invoicePhone == targetPhone;
    final customerMatches =
        targetCustomer.isNotEmpty && invoiceCustomer == targetCustomer;

    final customerAndPhoneMatch = customerMatches && phoneMatches;
    final vehicleAndCustomerMatch = vehicleMatches && customerMatches;
    final vehicleAndPhoneMatch = vehicleMatches && phoneMatches;

    return customerAndPhoneMatch ||
        vehicleAndCustomerMatch ||
        vehicleAndPhoneMatch;
  }

  String _normalize(dynamic value) =>
      _text(value).toLowerCase().replaceAll(RegExp(r'\s+'), '');

  String _digits(dynamic value) => _text(value).replaceAll(RegExp(r'\D'), '');

  String _text(dynamic value) => value?.toString().trim() ?? '';
}
