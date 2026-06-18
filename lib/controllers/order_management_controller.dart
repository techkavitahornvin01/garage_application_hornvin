import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hornvin/models/order_management_model.dart';
import 'package:hornvin/repositories/order_management_repository.dart';
import 'package:hornvin/utils/friendly_error.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderManagementController extends ChangeNotifier {
  static const String _cartStorageKey = 'garage_order_cart_v1';
  final OrderManagementRepository _repository = OrderManagementRepository();

  List<OrderProduct> _products = [];
  List<GarageOrder> _orders = [];
  final List<OrderCartItem> _cart = [];
  bool _isLoading = false;
  bool _isCreating = false;
  String? _errorMessage;
  Map<String, dynamic>? _lastApiResponse;
  String? _lastProductRequestKey;
  bool _isCartRestored = false;
  bool _isMutatingCart = false;
  bool _isDisposed = false;

  OrderManagementController() {
    unawaited(restoreCart());
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  List<OrderProduct> get products => _products;
  List<GarageOrder> get orders => _orders;
  List<OrderCartItem> get cart => _cart;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get lastApiResponse => _lastApiResponse;
  bool get isCartRestored => _isCartRestored;
  bool get isMutatingCart => _isMutatingCart;

  int get cartTotal =>
      _cart.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  int get cartItemCount => _cart.fold(0, (sum, item) => sum + item.quantity);
  int get cartSubtotal => cartTotal;
  int get cartTax => 0;
  int get deliveryFee => _cart.isEmpty ? 0 : 0;
  int get cartGrandTotal => cartSubtotal + cartTax + deliveryFee;

  int quantityFor(OrderProduct product) {
    final index = _cart.indexWhere(
      (item) => item.product.cartKey == product.cartKey,
    );
    if (index == -1) return 0;
    return _cart[index].quantity;
  }

  Map<String, dynamic> orderRequestPayload({String? distributorId}) {
    final distributor =
        _cart.isNotEmpty && _cart.first.product.distributorId.isNotEmpty
        ? _cart.first.product.distributorId
        : distributorId?.trim() ?? '';

    return {
      'distributor': distributor,
      'items': _cart.map((item) => item.toApiJson()).toList(),
      'totalAmount': cartGrandTotal,
    };
  }

  Future<void> restoreCart() async {
    if (_isCartRestored) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cartStorageKey);
      if (cached == null || cached.trim().isEmpty) {
        _isCartRestored = true;
        _notifySafely();
        return;
      }

      final decoded = jsonDecode(cached);
      if (decoded is List) {
        _cart
          ..clear()
          ..addAll(
            decoded
                .whereType<Map>()
                .map(
                  (item) => OrderCartItem.fromCacheJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .where(
                  (item) => item.quantity > 0 && item.product.id.isNotEmpty,
                ),
          );
      }
    } catch (e) {
      debugPrint('Cart restore failed: $e');
    } finally {
      _isCartRestored = true;
      _notifySafely();
    }
  }

  Future<void> fetchProducts({
    String? distributorId,
    String search = '',
    int page = 1,
    int limit = 10,
  }) async {
    final requestKey = '${distributorId ?? ''}|$search|$page|$limit';
    final shouldClearProducts =
        _products.isEmpty || _lastProductRequestKey != requestKey;
    _lastProductRequestKey = requestKey;
    _isLoading = true;
    _errorMessage = null;
    if (shouldClearProducts) {
      _products = [];
    }
    _notifySafely();

    try {
      final response = await _repository.getProductResponse(
        distributorId: distributorId,
        search: search,
        page: page,
        limit: limit,
      );
      _products = response.products;
      debugPrint(
        'Distributor products fetched: ${_products.map((product) => '${product.name}|${product.id}|${product.cartKey}').toList()}',
      );
    } catch (e) {
      _errorMessage = friendlyErrorMessage(
        e,
        fallback: 'Products could not be loaded right now. Please try again.',
      );
    } finally {
      _isLoading = false;
      _notifySafely();
    }
  }

  Future<void> fetchOrders() async {
    _isLoading = true;
    _errorMessage = null;
    _notifySafely();

    try {
      final response = await _repository.getOrderResponse();
      _orders = response.orders;
      _lastApiResponse = response.raw;
    } catch (e) {
      _errorMessage = friendlyErrorMessage(
        e,
        fallback: 'Orders could not be loaded right now. Please try again.',
      );
    } finally {
      _isLoading = false;
      _notifySafely();
    }
  }

  void addToCart(OrderProduct product) {
    if (!_canAddProduct(product)) return;
    debugPrint(
      'Add product: name=${product.name}, id=${product.id}, key=${product.cartKey}',
    );
    _isMutatingCart = true;
    final index = _cart.indexWhere(
      (item) => item.product.cartKey == product.cartKey,
    );
    if (index == -1) {
      _cart.add(OrderCartItem(product: product, quantity: 1));
    } else {
      final nextQuantity = _cart[index].quantity + 1;
      _cart[index] = _cart[index].copyWith(
        quantity: _safeQuantity(product, nextQuantity),
      );
    }
    debugPrint(
      'Cart after add: ${_cart.map((item) => '${item.product.name}:${item.quantity}:${item.product.cartKey}').toList()}',
    );
    _isMutatingCart = false;
    _notifySafely();
    unawaited(_persistCart());
  }

  void decreaseCartItem(OrderProduct product) {
    debugPrint(
      'Decrease product: name=${product.name}, id=${product.id}, key=${product.cartKey}',
    );
    final index = _cart.indexWhere(
      (item) => item.product.cartKey == product.cartKey,
    );
    if (index == -1) {
      debugPrint('Decrease skipped: product not found in cart');
      return;
    }
    _isMutatingCart = true;
    final item = _cart[index];
    if (item.quantity <= 1) {
      _cart.removeAt(index);
    } else {
      _cart[index] = item.copyWith(quantity: item.quantity - 1);
    }
    debugPrint(
      'Cart after decrease: ${_cart.map((cartItem) => '${cartItem.product.name}:${cartItem.quantity}:${cartItem.product.cartKey}').toList()}',
    );
    _isMutatingCart = false;
    _notifySafely();
    unawaited(_persistCart());
  }

  void setCartItemQuantity(OrderProduct product, int quantity) {
    final index = _cart.indexWhere(
      (item) => item.product.cartKey == product.cartKey,
    );
    if (index == -1) {
      if (quantity > 0) addToCart(product);
      return;
    }

    _isMutatingCart = true;
    if (quantity <= 0) {
      _cart.removeAt(index);
    } else {
      _cart[index] = _cart[index].copyWith(
        quantity: _safeQuantity(product, quantity),
      );
    }
    _isMutatingCart = false;
    _notifySafely();
    unawaited(_persistCart());
  }

  void removeCartItem(OrderCartItem item) {
    _cart.removeWhere(
      (cartItem) => cartItem.product.cartKey == item.product.cartKey,
    );
    _notifySafely();
    unawaited(_persistCart());
  }

  void clearCart() {
    _cart.clear();
    _notifySafely();
    unawaited(_persistCart());
  }

  Future<bool> createOrder({String? distributorId}) async {
    if (_cart.isEmpty) {
      _errorMessage = 'Cart is empty';
      _notifySafely();
      return false;
    }

    final distributor = _cart.first.product.distributorId.isNotEmpty
        ? _cart.first.product.distributorId
        : distributorId?.trim() ?? '';
    if (distributor.isEmpty) {
      _errorMessage = 'Distributor ID missing in product API response';
      _notifySafely();
      return false;
    }

    final hasDifferentDistributor = _cart.any(
      (item) =>
          item.product.distributorId.isNotEmpty &&
          item.product.distributorId != distributor,
    );
    if (hasDifferentDistributor) {
      _errorMessage = 'Please create one order per distributor';
      _notifySafely();
      return false;
    }

    _isCreating = true;
    _errorMessage = null;
    _notifySafely();

    try {
      final payload = orderRequestPayload(distributorId: distributorId);
      debugPrint('Garage order request: $payload');
      _lastApiResponse = await _repository.createOrder(
        distributor: payload['distributor'].toString(),
        items: List<Map<String, dynamic>>.from(payload['items'] as List),
        totalAmount: payload['totalAmount'] as int,
      );
      debugPrint('Garage order response: $_lastApiResponse');
      clearCart();
      return true;
    } catch (e) {
      _errorMessage = friendlyErrorMessage(
        e,
        fallback: 'Order could not be created right now. Please try again.',
      );
      return false;
    } finally {
      _isCreating = false;
      _notifySafely();
    }
  }

  bool _canAddProduct(OrderProduct product) {
    if (product.id.trim().isEmpty) {
      _errorMessage = 'Invalid product ID';
      _notifySafely();
      return false;
    }
    if (product.stock <= 0) {
      _errorMessage = 'Product is out of stock';
      _notifySafely();
      return false;
    }
    return true;
  }

  int _safeQuantity(OrderProduct product, int quantity) {
    final normalized = quantity < 0 ? 0 : quantity;
    if (product.stock <= 0) return normalized;
    return normalized > product.stock ? product.stock : normalized;
  }

  Future<void> _persistCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final payload = jsonEncode(
        _cart.map((item) => item.toCacheJson()).toList(),
      );
      await prefs.setString(_cartStorageKey, payload);
    } catch (e) {
      debugPrint('Cart persist failed: $e');
    }
  }

  void _notifySafely() {
    if (_isDisposed) return;
    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.idle ||
        phase == SchedulerPhase.postFrameCallbacks) {
      notifyListeners();
      return;
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_isDisposed) return;
      notifyListeners();
    });
  }
}
