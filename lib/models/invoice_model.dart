class InvoiceResponse {
  final bool success;
  final List<Invoice> invoices;
  final Map<String, dynamic> raw;

  InvoiceResponse({
    required this.success,
    required this.invoices,
    required this.raw,
  });

  factory InvoiceResponse.fromJson(dynamic json) {
    final list = _extractList(json, ['invoices', 'items', 'results', 'data']);
    return InvoiceResponse(
      success: json is Map<String, dynamic>
          ? json['success'] as bool? ?? true
          : true,
      invoices: list.map(Invoice.fromJson).toList(),
      raw: json is Map<String, dynamic> ? json : {'data': json},
    );
  }
}

class Invoice {
  final String id;
  final String jobCard;
  final String customerName;
  final String phoneNumber;
  final String vehicleNumber;
  final int totalAmount;
  final String paymentStatus;
  final Map<String, dynamic> raw;

  Invoice({
    required this.id,
    required this.jobCard,
    required this.customerName,
    required this.phoneNumber,
    required this.vehicleNumber,
    required this.totalAmount,
    required this.paymentStatus,
    required this.raw,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    final billTo = json['billTo'] is Map
        ? Map<String, dynamic>.from(json['billTo'] as Map)
        : <String, dynamic>{};
    final payment = json['payment'] is Map
        ? Map<String, dynamic>.from(json['payment'] as Map)
        : <String, dynamic>{};
    return Invoice(
      id: _text(json['_id'] ?? json['id'] ?? json['invoiceId']),
      jobCard: _text(json['jobCard'] ?? json['jobCardId']),
      customerName: _text(billTo['name'] ?? json['customerName'] ?? json['customer']),
      phoneNumber: _text(billTo['phone'] ?? json['phoneNumber'] ?? json['phone']),
      vehicleNumber: _text(json['vehicleNumber']),
      totalAmount: _int(
        json['totalAmount'] ??
            json['amount'] ??
            json['total'] ??
            _itemsTotal(json['items']),
      ),
      paymentStatus: _text(
        payment['paymentStatus'] ?? json['payment_status'] ?? json['paymentStatus'],
        defaultValue: 'pending',
      ),
      raw: json,
    );
  }
}

class InvoiceItemPayload {
  final String name;
  final double price;
  final int quantity;
  final bool isService;

  InvoiceItemPayload({
    required this.name,
    required this.price,
    required this.quantity,
    required this.isService,
  });

  Map<String, dynamic> toApiJson() {
    return {'name': name, 'price': price * quantity};
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

int _int(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

int _itemsTotal(dynamic items) {
  if (items is! List) return 0;
  var total = 0.0;
  for (final item in items) {
    if (item is! Map) continue;
    total += _num(item['count']) * _num(item['pricePerUnit']);
  }
  return total.round();
}

double _num(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

String _text(dynamic value, {String defaultValue = ''}) {
  final text = value?.toString() ?? '';
  return text.isEmpty ? defaultValue : text;
}
