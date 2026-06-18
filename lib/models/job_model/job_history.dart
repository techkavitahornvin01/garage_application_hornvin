// lib/models/job_model/job_history_model.dart

import 'package:hornvin/models/job_model/job_model.dart';

class JobHistoryResponse {
  final bool success;
  final String vehicleNumber;
  final int count;
  final List<Job> data;

  JobHistoryResponse({
    required this.success,
    required this.vehicleNumber,
    required this.count,
    required this.data,
  });

  factory JobHistoryResponse.fromJson(Map<String, dynamic> json) {
    return JobHistoryResponse(
      success: json['success'] as bool? ?? true,
      vehicleNumber: json['vehicleNumber']?.toString() ?? '',
      count: _toInt(json['count']),
      data: (json['data'] is List ? json['data'] as List : <dynamic>[])
          .map((job) => Job.fromJson(job as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'vehicleNumber': vehicleNumber,
      'count': count,
      'data': data.map((job) => job.toJson()).toList(),
    };
  }
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
