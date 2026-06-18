class OrderProductResponse {
  final bool success;
  final List<OrderProduct> products;

  OrderProductResponse({required this.success, required this.products});

  factory OrderProductResponse.fromJson(dynamic json) {
    final list = _extractList(json, [
      'garageProducts',
      'products',
      'items',
      'results',
      'data',
    ]);
    final products = <OrderProduct>[];
    for (var index = 0; index < list.length; index++) {
      products.add(OrderProduct.fromJson(list[index], sourceIndex: index));
    }

    return OrderProductResponse(success: _success(json), products: products);
  }
}

class GarageOrderResponse {
  final bool success;
  final List<GarageOrder> orders;
  final Map<String, dynamic> raw;

  GarageOrderResponse({
    required this.success,
    required this.orders,
    required this.raw,
  });

  factory GarageOrderResponse.fromJson(dynamic json) {
    final list = _extractList(json, ['orders', 'items', 'results', 'data']);
    return GarageOrderResponse(
      success: _success(json),
      orders: list.map(GarageOrder.fromJson).toList(),
      raw: json is Map<String, dynamic> ? json : {'data': json},
    );
  }
}

class OrderProduct {
  final String id;
  final String lineId;
  final String cartKey;
  final String name;
  final String category;
  final int price;
  final int stock;
  final String brand;
  final String distributorId;
  final String imageUrl;
  final Map<String, dynamic> raw;

  OrderProduct({
    required this.id,
    required this.lineId,
    required this.cartKey,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.brand,
    required this.distributorId,
    required this.imageUrl,
    required this.raw,
  });

  factory OrderProduct.fromJson(
    Map<String, dynamic> json, {
    int sourceIndex = 0,
  }) {
    final product = json['product'];
    final productMap = product is Map<String, dynamic> ? product : null;
    final distributor = json['distributor'];
    final distributorId = json['distributorId'];
    final distributorDetails = json['distributorDetails'];
    final seller = json['seller'];
    final createdBy = json['createdBy'];
    final assignedDistributor = json['assignedDistributor'];
    final lineId = _firstText([
      json['_id'],
      json['id'],
      json['inventoryId'],
      json['inventoryProductId'],
      json['garageProductId'],
    ]);
    final id = _firstText([
      _idText(json['productId']),
      _idText(product),
      _idText(productMap),
      lineId,
    ]);
    final name = _text(
      productMap?['name'] ?? json['name'] ?? json['productName'] ?? 'Product',
    );
    final category = _text(
      productMap?['category'] ?? json['category'] ?? 'All',
    );
    final price = _int(
      json['sellingPrice'] ??
          json['productPrice'] ??
          productMap?['price'] ??
          json['price'] ??
          productMap?['mrp'] ??
          json['mrp'],
    );
    final stock = _int(
      json['availableStock'] ??
          json['quantity'] ??
          productMap?['stock'] ??
          json['stock'],
    );
    final brand = _text(
      productMap?['sku'] ?? json['brand'] ?? json['manufacturer'] ?? 'Hornvin',
    );
    final distributorIdValue = _firstText([
      _idText(distributor),
      _idText(distributorId),
      distributorDetails is Map
          ? distributorDetails['distributorId'] ??
                distributorDetails['_id'] ??
                distributorDetails['id']
          : null,
      assignedDistributor is Map
          ? assignedDistributor['_id'] ?? assignedDistributor['id']
          : null,
      seller is Map ? seller['_id'] ?? seller['id'] : null,
      createdBy is Map ? createdBy['_id'] ?? createdBy['id'] : null,
      json['distributor'],
      json['distributorId'],
      json['distributor_id'],
      json['assignedDistributorId'],
      json['seller'],
      json['createdBy'],
    ]);
    return OrderProduct(
      id: id,
      lineId: lineId,
      cartKey: _cartKey(
        lineId: lineId,
        id: id,
        name: name,
        category: category,
        brand: brand,
        distributorId: distributorIdValue,
        price: price,
        sourceIndex: sourceIndex,
      ),
      name: name,
      category: category,
      price: price,
      stock: stock,
      brand: brand,
      distributorId: distributorIdValue,
      imageUrl: _firstText([
        json['productImage'],
        _primaryImage(productMap?['images']),
        productMap?['image'],
      ]),
      raw: json,
    );
  }

  factory OrderProduct.fromCacheJson(Map<String, dynamic> json) {
    return OrderProduct(
      id: _text(json['id']),
      lineId: _text(json['lineId']),
      cartKey: _text(json['cartKey']),
      name: _text(json['name'], defaultValue: 'Product'),
      category: _text(json['category'], defaultValue: 'All'),
      price: _int(json['price']),
      stock: _int(json['stock']),
      brand: _text(json['brand'], defaultValue: 'Hornvin'),
      distributorId: _text(json['distributorId']),
      imageUrl: _text(json['imageUrl']),
      raw: json['raw'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['raw'] as Map)
          : const {},
    );
  }

  Map<String, dynamic> toCacheJson() {
    return {
      'id': id,
      'lineId': lineId,
      'cartKey': cartKey,
      'name': name,
      'category': category,
      'price': price,
      'stock': stock,
      'brand': brand,
      'distributorId': distributorId,
      'imageUrl': imageUrl,
      'raw': raw,
    };
  }
}

class OrderCartItem {
  final OrderProduct product;
  final int quantity;

  OrderCartItem({required this.product, required this.quantity});

  OrderCartItem copyWith({int? quantity}) {
    return OrderCartItem(product: product, quantity: quantity ?? this.quantity);
  }

  Map<String, dynamic> toApiJson() {
    return {
      'product': product.id,
      'quantity': quantity,
      'price': product.price,
    };
  }

  Map<String, dynamic> toCacheJson() {
    return {'product': product.toCacheJson(), 'quantity': quantity};
  }

  factory OrderCartItem.fromCacheJson(Map<String, dynamic> json) {
    final product = json['product'];
    return OrderCartItem(
      product: product is Map<String, dynamic>
          ? OrderProduct.fromCacheJson(product)
          : OrderProduct.fromCacheJson(const {}),
      quantity: _int(json['quantity']),
    );
  }
}

class GarageOrder {
  final String id;
  final String status;
  final int totalAmount;
  final DateTime createdAt;
  final Map<String, dynamic> raw;

  GarageOrder({
    required this.id,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    required this.raw,
  });

  factory GarageOrder.fromJson(Map<String, dynamic> json) {
    return GarageOrder(
      id: _text(json['_id'] ?? json['id'] ?? json['orderId']),
      status: _text(json['status'], defaultValue: 'pending'),
      totalAmount: _int(json['totalAmount'] ?? json['amount'] ?? json['total']),
      createdAt: DateTime.tryParse(_text(json['createdAt'])) ?? DateTime.now(),
      raw: json,
    );
  }
}

List<Map<String, dynamic>> _extractList(dynamic json, List<String> keys) {
  if (json is List) {
    return json.whereType<Map>().map(Map<String, dynamic>.from).toList();
  }
  if (json is Map<String, dynamic>) {
    for (final key in keys) {
      final value = json[key];
      if (value is List) {
        return value.whereType<Map>().map(Map<String, dynamic>.from).toList();
      }
      if (value is Map<String, dynamic>) {
        final nested = _extractList(value, keys);
        if (nested.isNotEmpty) return nested;
      }
    }
  }
  return [];
}

bool _success(dynamic json) =>
    json is Map<String, dynamic> ? json['success'] as bool? ?? true : true;

int _int(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _text(dynamic value, {String defaultValue = ''}) {
  final text = value?.toString() ?? '';
  return text.isEmpty ? defaultValue : text;
}

String _firstText(List<dynamic> values) {
  for (final value in values) {
    final text = _text(value);
    if (text.isNotEmpty && text != '{}') return text;
  }
  return '';
}

String _idText(dynamic value) {
  if (value is Map) return _text(value['_id'] ?? value['id']);
  return _text(value);
}

String _cartKey({
  required String lineId,
  required String id,
  required String name,
  required String category,
  required String brand,
  required String distributorId,
  required int price,
  required int sourceIndex,
}) {
  if (lineId.isNotEmpty) return 'line|${lineId.trim().toLowerCase()}';

  return [
    id,
    name,
    category,
    brand,
    distributorId,
    price.toString(),
    sourceIndex.toString(),
  ].map((value) => value.trim().toLowerCase()).join('|');
}

String _primaryImage(dynamic images) {
  if (images is! List) return '';

  for (final image in images) {
    if (image is Map && image['isPrimary'] == true) {
      return _text(image['url']);
    }
  }

  for (final image in images) {
    if (image is Map) {
      final url = _text(image['url']);
      if (url.isNotEmpty) return url;
    }
  }

  return '';
}
