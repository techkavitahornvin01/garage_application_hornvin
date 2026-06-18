// // lib/models/job_model/job_model.dart
// class JobResponse {
//   final bool success;
//   final int total;
//   final int page;
//   final int limit;
//   final int totalPages;
//   final List<Job> jobs;

//   JobResponse({
//     required this.success,
//     required this.total,
//     required this.page,
//     required this.limit,
//     required this.totalPages,
//     required this.jobs,
//   });

//   factory JobResponse.fromJson(Map<String, dynamic> json) {
//     return JobResponse(
//       success: json['success'] ?? false,
//       total: json['total'] ?? 0,
//       page: json['page'] ?? 1,
//       limit: json['limit'] ?? 10,
//       totalPages: json['totalPages'] ?? 1,
//       jobs: (json['jobs'] as List)
//           .map((job) => Job.fromJson(job))
//           .toList(),
//     );
//   }
// }

// class Job {
//   final String? id;
//   final String? jobCardId;
//   final String customerName;
//   final String phoneNumber;
//   final String vehicleNumber;
//   final String vehicleType;
//   final String vehicleModel;
//   final DateTime serviceDate;
//   final DateTime nextServiceDate;
//   final String description;
//   final String mechanicName;
//   final String mechanicProfile;
//   final List<String> vehiclePhotos;
//   final String vehicleVideo;
//   final List<Part> parts;
//   final int totalPartsCost;
//   final String status;
//   final String notes;
//   final String? createdBy;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   Job({
//     this.id,
//     this.jobCardId,
//     required this.customerName,
//     required this.phoneNumber,
//     required this.vehicleNumber,
//     required this.vehicleType,
//     required this.vehicleModel,
//     required this.serviceDate,
//     required this.nextServiceDate,
//     required this.description,
//     required this.mechanicName,
//     required this.mechanicProfile,
//     required this.vehiclePhotos,
//     required this.vehicleVideo,
//     required this.parts,
//     required this.totalPartsCost,
//     required this.status,
//     required this.notes,
//     this.createdBy,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory Job.fromJson(Map<String, dynamic> json) {
//     return Job(
//       id: json['_id'] ?? '',
//       jobCardId: json['jobCardId'] ?? '',
//       customerName: json['customerName'] ?? '',
//       phoneNumber: json['phoneNumber'] ?? '',
//       vehicleNumber: json['vehicleNumber'] ?? '',
//       vehicleType: json['vehicleType'] ?? '',
//       vehicleModel: json['vehicleModel'] ?? '',
//       serviceDate: DateTime.parse(json['serviceDate']),
//       nextServiceDate: DateTime.parse(json['nextServiceDate']),
//       description: json['description'] ?? '',
//       mechanicName: json['mechanicName'] ?? '',
//       mechanicProfile: json['mechanicProfile'] ?? '',
//       vehiclePhotos: List<String>.from(json['vehiclePhotos'] ?? []),
//       vehicleVideo: json['vehicleVideo'] ?? '',
//       parts: (json['parts'] as List)
//           .map((part) => Part.fromJson(part))
//           .toList(),
//       totalPartsCost: json['totalPartsCost'] ?? 0,
//       status: json['status'] ?? '',
//       notes: json['notes'] ?? '',
//       createdBy: json['createdBy'],
//       createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
//       updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'customerName': customerName,
//       'phoneNumber': phoneNumber,
//       'vehicleNumber': vehicleNumber,
//       'vehicleType': vehicleType,
//       'vehicleModel': vehicleModel,
//       'serviceDate': serviceDate.toIso8601String(),
//       'nextServiceDate': nextServiceDate.toIso8601String(),
//       'description': description,
//       'mechanicName': mechanicName,
//       'mechanicProfile': mechanicProfile,
//       'vehiclePhotos': vehiclePhotos,
//       'vehicleVideo': vehicleVideo,
//       'parts': parts.map((p) => p.toJson()).toList(),
//       'status': status,
//       'notes': notes,
//     };
//   }
// }

// class Part {
//   final String partName;
//   final int cost;

//   Part({
//     required this.partName,
//     required this.cost,
//   });

//   factory Part.fromJson(Map<String, dynamic> json) {
//     return Part(
//       partName: json['partName'] ?? '',
//       cost: json['cost'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'partName': partName,
//       'cost': cost,
//     };
//   }
// }

// job_model.dart

class JobResponse {
  final bool success;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final List<Job> jobs;

  JobResponse({
    required this.success,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.jobs,
  });

  factory JobResponse.fromJson(Map<String, dynamic> json) {
    final responseJson = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final jobsJson =
        responseJson['jobs'] ??
        responseJson['data'] ??
        responseJson['result'] ??
        <dynamic>[];

    return JobResponse(
      success:
          responseJson['success'] as bool? ?? json['success'] as bool? ?? true,
      total: _toInt(
        responseJson['total'] ??
            responseJson['totalJobs'] ??
            responseJson['count'],
      ),
      page: _toInt(responseJson['page'], defaultValue: 1),
      limit: _toInt(responseJson['limit'], defaultValue: 10),
      totalPages: _toInt(
        responseJson['totalPages'] ?? responseJson['pages'],
        defaultValue: 1,
      ),
      jobs: (jobsJson is List ? jobsJson : <dynamic>[])
          .map((job) => Job.fromJson(job as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
      'jobs': jobs.map((job) => job.toJson()).toList(),
    };
  }
}

class Job {
  final String id;
  final String jobCardId;
  final String customerName;
  final String phoneNumber;
  final String? garageName;
  final String? todo;
  final Map<String, dynamic>? address;
  final String vehicleNumber;
  final String vehicleType;
  final String? vehicleBrand;
  final String vehicleModel;
  final String? vehicleVariant;
  final String? registrationNumber;
  final int? vehicleYear;
  final String? fuelType;
  final String? transmissionType;
  final int? kmsDriven;
  final Map<String, dynamic>? kmImage;
  final String? vehicleColor;
  final String? ownershipDetails;
  final String? tyreCondition;
  final List<dynamic> tyreConditionDetails;
  final List<dynamic> damagePhotosWithNotes;
  final List<dynamic> inspectionAnswers;
  final Map<String, dynamic>? popupData;
  final DateTime serviceDate;
  final DateTime? nextServiceDate;
  final String description;
  final String mechanicName;
  final String? mechanicProfile;
  final List<dynamic> vehiclePhotos;
  final dynamic vehicleVideo;
  final List<Part> parts;
  final int totalPartsCost;
  final int? totalPrice;
  final int? labourCost;
  final String status;
  final String notes;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Job({
    required this.id,
    required this.jobCardId,
    required this.customerName,
    required this.phoneNumber,
    this.garageName,
    this.todo,
    this.address,
    required this.vehicleNumber,
    required this.vehicleType,
    this.vehicleBrand,
    required this.vehicleModel,
    this.vehicleVariant,
    this.registrationNumber,
    this.vehicleYear,
    this.fuelType,
    this.transmissionType,
    this.kmsDriven,
    this.kmImage,
    this.vehicleColor,
    this.ownershipDetails,
    this.tyreCondition,
    this.tyreConditionDetails = const [],
    this.damagePhotosWithNotes = const [],
    this.inspectionAnswers = const [],
    this.popupData,
    required this.serviceDate,
    this.nextServiceDate,
    required this.description,
    required this.mechanicName,
    this.mechanicProfile,
    required this.vehiclePhotos,
    required this.vehicleVideo,
    required this.parts,
    required this.totalPartsCost,
    this.totalPrice,
    this.labourCost,
    required this.status,
    required this.notes,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: _toStringValue(json['_id'] ?? json['id']),
      jobCardId: _toStringValue(json['jobCardId']),
      customerName: _toStringValue(json['customerName']),
      phoneNumber: _toStringValue(json['phoneNumber']),
      garageName: _toNullableStringValue(
        json['garageName'] ??
            json['garage_name'] ??
            json['garage'] ??
            json['businessName'],
      ),
      todo: _toNullableStringValue(
        json['todo'] ??
            json['toDo'] ??
            json['to_do'] ??
            json['workTodo'] ??
            (json['serviceInformation'] is Map
                ? (json['serviceInformation'] as Map)['todo']
                : null),
      ),
      address: _addressFromJson(json),
      vehicleNumber: _toStringValue(json['vehicleNumber']),
      vehicleType: _toStringValue(json['vehicleType']),
      vehicleBrand: _toNullableStringValue(json['vehicleBrand']),
      vehicleModel: _toStringValue(json['vehicleModel']),
      vehicleVariant: _toNullableStringValue(json['vehicleVariant']),
      registrationNumber: _toNullableStringValue(json['registrationNumber']),
      vehicleYear: _toNullableInt(json['vehicleYear']),
      fuelType: _toNullableStringValue(json['fuelType']),
      transmissionType: _toNullableStringValue(json['transmissionType']),
      kmsDriven: _toNullableInt(json['kmsDriven']),
      kmImage: json['kmImage'] is Map
          ? Map<String, dynamic>.from(json['kmImage'] as Map)
          : null,
      vehicleColor: _toNullableStringValue(json['vehicleColor']),
      ownershipDetails: _toNullableStringValue(json['ownershipDetails']),
      tyreCondition: _tyreConditionToText(json['tyreCondition']),
      tyreConditionDetails: json['tyreCondition'] is List
          ? json['tyreCondition'] as List<dynamic>
          : <dynamic>[],
      damagePhotosWithNotes: _toDynamicList(
        json['damagePhotosWithNotes'] ??
            json['damagePhotos'] ??
            json['damage_photos'],
      ),
      inspectionAnswers: _toDynamicList(
        json['inspectionAnswers'] ??
            (json['popupData'] is Map
                ? (json['popupData'] as Map)['inspectionAnswers']
                : null),
      ),
      popupData: json['popupData'] is Map
          ? Map<String, dynamic>.from(json['popupData'] as Map)
          : null,
      serviceDate: _toDateTime(json['serviceDate']),
      nextServiceDate: json['nextServiceDate'] != null
          ? _toDateTime(json['nextServiceDate'])
          : null,
      description: _toStringValue(json['description']),
      mechanicName: _toStringValue(
        json['mechanicName'] ??
            (json['serviceInformation'] is Map
                ? (json['serviceInformation'] as Map)['mechanicName']
                : null),
      ),
      mechanicProfile: _toNullableStringValue(
        json['mechanicProfile'] ??
            json['mechanic_profile'] ??
            (json['serviceInformation'] is Map
                ? ((json['serviceInformation'] as Map)['mechanicProfile'] ??
                      (json['serviceInformation'] as Map)['mechanic_profile'] ??
                      (json['serviceInformation'] as Map)['profile'])
                : null),
      ),
      vehiclePhotos: _toDynamicList(json['vehiclePhotos']),
      vehicleVideo: json['vehicleVideo'],
      parts: (json['parts'] is List ? json['parts'] as List : <dynamic>[])
          .map((part) => Part.fromJson(part as Map<String, dynamic>))
          .toList(),
      totalPartsCost: _toInt(json['totalPartsCost']),
      totalPrice: _toNullableInt(json['totalPrice']),
      labourCost: _toNullableInt(json['labourCost']),
      status: _toStringValue(json['status'], defaultValue: 'Pending'),
      notes: _toStringValue(json['notes']),
      createdBy: _toStringValue(json['createdBy']),
      createdAt: _toDateTime(json['createdAt']),
      updatedAt: _toDateTime(json['updatedAt']),
      v: _toInt(json['__v']),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'garageName': garageName,
      'todo': todo,
      'address': address,
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType,
      'vehicleBrand': vehicleBrand,
      'vehicleModel': vehicleModel,
      'vehicleVariant': vehicleVariant,
      'registrationNumber': registrationNumber,
      'vehicleYear': vehicleYear,
      'fuelType': fuelType,
      'transmissionType': transmissionType,
      'kmsDriven': kmsDriven,
      'kmImage': kmImage,
      'vehicleColor': vehicleColor,
      'ownershipDetails': ownershipDetails,
      'tyreCondition': tyreConditionDetails.isNotEmpty
          ? tyreConditionDetails
          : _tyreConditionPayload(tyreCondition),
      'damagePhotosWithNotes': damagePhotosWithNotes,
      'popupData': popupData,
      'serviceDate': serviceDate.toIso8601String(),
      'nextServiceDate': nextServiceDate?.toIso8601String(),
      'description': description,
      'mechanicName': mechanicName,
      'mechanicProfile': mechanicProfile,
      'vehiclePhotos': vehiclePhotos,
      'vehicleVideo': vehicleVideo,
      'parts': parts.map((part) => part.toJson()).toList(),
      'totalPartsCost': totalPartsCost,
      'totalPrice': totalPrice,
      'labourCost': labourCost,
      'status': status,
      'notes': notes,
    };

    if (id.isNotEmpty) json['_id'] = id;
    if (jobCardId.isNotEmpty) json['jobCardId'] = jobCardId;
    if (createdBy.isNotEmpty) json['createdBy'] = createdBy;
    if (createdAt.millisecondsSinceEpoch > 0) {
      json['createdAt'] = createdAt.toIso8601String();
    }
    json['updatedAt'] = updatedAt.toIso8601String();
    if (v > 0) json['__v'] = v;

    json.removeWhere((key, value) => value == null);
    return json;
  }
}

class Part {
  final String partName;
  final double? quantity;
  final int cost;
  final String? id;

  Part({required this.partName, this.quantity, required this.cost, this.id});

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(
      partName: _toStringValue(json['partName']),
      quantity: _toNullableDouble(json['quantity']),
      cost: _toInt(json['cost']),
      id: _toNullableStringValue(json['_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'partName': partName,
      if (quantity != null) 'quantity': quantity,
      'cost': cost,
      if (id != null) '_id': id,
    };
  }
}

String _toStringValue(dynamic value, {String defaultValue = ''}) {
  if (value == null) return defaultValue;
  return value.toString();
}

String? _toNullableStringValue(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  if (text.isEmpty || text.toLowerCase() == 'null') return null;
  return text;
}

Map<String, dynamic>? _addressFromJson(Map<String, dynamic> json) {
  final source = json['address'];
  final address = source is Map
      ? Map<String, dynamic>.from(source)
      : <String, dynamic>{};
  final fullAddress =
      _toNullableStringValue(json['fullAddress']) ??
      _toNullableStringValue(json['customerAddress']);

  if (fullAddress != null) address['fullAddress'] = fullAddress;
  final city = _toNullableStringValue(json['city']);
  if (city != null) address['city'] = city;
  final state = _toNullableStringValue(json['state']);
  if (state != null) address['state'] = state;
  final pincode = _toNullableStringValue(json['pincode']);
  if (pincode != null) address['pincode'] = pincode;
  final landmark = _toNullableStringValue(json['landmark']);
  if (landmark != null) address['landmark'] = landmark;

  address.removeWhere(
    (key, value) => value == null || value.toString().trim().isEmpty,
  );
  return address.isEmpty ? null : address;
}

int _toInt(dynamic value, {int defaultValue = 0}) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? defaultValue;
  return defaultValue;
}

int? _toNullableInt(dynamic value) {
  if (value == null) return null;
  return _toInt(value);
}

double? _toNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

List<dynamic> _toDynamicList(dynamic value) {
  if (value == null) return <dynamic>[];
  if (value is List) return value;
  return <dynamic>[value];
}

DateTime _toDateTime(dynamic value) {
  if (value is DateTime) return value;
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value) ?? DateTime.now();
  }
  return DateTime.now();
}

String? _tyreConditionToText(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is List) {
    return value
        .map((item) {
          if (item is Map) {
            final position = item['position']?.toString() ?? '';
            final condition = item['condition']?.toString() ?? '';
            final brand = item['brand']?.toString() ?? '';
            final size = item['size']?.toString() ?? '';
            return [
              position,
              condition,
              brand,
              size,
            ].where((part) => part.isNotEmpty).join(' - ');
          }
          return item.toString();
        })
        .join('\n');
  }
  return value.toString();
}

List<Map<String, dynamic>>? _tyreConditionPayload(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  return [
    {'position': 'General', 'condition': value.trim()},
  ];
}

// Optional: Extension for VehiclePhoto and VehicleVideo if needed
class VehiclePhoto {
  final String url;
  final String publicId;
  final String? id;

  VehiclePhoto({required this.url, required this.publicId, this.id});

  factory VehiclePhoto.fromJson(Map<String, dynamic> json) {
    return VehiclePhoto(
      url: _toStringValue(json['url']),
      publicId: _toStringValue(json['public_id']),
      id: _toNullableStringValue(json['_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'public_id': publicId, if (id != null) '_id': id};
  }
}

class VehicleVideo {
  final String url;
  final String publicId;

  VehicleVideo({required this.url, required this.publicId});

  factory VehicleVideo.fromJson(Map<String, dynamic> json) {
    return VehicleVideo(
      url: _toStringValue(json['url']),
      publicId: _toStringValue(json['public_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'public_id': publicId};
  }
}
