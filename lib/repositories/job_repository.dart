// // // import 'package:hornvin/models/job_model/job_model.dart';

// // // import '../services/api_service.dart';
// // // import '../utils/constants.dart';

// // // class JobRepository {
// // //   final ApiService _apiService = ApiService();

// // //   Future<JobResponse> getAllJobs({int page = 1, int limit = 10}) async {
// // //     try {
// // //       final response = await _apiService.get(
// // //         '${ApiConstants.jobs}?page=$page&limit=$limit'
// // //       );
// // //       return JobResponse.fromJson(response);
// // //     } catch (e) {
// // //       throw Exception('Failed to fetch jobs: $e');
// // //     }
// // //   }

// // //   Future<Job> getJobById(String id) async {
// // //     try {
// // //       final response = await _apiService.get('${ApiConstants.jobs}/$id');
// // //       return Job.fromJson(response['job']);
// // //     } catch (e) {
// // //       throw Exception('Failed to fetch job: $e');
// // //     }
// // //   }

// // //   Future<Job> createJob(Job job) async {
// // //     try {
// // //       final response = await _apiService.post(
// // //         ApiConstants.createJob,
// // //         job.toJson()
// // //       );
// // //       return Job.fromJson(response['job']);
// // //     } catch (e) {
// // //       throw Exception('Failed to create job: $e');
// // //     }
// // //   }

// // //   Future<Job> updateJob(String id, Job job) async {
// // //     try {
// // //       final response = await _apiService.put(
// // //         '${ApiConstants.updateJob}/$id',
// // //         job.toJson()
// // //       );
// // //       return Job.fromJson(response['job']);
// // //     } catch (e) {
// // //       throw Exception('Failed to update job: $e');
// // //     }
// // //   }

// // //   Future<void> deleteJob(String id) async {
// // //     try {
// // //       await _apiService.delete('${ApiConstants.deleteJob}/$id');
// // //     } catch (e) {
// // //       throw Exception('Failed to delete job: $e');
// // //     }
// // //   }
// // // }
// // import 'package:hornvin/models/job_model/job_model.dart';
// // import '../services/api_service.dart';
// // import '../utils/constants.dart';

// // class JobRepository {
// //   final ApiService _apiService = ApiService();

// //   Future<JobResponse> getAllJobs({int page = 1, int limit = 10}) async {
// //     print('\n🔵 ========== GET ALL JOBS START ==========');
// //     print('📄 Page: $page, Limit: $limit');

// //     try {
// //       final endpoint = '${ApiConstants.jobs}?page=$page&limit=$limit';
// //       print('🌐 Request URL: ${ApiConstants.baseUrl}$endpoint');

// //       final response = await _apiService.get(endpoint);

// //       print('📦 Raw API Response:');
// //       print('─' * 60);
// //       print(response);
// //       print('─' * 60);

// //       print('\n🔄 Parsing response to JobResponse...');
// //       final jobResponse = JobResponse.fromJson(response);

// //       print('✅ Parse successful!');
// //       print('📊 Response Data:');
// //       print('   - Success: ${jobResponse.success}');
// //       print('   - Total Jobs: ${jobResponse.total}');
// //       print('   - Current Page: ${jobResponse.page}');
// //       print('   - Total Pages: ${jobResponse.totalPages}');
// //       print('   - Jobs Count in List: ${jobResponse.jobs.length}');

// //       if (jobResponse.jobs.isNotEmpty) {
// //         print('\n📋 First Job Preview:');
// //         print('   - ID: ${jobResponse.jobs[0].id}');
// //         print('   - Customer: ${jobResponse.jobs[0].customerName}');
// //         print('   - Vehicle: ${jobResponse.jobs[0].vehicleNumber}');
// //         print('   - Status: ${jobResponse.jobs[0].status}');
// //       }

// //       print('🔵 ========== GET ALL JOBS END ==========\n');
// //       return jobResponse;

// //     } catch (e, stackTrace) {
// //       print('❌ ERROR in getAllJobs:');
// //       print('   - Error: $e');
// //       print('   - StackTrace: $stackTrace');
// //       print('🔴 ========== GET ALL JOBS FAILED ==========\n');
// //       throw Exception('Failed to fetch jobs: $e');
// //     }
// //   }

// //   Future<Job> getJobById(String id) async {
// //     print('\n🔵 ========== GET JOB BY ID START ==========');
// //     print('🆔 Job ID: $id');

// //     try {
// //       final endpoint = '${ApiConstants.jobs}/$id';
// //       print('🌐 Request URL: ${ApiConstants.baseUrl}$endpoint');

// //       final response = await _apiService.get(endpoint);

// //       print('📦 Raw API Response:');
// //       print('─' * 60);
// //       print(response);
// //       print('─' * 60);

// //       print('\n🔄 Checking for "job" key in response...');
// //       if (!response.containsKey('job')) {
// //         print('⚠️ Response missing "job" key!');
// //         print('Available keys: ${response.keys}');
// //         throw Exception('Invalid response format: missing job field');
// //       }

// //       print('🔄 Parsing job data...');
// //       final job = Job.fromJson(response['job']);

// //       print('✅ Parse successful!');
// //       print('📋 Job Details:');
// //       print('   - ID: ${job.id}');
// //       print('   - Job Card ID: ${job.jobCardId}');
// //       print('   - Customer: ${job.customerName}');
// //       print('   - Phone: ${job.phoneNumber}');
// //       print('   - Vehicle: ${job.vehicleNumber} (${job.vehicleModel})');
// //       print('   - Status: ${job.status}');
// //       print('   - Parts Count: ${job.parts.length}');
// //       print('   - Total Cost: ${job.totalPartsCost}');

// //       print('🔵 ========== GET JOB BY ID END ==========\n');
// //       return job;

// //     } catch (e, stackTrace) {
// //       print('❌ ERROR in getJobById:');
// //       print('   - Error: $e');
// //       print('   - StackTrace: $stackTrace');
// //       print('🔴 ========== GET JOB BY ID FAILED ==========\n');
// //       throw Exception('Failed to fetch job: $e');
// //     }
// //   }

// //   Future<Job> createJob(Job job) async {
// //     print('\n🟢 ========== CREATE JOB START ==========');
// //     print('📝 Creating job for: ${job.customerName}');

// //     try {
// //       final requestData = job.toJson();
// //       print('📤 Request Data:');
// //       print('─' * 60);
// //       print('Customer: ${requestData['customerName']}');
// //       print('Phone: ${requestData['phoneNumber']}');
// //       print('Vehicle: ${requestData['vehicleNumber']}');
// //       print('Model: ${requestData['vehicleModel']}');
// //       print('Status: ${requestData['status']}');
// //       print('Parts count: ${requestData['parts']?.length}');
// //       print('─' * 60);

// //       print('🌐 Request URL: ${ApiConstants.baseUrl}${ApiConstants.createJob}');

// //       final response = await _apiService.post(
// //         ApiConstants.createJob,
// //         requestData
// //       );

// //       print('📦 Raw API Response:');
// //       print('─' * 60);
// //       print(response);
// //       print('─' * 60);

// //       print('\n🔄 Checking for "job" key in response...');
// //       if (!response.containsKey('job')) {
// //         print('⚠️ Response missing "job" key!');
// //         print('Available keys: ${response.keys}');
// //         throw Exception('Invalid response format: missing job field');
// //       }

// //       print('🔄 Parsing created job...');
// //       final createdJob = Job.fromJson(response['job']);

// //       print('✅ Job created successfully!');
// //       print('📋 Created Job Details:');
// //       print('   - ID: ${createdJob.id}');
// //       print('   - Job Card ID: ${createdJob.jobCardId}');
// //       print('   - Customer: ${createdJob.customerName}');
// //       print('   - Created At: ${createdJob.createdAt}');

// //       print('🟢 ========== CREATE JOB END ==========\n');
// //       return createdJob;

// //     } catch (e, stackTrace) {
// //       print('❌ ERROR in createJob:');
// //       print('   - Error: $e');
// //       print('   - StackTrace: $stackTrace');
// //       print('🔴 ========== CREATE JOB FAILED ==========\n');
// //       throw Exception('Failed to create job: $e');
// //     }
// //   }

// //   Future<Job> updateJob(String id, Job job) async {
// //     print('\n🟡 ========== UPDATE JOB START ==========');
// //     print('🆔 Job ID: $id');
// //     print('📝 Updating job for: ${job.customerName}');

// //     try {
// //       final requestData = job.toJson();
// //       print('📤 Update Data:');
// //       print('─' * 60);
// //       print('Status: ${requestData['status']}');
// //       print('Notes: ${requestData['notes']}');
// //       print('Parts count: ${requestData['parts']?.length}');
// //       print('─' * 60);

// //       final endpoint = '${ApiConstants.updateJob}/$id';
// //       print('🌐 Request URL: ${ApiConstants.baseUrl}$endpoint');

// //       final response = await _apiService.put(
// //         endpoint,
// //         requestData
// //       );

// //       print('📦 Raw API Response:');
// //       print('─' * 60);
// //       print(response);
// //       print('─' * 60);

// //       print('\n🔄 Checking for "job" key in response...');
// //       if (!response.containsKey('job')) {
// //         print('⚠️ Response missing "job" key!');
// //         print('Available keys: ${response.keys}');
// //         throw Exception('Invalid response format: missing job field');
// //       }

// //       print('🔄 Parsing updated job...');
// //       final updatedJob = Job.fromJson(response['job']);

// //       print('✅ Job updated successfully!');
// //       print('📋 Updated Job Details:');
// //       print('   - ID: ${updatedJob.id}');
// //       print('   - Customer: ${updatedJob.customerName}');
// //       print('   - Status: ${updatedJob.status}');
// //       print('   - Updated At: ${updatedJob.updatedAt}');

// //       print('🟡 ========== UPDATE JOB END ==========\n');
// //       return updatedJob;

// //     } catch (e, stackTrace) {
// //       print('❌ ERROR in updateJob:');
// //       print('   - Error: $e');
// //       print('   - StackTrace: $stackTrace');
// //       print('🔴 ========== UPDATE JOB FAILED ==========\n');
// //       throw Exception('Failed to update job: $e');
// //     }
// //   }

// //   Future<void> deleteJob(String id) async {
// //     print('\n🔴 ========== DELETE JOB START ==========');
// //     print('🆔 Job ID to delete: $id');

// //     try {
// //       final endpoint = '${ApiConstants.deleteJob}/$id';
// //       print('🌐 Request URL: ${ApiConstants.baseUrl}$endpoint');

// //       final response = await _apiService.delete(endpoint);

// //       print('📦 Raw API Response:');
// //       print('─' * 60);
// //       print(response);
// //       print('─' * 60);

// //       print('✅ Job deleted successfully!');
// //       print('🔴 ========== DELETE JOB END ==========\n');

// //     } catch (e, stackTrace) {
// //       print('❌ ERROR in deleteJob:');
// //       print('   - Error: $e');
// //       print('   - StackTrace: $stackTrace');
// //       print('🔴 ========== DELETE JOB FAILED ==========\n');
// //       throw Exception('Failed to delete job: $e');
// //     }
// //   }
// // }

// import 'package:hornvin/models/job_model/job_model.dart';
// import '../services/api_service.dart';
// import '../utils/constants.dart';

// class JobRepository {
//   final ApiService _apiService = ApiService();

//   Future<JobResponse> getAllJobs({int page = 1, int limit = 10}) async {
//     print('\n🔵 ========== GET ALL JOBS START ==========');
//     print('📄 Page: $page, Limit: $limit');

//     try {
//       final endpoint = '${ApiConstants.jobs}?page=$page&limit=$limit';
//       print('🌐 Request URL: ${ApiConstants.baseUrl}$endpoint');

//       // ApiService automatically adds token
//       final response = await _apiService.get(endpoint);

//       print('📦 Raw API Response:');
//       print('─' * 60);
//       print(response);
//       print('─' * 60);

//       print('\n🔄 Parsing response to JobResponse...');
//       final jobResponse = JobResponse.fromJson(response);

//       print('✅ Parse successful!');
//       print('📊 Response Data:');
//       print('   - Success: ${jobResponse.success}');
//       print('   - Total Jobs: ${jobResponse.total}');
//       print('   - Current Page: ${jobResponse.page}');
//       print('   - Total Pages: ${jobResponse.totalPages}');
//       print('   - Jobs Count in List: ${jobResponse.jobs.length}');

//       print('🔵 ========== GET ALL JOBS END ==========\n');
//       return jobResponse;

//     } catch (e, stackTrace) {
//       print('❌ ERROR in getAllJobs:');
//       print('   - Error: $e');
//       print('   - StackTrace: $stackTrace');
//       print('🔴 ========== GET ALL JOBS FAILED ==========\n');
//       throw Exception('Failed to fetch jobs: $e');
//     }
//   }

//   Future<Job> createJob(Job job) async {
//     print('\n🟢 ========== CREATE JOB START ==========');
//     print('📝 Creating job for: ${job.customerName}');

//     try {
//       final requestData = job.toJson();
//       print('📤 Request Data:');
//       print('─' * 60);
//       print('Customer: ${requestData['customerName']}');
//       print('Phone: ${requestData['phoneNumber']}');
//       print('Vehicle: ${requestData['vehicleNumber']}');
//       print('Model: ${requestData['vehicleModel']}');
//       print('Status: ${requestData['status']}');
//       print('─' * 60);

//       print('🌐 Request URL: ${ApiConstants.baseUrl}${ApiConstants.createJob}');

//       // ApiService automatically adds token
//       final response = await _apiService.post(
//         ApiConstants.createJob,
//         requestData
//       );

//       print('📦 Raw API Response:');
//       print('─' * 60);
//       print(response);
//       print('─' * 60);

//       if (!response.containsKey('job')) {
//         print('⚠️ Response missing "job" key!');
//         throw Exception('Invalid response format: missing job field');
//       }

//       final createdJob = Job.fromJson(response['job']);

//       print('✅ Job created successfully!');
//       print('📋 Created Job Details:');
//       print('   - ID: ${createdJob.id}');
//       print('   - Customer: ${createdJob.customerName}');

//       print('🟢 ========== CREATE JOB END ==========\n');
//       return createdJob;

//     } catch (e, stackTrace) {
//       print('❌ ERROR in createJob:');
//       print('   - Error: $e');
//       print('   - StackTrace: $stackTrace');
//       print('🔴 ========== CREATE JOB FAILED ==========\n');
//       throw Exception('Failed to create job: $e');
//     }
//   }

//   Future<Job> updateJob(String id, Job job) async {
//     print('\n🟡 ========== UPDATE JOB START ==========');
//     print('🆔 Job ID: $id');

//     try {
//       final requestData = job.toJson();
//       final endpoint = '${ApiConstants.updateJob}/$id';

//       // ApiService automatically adds token
//       final response = await _apiService.put(endpoint, requestData);

//       print('📦 Raw API Response:');
//       print('─' * 60);
//       print(response);
//       print('─' * 60);

//       if (!response.containsKey('job')) {
//         throw Exception('Invalid response format: missing job field');
//       }

//       final updatedJob = Job.fromJson(response['job']);

//       print('✅ Job updated successfully!');
//       print('🟡 ========== UPDATE JOB END ==========\n');
//       return updatedJob;

//     } catch (e, stackTrace) {
//       print('❌ ERROR in updateJob:');
//       print('   - Error: $e');
//       print('🔴 ========== UPDATE JOB FAILED ==========\n');
//       throw Exception('Failed to update job: $e');
//     }
//   }

//   Future<void> deleteJob(String id) async {
//     print('\n🔴 ========== DELETE JOB START ==========');
//     print('🆔 Job ID to delete: $id');

//     try {
//       final endpoint = '${ApiConstants.deleteJob}/$id';

//       // ApiService automatically adds token
//       await _apiService.delete(endpoint);

//       print('✅ Job deleted successfully!');
//       print('🔴 ========== DELETE JOB END ==========\n');

//     } catch (e, stackTrace) {
//       print('❌ ERROR in deleteJob:');
//       print('   - Error: $e');
//       print('🔴 ========== DELETE JOB FAILED ==========\n');
//       throw Exception('Failed to delete job: $e');
//     }
//   }
// }

// lib/repositories/job_repository.dart
import 'dart:convert';
import 'dart:io';

import 'package:hornvin/models/job_model/job_history.dart'
    show JobHistoryResponse;
import 'package:hornvin/models/job_model/job_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

class JobRepository {
  final ApiService _apiService = ApiService();

  // Get all jobs
  Future<JobResponse> getAllJobs({
    int page = 1,
    int limit = 10,
    String? vehicleType,
  }) async {
    print('\n🔵 ========== GET ALL JOBS START ==========');
    print('📄 Page: $page, Limit: $limit');

    try {
      final query = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (vehicleType != null && vehicleType.trim().isNotEmpty)
          'vehicleType': vehicleType.trim(),
      };
      final endpoint = Uri(
        path: ApiConstants.jobs,
        queryParameters: query,
      ).toString();
      final response = await _apiService.get(endpoint);

      print('✅ Jobs fetched successfully!');
      final jobResponse = JobResponse.fromJson(response);
      print('📊 Total Jobs: ${jobResponse.total}');
      print('🔵 ========== GET ALL JOBS END ==========\n');

      return jobResponse;
    } catch (e) {
      print('❌ ERROR in getAllJobs: $e');
      print('🔴 ========== GET ALL JOBS FAILED ==========\n');
      throw Exception('Failed to fetch jobs: $e');
    }
  }

  Future<List<String>> getVehicleTypes() async {
    print('\n========== GET VEHICLE TYPES START ==========');

    try {
      final endpoint = Uri(path: ApiConstants.vehicleHistory).toString();
      print('Request URL: ${ApiConstants.baseUrl}$endpoint');
      final response = await _apiService.get(endpoint);
      final vehicleTypes = _extractVehicleTypes(response);

      print('Vehicle types fetched: $vehicleTypes');
      print('========== GET VEHICLE TYPES END ==========\n');
      return vehicleTypes;
    } catch (e) {
      print('ERROR in getVehicleTypes: $e');
      print('========== GET VEHICLE TYPES FAILED ==========\n');
      throw Exception('Failed to fetch vehicle types: $e');
    }
  }

  // Get job history by vehicle number
  Future<JobHistoryResponse> getJobHistory(String vehicleNumber) async {
    print('\n📜 ========== GET JOB HISTORY START ==========');
    print('🚗 Vehicle Number: $vehicleNumber');

    try {
      final endpoint = '${ApiConstants.jobHistory}/$vehicleNumber';
      print('🌐 Request URL: ${ApiConstants.baseUrl}$endpoint');

      final response = await _apiService.get(endpoint);

      print('📦 Raw API Response:');
      print('─' * 60);
      print(response);
      print('─' * 60);

      print('🔄 Parsing response to JobHistoryResponse...');
      final historyResponse = JobHistoryResponse.fromJson(response);

      print('✅ Parse successful!');
      print('📊 Response Data:');
      print('   - Success: ${historyResponse.success}');
      print('   - Vehicle Number: ${historyResponse.vehicleNumber}');
      print('   - Total Jobs Count: ${historyResponse.count}');
      print('   - Jobs in List: ${historyResponse.data.length}');

      print('📜 ========== GET JOB HISTORY END ==========\n');
      return historyResponse;
    } catch (e, stackTrace) {
      print('❌ ERROR in getJobHistory:');
      print('   - Error: $e');
      print('   - StackTrace: $stackTrace');
      print('🔴 ========== GET JOB HISTORY FAILED ==========\n');
      throw Exception('Failed to fetch job history: $e');
    }
  }

  Future<Map<String, dynamic>> getAllGarageVehicleServiceHistory() async {
    print(
      '\n========== GET ALL GARAGE VEHICLE SERVICE HISTORY START ==========',
    );
    try {
      print('Request URL: ${ApiConstants.baseUrl}${ApiConstants.jobHistory}');
      final response = await _apiService.get(ApiConstants.jobHistory);
      print('Response: $response');
      print(
        '========== GET ALL GARAGE VEHICLE SERVICE HISTORY END ==========\n',
      );
      return response is Map<String, dynamic> ? response : {'data': response};
    } catch (e) {
      print('ERROR in getAllGarageVehicleServiceHistory: $e');
      print(
        '========== GET ALL GARAGE VEHICLE SERVICE HISTORY FAILED ==========\n',
      );
      throw Exception('Failed to fetch garage vehicle service history: $e');
    }
  }

  Future<Map<String, dynamic>> getGarageVehicleHistory() async {
    print('\n📜 ========== GET GARAGE VEHICLE HISTORY START ==========');

    try {
      final response = await _apiService.get(ApiConstants.garageVehicleHistory);
      print('✅ Garage vehicle history fetched successfully');
      print('📜 ========== GET GARAGE VEHICLE HISTORY END ==========\n');

      if (response is Map<String, dynamic>) return response;
      return {'success': true, 'data': response};
    } catch (e, stackTrace) {
      print('❌ ERROR in getGarageVehicleHistory:');
      print('   - Error: $e');
      print('   - StackTrace: $stackTrace');
      print('🔴 ========== GET GARAGE VEHICLE HISTORY FAILED ==========\n');
      throw Exception('Failed to fetch garage vehicle history: $e');
    }
  }

  Future<Map<String, dynamic>> getGarageHistory({
    String? employeeId,
    String? mechanicName,
    String? vehicleNumber,
    String? status,
    String? dateFrom,
    String? dateTo,
  }) async {
    print('\n========== GET GARAGE HISTORY START ==========');

    try {
      final query = <String, String>{
        if (employeeId != null) 'employeeId': employeeId,
        if (mechanicName != null) 'mechanicName': mechanicName,
        if (vehicleNumber != null) 'vehicleNumber': vehicleNumber,
        if (status != null) 'status': status,
        if (dateFrom != null) 'dateFrom': dateFrom,
        if (dateTo != null) 'dateTo': dateTo,
      }..removeWhere((key, value) => value.trim().isEmpty);

      final endpoint = Uri(
        path: ApiConstants.garageVehicleHistory,
        queryParameters: query.isEmpty ? null : query,
      ).toString();
      print('Request URL: ${ApiConstants.baseUrl}$endpoint');

      final response = await _apiService.get(endpoint);
      print('Response: $response');
      print('========== GET GARAGE HISTORY END ==========\n');
      return response is Map<String, dynamic> ? response : {'data': response};
    } catch (e) {
      print('ERROR in getGarageHistory: $e');
      print('========== GET GARAGE HISTORY FAILED ==========\n');
      throw Exception('Failed to fetch garage history: $e');
    }
  }

  Future<Map<String, dynamic>> getVehicleHistorySearch({
    String? vehicleNumber,
    String? registrationNumber,
    String? phoneNumber,
    String? customerName,
    String? status,
    String? mechanicName,
    String? vehicleType,
    String? dateFrom,
    String? dateTo,
  }) async {
    print('\n========== GET VEHICLE HISTORY SEARCH START ==========');

    try {
      final query = <String, String>{
        if (vehicleNumber != null) 'vehicleNumber': vehicleNumber,
        if (registrationNumber != null)
          'registrationNumber': registrationNumber,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
        if (customerName != null) 'customerName': customerName,
        if (status != null) 'status': status,
        if (mechanicName != null) 'mechanicName': mechanicName,
        if (vehicleType != null) 'vehicleType': vehicleType,
        if (dateFrom != null) 'dateFrom': dateFrom,
        if (dateTo != null) 'dateTo': dateTo,
      }..removeWhere((key, value) => value.trim().isEmpty);

      final endpoint = Uri(
        path: ApiConstants.vehicleHistory,
        queryParameters: query.isEmpty ? null : query,
      ).toString();
      print('Request URL: ${ApiConstants.baseUrl}$endpoint');

      final response = await _apiService.get(endpoint);
      print('Response: $response');
      print('========== GET VEHICLE HISTORY SEARCH END ==========\n');
      return response is Map<String, dynamic> ? response : {'data': response};
    } catch (e) {
      print('ERROR in getVehicleHistorySearch: $e');
      print('========== GET VEHICLE HISTORY SEARCH FAILED ==========\n');
      throw Exception('Failed to search vehicle history: $e');
    }
  }

  // Create a new job
  Future<Map<String, dynamic>> createJob(
    Job job, {
    Map<String, dynamic>? inspectionChecklist,
    List<Map<String, dynamic>> inspectionAnswers = const [],
  }) async {
    print('\n========== CREATE JOB API INTEGRATION START ==========');
    print('Method: POST');
    print('URL: ${ApiConstants.baseUrl}${ApiConstants.createJob}');
    print('Customer: ${job.customerName}');
    print('\n🟢 ========== CREATE JOB START ==========');
    print('📝 Creating job for: ${job.customerName}');

    try {
      final requestData = _createJobRequestPayload(
        job,
        inspectionChecklist: inspectionChecklist,
        inspectionAnswers: inspectionAnswers,
      );
      final files = _createJobMultipartFiles(requestData);
      if (files.isNotEmpty) {
        _replaceUploadedJobCardMediaPaths(requestData, files.keys.toSet());
      }
      final jobCard = requestData['jobCard'] as Map<String, dynamic>;
      final vehicleNumber = (jobCard['vehicleNumber'] ?? '').toString().trim();
      if ((jobCard['registrationNumber'] ?? '').toString().trim().isEmpty &&
          vehicleNumber.isNotEmpty) {
        jobCard['registrationNumber'] = vehicleNumber;
      }
      print('Request Body:');
      print(const JsonEncoder.withIndent('  ').convert(requestData));
      final response = files.isEmpty
          ? await _apiService.post(ApiConstants.createJob, requestData)
          : await _apiService.postMultipart(
              ApiConstants.createJob,
              fields: {
                'jobCard': jsonEncode(requestData['jobCard']),
                'vehicleType': jsonEncode(requestData['vehicleType']),
                'popupData': jsonEncode(requestData['popupData']),
              },
              files: files,
            );
      print('Response Body:');
      print(const JsonEncoder.withIndent('  ').convert(response));
      print('========== CREATE JOB API INTEGRATION END ==========\n');

      print('✅ Job created successfully!');
      print('🟢 ========== CREATE JOB END ==========\n');

      final responseMap = response is Map<String, dynamic>
          ? response
          : <String, dynamic>{'data': response};
      final success = responseMap['success'] != false;

      return {
        'success': success,
        'data': responseMap,
        'message': responseMap['message'] ?? 'Job created successfully',
      };
    } catch (e) {
      print('❌ ERROR in createJob: $e');
      print('🔴 ========== CREATE JOB FAILED ==========\n');
      return {'success': false, 'message': 'Failed to create job: $e'};
    }
  }

  // Update job
  Future<Map<String, dynamic>> updateJob(String id, Job job) async {
    print('\n🟡 ========== UPDATE JOB START ==========');
    print('🆔 Job ID: $id');

    try {
      final requestData = _jobPayload(job);
      final endpoint = '${ApiConstants.updateJob}/$id';
      print('Method: PUT');
      print('URL: ${ApiConstants.baseUrl}$endpoint');
      print('Request Body:');
      print(const JsonEncoder.withIndent('  ').convert(requestData));
      final response = await _apiService.put(endpoint, requestData);
      print('Response Body:');
      print(const JsonEncoder.withIndent('  ').convert(response));

      print('✅ Job updated successfully!');
      print('🟡 ========== UPDATE JOB END ==========\n');

      return {
        'success': true,
        'data': response,
        'message': 'Job updated successfully',
      };
    } catch (e) {
      print('❌ ERROR in updateJob: $e');
      print('🔴 ========== UPDATE JOB FAILED ==========\n');
      return {'success': false, 'message': 'Failed to update job: $e'};
    }
  }

  // Delete job
  Future<Map<String, dynamic>> deleteJob(String id) async {
    print('\n🔴 ========== DELETE JOB START ==========');
    print('🆔 Job ID to delete: $id');

    try {
      final endpoint = '${ApiConstants.deleteJob}/$id';
      await _apiService.delete(endpoint);

      print('✅ Job deleted successfully!');
      print('🔴 ========== DELETE JOB END ==========\n');

      return {'success': true, 'message': 'Job deleted successfully'};
    } catch (e) {
      print('❌ ERROR in deleteJob: $e');
      print('🔴 ========== DELETE JOB FAILED ==========\n');
      return {'success': false, 'message': 'Failed to delete job: $e'};
    }
  }

  Map<String, dynamic> _jobPayload(Job job) {
    final payload = job.toJson()
      ..remove('_id')
      ..remove('jobCardId')
      ..remove('totalPartsCost')
      ..remove('createdBy')
      ..remove('createdAt')
      ..remove('updatedAt')
      ..remove('__v');
    final address = job.address ?? <String, dynamic>{};
    payload.addAll({
      if (address['fullAddress'] != null) 'fullAddress': address['fullAddress'],
      if (address['city'] != null) 'city': address['city'],
      if (address['state'] != null) 'state': address['state'],
      if (address['pincode'] != null) 'pincode': address['pincode'],
      if (address['landmark'] != null) 'landmark': address['landmark'],
    });
    final serviceInformation = <String, dynamic>{
      'description': job.description,
      if ((job.todo ?? '').trim().isNotEmpty) 'todo': job.todo,
      if (job.labourCost != null) 'labourCost': job.labourCost,
      if (job.totalPrice != null) 'totalPrice': job.totalPrice,
      if (job.mechanicName.trim().isNotEmpty)
        'mechanicName': job.mechanicName.trim(),
      if ((job.mechanicProfile ?? '').trim().isNotEmpty)
        'mechanicProfile': job.mechanicProfile!.trim(),
    };
    serviceInformation.removeWhere(
      (key, value) => value == null || value.toString().trim().isEmpty,
    );
    if (serviceInformation.isNotEmpty) {
      payload['serviceInformation'] = serviceInformation;
    }
    payload.removeWhere(
      (key, value) =>
          value == null ||
          (value is String && value.trim().isEmpty) ||
          (value is List && value.isEmpty) ||
          (value is Map && value.isEmpty),
    );
    return payload;
  }

  Map<String, dynamic> _createJobRequestPayload(
    Job job, {
    Map<String, dynamic>? inspectionChecklist,
    List<Map<String, dynamic>> inspectionAnswers = const [],
  }) {
    final normalizedVehicleType = _inspectionVehicleTypeParam(job.vehicleType);
    final totalPoints = _toIntValue(
      inspectionChecklist?['totalPoints'] ??
          inspectionChecklist?['totalpoints'] ??
          inspectionChecklist?['points'],
    );

    return {
      'jobCard': _jobCardPayload(job, normalizedVehicleType),
      'vehicleType': {
        'vehicleType': normalizedVehicleType,
        'totalPoints': totalPoints,
      },
      'popupData': {
        'inspectionChecklist': {
          'vehicleType': normalizedVehicleType,
          'totalPoints': totalPoints,
          'sections': inspectionChecklist?['sections'] ?? <dynamic>[],
        },
        'inspectionAnswers': inspectionAnswers,
      },
    };
  }

  Map<String, dynamic> _jobCardPayload(Job job, String normalizedVehicleType) {
    final payload = _jobPayload(job);
    final address = job.address ?? <String, dynamic>{};
    final partsTotal = job.parts.fold<int>(0, (sum, part) => sum + part.cost);
    final labourCost = job.labourCost ?? 0;
    final serviceTotal = job.totalPrice ?? (partsTotal + labourCost);

    payload
      ..remove('address')
      ..remove('registrationNumber')
      ..remove('kmImage')
      ..remove('damagePhotosWithNotes')
      ..['fullAddress'] = address['fullAddress']
      ..['city'] = address['city']
      ..['pincode'] = address['pincode']
      ..['vehicleType'] = normalizedVehicleType
      ..['serviceDate'] = 'auto'
      ..['nextServiceDate'] = _dateOnly(job.nextServiceDate)
      ..['tyreCondition'] = _tyreConditionDetailsPayload(job)
      ..['tyreBrand'] = _firstTyreDetail(job, 'brand')
      ..['tyreSize'] = _firstTyreDetail(job, 'size')
      ..['tyreNotes'] = _firstTyreDetail(job, 'notes')
      ..['vehiclePhotos'] = _mediaListPayload(
        job.vehiclePhotos,
        'vehicle_photo',
      )
      ..['vehicleVideo'] = _mediaPayload(job.vehicleVideo, 'vehicle_video')
      ..['totalPrice'] = partsTotal
      ..['serviceInformation'] = {
        'description': job.description,
        if ((job.todo ?? '').trim().isNotEmpty) 'todo': job.todo,
        'labourCost': labourCost,
        'totalPrice': serviceTotal,
        if (job.mechanicName.trim().isNotEmpty)
          'mechanicName': job.mechanicName.trim(),
        if ((job.mechanicProfile ?? '').trim().isNotEmpty)
          'mechanicProfile': job.mechanicProfile!.trim(),
      };

    if (address['state'] != null) payload['state'] = address['state'];
    if (address['landmark'] != null) payload['landmark'] = address['landmark'];
    if ((job.registrationNumber ?? '').trim().isNotEmpty) {
      payload['registrationNumber'] = job.registrationNumber;
    }
    if (job.kmImage != null) {
      payload['kmImage'] = _mediaPayload(job.kmImage, 'km_image');
    }
    if (job.damagePhotosWithNotes.isNotEmpty) {
      payload['damagePhotosWithNotes'] = job.damagePhotosWithNotes;
    }

    payload.removeWhere(
      (key, value) =>
          value == null ||
          (value is String && value.trim().isEmpty) ||
          (value is List && value.isEmpty),
    );
    return payload;
  }

  List<Map<String, dynamic>> _tyreConditionDetailsPayload(Job job) {
    return job.tyreConditionDetails.whereType<Map>().map((item) {
      final detail = Map<String, dynamic>.from(item);
      final tyre = (detail['tyre'] ?? detail['position'] ?? 'general')
          .toString()
          .trim()
          .toLowerCase()
          .replaceAll(RegExp(r'[\s-]+'), '_');
      return {
        'tyre': tyre,
        'condition': detail['condition']?.toString() ?? job.tyreCondition ?? '',
      }..removeWhere((key, value) => value.toString().trim().isEmpty);
    }).toList();
  }

  String? _firstTyreDetail(Job job, String key) {
    for (final detail in job.tyreConditionDetails.whereType<Map>()) {
      final value = detail[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  List<Map<String, dynamic>> _mediaListPayload(
    List<dynamic> values,
    String prefix,
  ) {
    return values
        .map((value) => _mediaPayload(value, prefix))
        .where((value) => value != null)
        .cast<Map<String, dynamic>>()
        .toList();
  }

  Map<String, dynamic>? _mediaPayload(dynamic value, String prefix) {
    if (value == null) return null;
    if (value is Map) {
      final url =
          (value['url'] ??
                  value['secure_url'] ??
                  value['localPath'] ??
                  value['path'])
              ?.toString()
              .trim();
      if (url == null || url.isEmpty) return null;
      final publicId = (value['public_id'] ?? value['publicId'])
          ?.toString()
          .trim();
      final payload = <String, dynamic>{
        'url': url,
        'public_id': publicId == null || publicId.isEmpty
            ? _generatedPublicId(prefix)
            : publicId,
      };
      final type = value['type']?.toString().trim();
      if (type != null && type.isNotEmpty) payload['type'] = type;
      final marks = value['marks'];
      if (marks is List && marks.isNotEmpty) payload['marks'] = marks;
      return payload;
    }

    final url = value.toString().trim();
    if (url.isEmpty) return null;
    return {'url': url, 'public_id': _generatedPublicId(prefix)};
  }

  String _generatedPublicId(String prefix) {
    return '${prefix}_${DateTime.now().microsecondsSinceEpoch}';
  }

  Map<String, List<File>> _createJobMultipartFiles(
    Map<String, dynamic> requestData,
  ) {
    final jobCard = requestData['jobCard'];
    if (jobCard is! Map) return {};

    final files = <String, List<File>>{};
    final seenPaths = <String>{};

    void addFile(String field, File? file) {
      if (file == null || !seenPaths.add('$field:${file.path}')) return;
      files.putIfAbsent(field, () => <File>[]).add(file);
    }

    void collectFiles(String field, dynamic value) {
      if (value is Map) {
        addFile(field, _fileFromMediaValue(value));
        value.values.forEach((child) => collectFiles(field, child));
      } else if (value is List) {
        for (final child in value) {
          collectFiles(field, child);
        }
      }
    }

    collectFiles('vehiclePhotos', jobCard['vehiclePhotos']);
    collectFiles('kmImage', jobCard['kmImage']);

    return files;
  }

  File? _fileFromMediaValue(dynamic value) {
    String? path;
    if (value is Map) {
      path =
          (value['file'] ?? value['url'] ?? value['localPath'] ?? value['path'])
              ?.toString()
              .trim();
    } else if (value is String) {
      path = value.trim();
    }

    if (path == null || path.isEmpty || path.startsWith('http')) return null;
    final file = File(path);
    return file.existsSync() ? file : null;
  }

  void _replaceUploadedJobCardMediaPaths(
    Map<String, dynamic> requestData,
    Set<String> uploadedFields,
  ) {
    final jobCard = requestData['jobCard'];
    if (jobCard is! Map) return;

    for (final field in uploadedFields) {
      if (!jobCard.containsKey(field)) continue;
      _replaceLocalMediaPathsWithUploadNames(jobCard[field]);
    }
  }

  void _replaceLocalMediaPathsWithUploadNames(dynamic value) {
    if (value is List) {
      for (final item in value) {
        _replaceLocalMediaPathsWithUploadNames(item);
      }
      return;
    }

    if (value is! Map) return;

    for (final key in ['url', 'localPath', 'path']) {
      final path = value[key]?.toString().trim();
      if (path == null || !_isLocalExistingFilePath(path)) continue;
      value['url'] = _fileNameFromPath(path);
      value['public_id'] =
          (value['public_id'] ?? value['publicId'])
                  ?.toString()
                  .trim()
                  .isNotEmpty ==
              true
          ? (value['public_id'] ?? value['publicId']).toString().trim()
          : _generatedPublicId('upload');
      value.remove('localPath');
      value.remove('path');
      value.remove('publicId');
    }

    for (final child in value.values) {
      _replaceLocalMediaPathsWithUploadNames(child);
    }
  }

  bool _isLocalExistingFilePath(String path) {
    if (path.isEmpty || path.startsWith('http')) return false;
    return File(path).existsSync();
  }

  String _fileNameFromPath(String path) {
    return path.split(RegExp(r'[\\/]')).last;
  }

  String? _dateOnly(DateTime? date) {
    if (date == null) return null;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<Map<String, dynamic>> getSingleJob(String id) async {
    print('\n========== GET SINGLE JOB CARD START ==========');
    try {
      final endpoint = '/api/job/$id';
      print('Request URL: ${ApiConstants.baseUrl}$endpoint');
      final response = await _apiService.get(endpoint);
      print('Response: $response');
      print('========== GET SINGLE JOB CARD END ==========\n');
      return response is Map<String, dynamic> ? response : {'data': response};
    } catch (e) {
      print('ERROR in getSingleJob: $e');
      print('========== GET SINGLE JOB CARD FAILED ==========\n');
      throw Exception('Failed to fetch job card: $e');
    }
  }

  Future<Map<String, dynamic>> getInspectionChecklist(
    String vehicleType,
  ) async {
    print('\n========== GET INSPECTION CHECKLIST START ==========');
    try {
      final normalizedType = _inspectionVehicleTypeParam(vehicleType);
      final endpoint =
          '${ApiConstants.jobCardInspectionChecklist}/$normalizedType';
      print('Request URL: ${ApiConstants.baseUrl}$endpoint');
      final response = await _apiService.get(endpoint);
      print('Response: $response');
      print('========== GET INSPECTION CHECKLIST END ==========\n');
      return response is Map<String, dynamic> ? response : {'data': response};
    } catch (e) {
      print('ERROR in getInspectionChecklist: $e');
      print('========== GET INSPECTION CHECKLIST FAILED ==========\n');
      throw Exception('Failed to fetch inspection checklist: $e');
    }
  }

  Future<Map<String, dynamic>> saveInspectionResult({
    required String jobCardId,
    required String vehicleType,
    required List<Map<String, dynamic>> inspectionAnswers,
  }) async {
    print('\n========== SAVE INSPECTION RESULT START ==========');
    try {
      final normalizedType = _inspectionVehicleTypeParam(vehicleType);
      final endpoint = normalizedType.contains('two')
          ? ApiConstants.twoWheelerInspectionResult
          : ApiConstants.jobCardInspectionResult;
      final requestData = {
        'jobCardId': jobCardId,
        'vehicleType': normalizedType,
        'inspectionAnswers': inspectionAnswers,
      };
      print('Method: POST');
      print('URL: ${ApiConstants.baseUrl}$endpoint');
      print('Request Body:');
      print(const JsonEncoder.withIndent('  ').convert(requestData));
      final response = await _apiService.post(endpoint, requestData);
      print('Response Body:');
      print(const JsonEncoder.withIndent('  ').convert(response));
      print('========== SAVE INSPECTION RESULT END ==========\n');
      return response is Map<String, dynamic> ? response : {'data': response};
    } catch (e) {
      print('ERROR in saveInspectionResult: $e');
      print('========== SAVE INSPECTION RESULT FAILED ==========\n');
      throw Exception('Failed to save inspection result: $e');
    }
  }

  Future<Map<String, dynamic>> getInspectionResult({
    required String jobCardId,
    required String vehicleType,
  }) async {
    print('\n========== GET INSPECTION RESULT START ==========');
    try {
      final normalizedType = _inspectionVehicleTypeParam(vehicleType);
      final endpoint = normalizedType.contains('two')
          ? '${ApiConstants.twoWheelerInspectionResult}/$jobCardId'
          : normalizedType == 'car'
          ? '${ApiConstants.jobCardInspectionResult}/car/$jobCardId'
          : '${ApiConstants.jobCardInspectionResult}/$jobCardId';
      print('Request URL: ${ApiConstants.baseUrl}$endpoint');
      final response = await _apiService.get(endpoint);
      print('Response: $response');
      print('========== GET INSPECTION RESULT END ==========\n');
      return response is Map<String, dynamic> ? response : {'data': response};
    } catch (e) {
      print('ERROR in getInspectionResult: $e');
      print('========== GET INSPECTION RESULT FAILED ==========\n');
      throw Exception('Failed to fetch inspection result: $e');
    }
  }
}

String _inspectionVehicleTypeParam(String vehicleType) {
  final normalized = vehicleType.trim().toLowerCase().replaceAll(
    RegExp(r'[\s-]+'),
    '_',
  );

  switch (normalized) {
    case 'car':
    case 'four_wheeler':
      return 'four_wheeler';
    case 'bike':
    case 'motorcycle':
    case 'scooter':
    case 'two_wheeler':
      return 'two_wheeler';
    case 'auto':
    case 'rickshaw':
    case 'three_wheeler':
      return 'three_wheeler';
    case 'heavy_vehicle':
    case 'truck':
    case 'bus':
      return 'heavy_vehicle';
    default:
      return normalized;
  }
}

List<String> _extractVehicleTypes(dynamic response) {
  final values = <String>{};

  void visit(dynamic value) {
    if (value is Map) {
      final vehicleType = value['vehicleType'];
      if (vehicleType != null) {
        final normalized = vehicleType.toString().trim();
        if (normalized.isNotEmpty && normalized.toLowerCase() != 'null') {
          values.add(normalized);
        }
      }
      value.values.forEach(visit);
    } else if (value is List) {
      value.forEach(visit);
    }
  }

  visit(response);
  final sorted = values.toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return sorted;
}

int _toIntValue(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
