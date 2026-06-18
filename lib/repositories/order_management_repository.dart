import 'package:flutter/foundation.dart';
import 'package:hornvin/models/order_management_model.dart';
import 'package:hornvin/services/api_service.dart';
import 'package:hornvin/utils/constants.dart';

class OrderManagementRepository {
  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> getProducts({
    String? distributorId,
    String search = '',
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _apiService.get(
      _productsEndpoint(
        distributorId: distributorId,
        search: search,
        page: page,
        limit: limit,
      ),
    );
    return _extractList(response);
  }

  Future<OrderProductResponse> getProductResponse({
    String? distributorId,
    String search = '',
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _apiService.get(
      _productsEndpoint(
        distributorId: distributorId,
        search: search,
        page: page,
        limit: limit,
      ),
    );
    return OrderProductResponse.fromJson(response);
  }

  Future<List<Map<String, dynamic>>> getOrders({
    int page = 1,
    int limit = 30,
  }) async {
    final response = await _apiService.get(_ordersEndpoint(page, limit));
    debugPrint('Garage orders fetched');
    return _extractList(response);
  }

  Future<GarageOrderResponse> getOrderResponse({
    int page = 1,
    int limit = 30,
  }) async {
    final response = await _apiService.get(_ordersEndpoint(page, limit));
    return GarageOrderResponse.fromJson(response);
  }

  Future<List<Map<String, dynamic>>> getInvoices() async {
    final response = await _apiService.get(ApiConstants.garageInvoices);
    return _extractList(response);
  }

  Future<Map<String, dynamic>> createOrder({
    required String distributor,
    required List<Map<String, dynamic>> items,
    required int totalAmount,
  }) async {
    final payload = {
      'distributor': distributor,
      'items': items,
      'totalAmount': totalAmount,
    };
    debugPrint('POST ${ApiConstants.garageOrders}: $payload');
    final response = await _apiService.post(ApiConstants.garageOrders, payload);
    debugPrint('POST ${ApiConstants.garageOrders} response: $response');

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
        response['garageProducts'],
        response['products'],
        response['orders'],
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

  String _productsEndpoint({
    String? distributorId,
    String search = '',
    int page = 1,
    int limit = 10,
  }) {
    if (distributorId == null || distributorId.trim().isEmpty) {
      return ApiConstants.garageProducts;
    }

    return Uri(
      path: ApiConstants.garageProducts,
      queryParameters: {
        'distributorId': distributorId.trim(),
        'search': search,
        'page': page.toString(),
        'limit': limit.toString(),
      },
    ).toString();
  }

  String _ordersEndpoint(int page, int limit) {
    return Uri(
      path: ApiConstants.garageOrders,
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
    ).toString();
  }
}
