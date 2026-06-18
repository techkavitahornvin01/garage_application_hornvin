// lib/models/garage_model/garage_profile_model.dart
// (Keep the same model as provided above)

class GarageProfileResponse {
  final bool success;
  final String message;
  final GarageData data;

  GarageProfileResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GarageProfileResponse.fromJson(Map<String, dynamic> json) {
    final data = _profilePayload(json);
    return GarageProfileResponse(
      success: _asBool(json['success'], defaultValue: true),
      message: _asString(json['message'], defaultValue: 'Success'),
      data: GarageData.fromJson(data),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

Map<String, dynamic> _profilePayload(Map<String, dynamic> json) {
  dynamic value = json;
  for (final key in ['data', 'garage', 'user', 'profile']) {
    if (value is Map && value[key] is Map) {
      value = value[key];
    }
  }
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return json;
}

class GarageData {
  final String? avatar;
  final BusinessAddress? businessAddress;
  final Photo? photo;
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final bool isPhoneVerified;
  final String role;
  final String businessName;
  final int commissionRate;
  final String garageType;
  final List<String> servicesOffered;
  final List<String> documents;
  final String complianceStatus;
  final String approvalStatus;
  final bool isEmailVerified;
  final bool isActive;
  final bool isDeleted;
  final int loginAttempts;
  final List<String> addresses;
  final List<String> licenses;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final DateTime? approvedAt;
  final DateTime? lastLogin;
  final String? language;
  final String? business_name;
  final String? full_name;

  GarageData({
    this.avatar,
    this.businessAddress,
    this.photo,
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.isPhoneVerified,
    required this.role,
    required this.businessName,
    required this.commissionRate,
    required this.garageType,
    required this.servicesOffered,
    required this.documents,
    required this.complianceStatus,
    required this.approvalStatus,
    required this.isEmailVerified,
    required this.isActive,
    required this.isDeleted,
    required this.loginAttempts,
    required this.addresses,
    required this.licenses,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.approvedAt,
    this.lastLogin,
    this.language,
    this.business_name,
    this.full_name,
  });

  factory GarageData.fromJson(Map<String, dynamic> json) {
    return GarageData(
      avatar: _mediaUrl(json['avatar']),
      businessAddress: BusinessAddress.fromValue(json['businessAddress']),
      photo: Photo.fromValue(json['photo']),
      id: _asString(json['_id'] ?? json['id']),
      name: _asString(
        json['name'] ?? json['full_name'],
        defaultValue: 'Garage Owner',
      ),
      email: _asString(json['email']),
      phoneNumber: _asString(json['phoneNumber'] ?? json['phone']),
      isPhoneVerified: _asBool(json['isPhoneVerified']),
      role: _asString(json['role'], defaultValue: 'garage'),
      businessName: _asString(
        json['businessName'] ?? json['business_name'],
        defaultValue: 'Garage',
      ),
      commissionRate: _asInt(json['commissionRate']),
      garageType: _asString(json['garageType'], defaultValue: 'N/A'),
      servicesOffered: _asStringList(json['servicesOffered']),
      documents: _asStringList(json['documents']),
      complianceStatus: _asString(
        json['complianceStatus'],
        defaultValue: 'pending_review',
      ),
      approvalStatus: _asString(
        json['approvalStatus'],
        defaultValue: 'pending',
      ),
      isEmailVerified: _asBool(json['isEmailVerified']),
      isActive: _asBool(json['isActive'], defaultValue: true),
      isDeleted: _asBool(json['isDeleted']),
      loginAttempts: _asInt(json['loginAttempts']),
      addresses: _asStringList(json['addresses']),
      licenses: _asStringList(json['licenses']),
      createdAt: _asDate(json['createdAt']),
      updatedAt: _asDate(json['updatedAt']),
      v: _asInt(json['__v']),
      approvedAt: _tryDate(json['approvedAt']),
      lastLogin: _tryDate(json['lastLogin']),
      language: _nullableString(json['language']),
      business_name: _nullableString(json['business_name']),
      full_name: _nullableString(json['full_name']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (avatar != null) 'avatar': avatar,
      if (businessAddress != null) 'businessAddress': businessAddress!.toJson(),
      if (photo != null) 'photo': photo!.toJson(),
      '_id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'isPhoneVerified': isPhoneVerified,
      'role': role,
      'businessName': businessName,
      'commissionRate': commissionRate,
      'garageType': garageType,
      'servicesOffered': servicesOffered,
      'documents': documents,
      'complianceStatus': complianceStatus,
      'approvalStatus': approvalStatus,
      'isEmailVerified': isEmailVerified,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'loginAttempts': loginAttempts,
      'addresses': addresses,
      'licenses': licenses,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      if (approvedAt != null) 'approvedAt': approvedAt!.toIso8601String(),
      if (lastLogin != null) 'lastLogin': lastLogin!.toIso8601String(),
      if (language != null) 'language': language,
      if (business_name != null) 'business_name': business_name,
      if (full_name != null) 'full_name': full_name,
    };
  }
}

class BusinessAddress {
  final String country;

  BusinessAddress({required this.country});

  factory BusinessAddress.fromJson(Map<String, dynamic> json) {
    return BusinessAddress(
      country: _asString(json['country'], defaultValue: 'India'),
    );
  }

  factory BusinessAddress.fromValue(dynamic value) {
    if (value is Map<String, dynamic>) return BusinessAddress.fromJson(value);
    if (value is Map) {
      return BusinessAddress.fromJson(Map<String, dynamic>.from(value));
    }
    final text = _asString(value, defaultValue: 'India');
    return BusinessAddress(country: text);
  }

  Map<String, dynamic> toJson() {
    return {'country': country};
  }
}

class Photo {
  final String? url;
  final String? publicId;

  Photo({this.url, this.publicId});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      url: _nullableString(json['url']),
      publicId: _nullableString(json['public_id']),
    );
  }

  factory Photo.fromValue(dynamic value) {
    if (value is Map<String, dynamic>) return Photo.fromJson(value);
    if (value is Map) return Photo.fromJson(Map<String, dynamic>.from(value));
    return Photo(url: _nullableString(value));
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'public_id': publicId};
  }
}

String _asString(dynamic value, {String defaultValue = ''}) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty || text == 'null' ? defaultValue : text;
}

String? _nullableString(dynamic value) {
  final text = _asString(value);
  return text.isEmpty ? null : text;
}

String? _mediaUrl(dynamic value) {
  if (value is Map) return _nullableString(value['url']);
  return _nullableString(value);
}

int _asInt(dynamic value, {int defaultValue = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? defaultValue;
}

bool _asBool(dynamic value, {bool defaultValue = false}) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  final text = value?.toString().toLowerCase().trim();
  if (text == 'true') return true;
  if (text == 'false') return false;
  return defaultValue;
}

DateTime _asDate(dynamic value) {
  return _tryDate(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
}

DateTime? _tryDate(dynamic value) {
  final text = _asString(value);
  if (text.isEmpty) return null;
  return DateTime.tryParse(text);
}

List<String> _asStringList(dynamic value) {
  if (value is! List) return const [];
  return value
      .map((item) {
        if (item is Map) {
          return _asString(
            item['name'] ?? item['title'] ?? item['_id'] ?? item['id'],
          );
        }
        return _asString(item);
      })
      .where((item) => item.isNotEmpty)
      .toList();
}
