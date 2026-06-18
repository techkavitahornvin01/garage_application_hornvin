// // lib/controllers/job_controller.dart
// import 'package:flutter/material.dart';
// import '../models/job_model/job_model.dart';
// import '../repositories/job_repository.dart';

// class JobController extends ChangeNotifier {
//   final JobRepository _repository = JobRepository();

//   List<Job> _jobs = [];
//   bool _isLoading = false;
//   String? _errorMessage;
//   int _currentPage = 1;
//   int _totalPages = 1;
//   int _totalJobs = 0;
//   List<Job> _jobHistory = [];
//   String? _historyErrorMessage;
//   bool _isHistoryLoading = false;

//   // List<Job> get jobs => _jobs;
//   // bool get isLoading => _isLoading;
//   // String? get errorMessage => _errorMessage;
//   // int get currentPage => _currentPage;
//   // int get totalPages => _totalPages;
//   // int get totalJobs => _totalJobs;
//    List<Job> get jobs => _jobs;
//   List<Job> get jobHistory => _jobHistory;
//   bool get isLoading => _isLoading;
//   bool get isHistoryLoading => _isHistoryLoading;
//   String? get errorMessage => _errorMessage;
//   String? get historyErrorMessage => _historyErrorMessage;
//   int get currentPage => _currentPage;
//   int get totalPages => _totalPages;
//   int get totalJobs => _totalJobs;

//   // Fetch all jobs
//   Future<void> fetchJobs({int page = 1}) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();

//     try {
//       print('🎮 Controller: Fetching jobs - Page $page');
//       final response = await _repository.getAllJobs(page: page, limit: 10);

//       _jobs = response.jobs;
//       _currentPage = response.page;
//       _totalPages = response.totalPages;
//       _totalJobs = response.total;

//       print('✅ SUCCESS: ${_jobs.length} jobs loaded in controller');
//     } catch (e) {
//       _errorMessage = e.toString();
//       print('❌ Controller Error: $e');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//    // Fetch job history by vehicle number
//   Future<void> fetchJobHistory(String vehicleNumber) async {
//     _isHistoryLoading = true;
//     _historyErrorMessage = null;
//     notifyListeners();

//     try {
//       print('🎮 Controller: Fetching job history for vehicle: $vehicleNumber');
//       final response = await _repository.getJobHistory(vehicleNumber);

//       _jobHistory = response.data;

//       print('✅ SUCCESS: ${_jobHistory.length} history jobs loaded in controller');
//     } catch (e) {
//       _historyErrorMessage = e.toString();
//       print('❌ Controller Error in history: $e');
//     } finally {
//       _isHistoryLoading = false;
//       notifyListeners();
//     }
//   }

//   // Create new job
//   Future<bool> createJob(Job job) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       print('🎮 Controller: Creating job for ${job.customerName}');
//       final result = await _repository.createJob(job);

//       if (result['success']) {
//         print('✅ SUCCESS: Job created successfully!');
//         await fetchJobs();
//         return true;
//       } else {
//         print('❌ ERROR: ${result['message']}');
//         return false;
//       }
//     } catch (e) {
//       print('❌ Controller Error: $e');
//       return false;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Update job
//   Future<bool> updateJob(String id, Job job) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       print('🎮 Controller: Updating job $id');
//       final result = await _repository.updateJob(id, job);

//       if (result['success']) {
//         print('✅ SUCCESS: Job updated successfully!');
//         await fetchJobs();
//         return true;
//       } else {
//         print('❌ ERROR: ${result['message']}');
//         return false;
//       }
//     } catch (e) {
//       print('❌ Controller Error: $e');
//       return false;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Delete job
//   Future<bool> deleteJob(String id) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       print('🎮 Controller: Deleting job $id');
//       final result = await _repository.deleteJob(id);

//       if (result['success']) {
//         print('✅ SUCCESS: Job deleted successfully!');
//         await fetchJobs();
//         return true;
//       } else {
//         print('❌ ERROR: ${result['message']}');
//         return false;
//       }
//     } catch (e) {
//       print('❌ Controller Error: $e');
//       return false;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }

// lib/controllers/job_controller.dart

import 'package:flutter/material.dart';
import '../models/job_model/job_model.dart';
import '../repositories/job_repository.dart';
import '../utils/friendly_error.dart';

class JobController extends ChangeNotifier {
  final JobRepository _repository = JobRepository();

  List<Job> _jobs = [];
  List<Job> _jobHistory = [];
  bool _isLoading = false;
  bool _isHistoryLoading = false;
  String? _errorMessage;
  String? _historyErrorMessage;
  String? _vehicleTypesErrorMessage;
  Map<String, dynamic>? _lastCreatedJobResponse;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalJobs = 0;
  List<String> _vehicleTypes = const [
    'All Vehicles',
    'Two Wheeler',
    'Three Wheeler',
    'Four Wheeler',
  ];
  bool _isVehicleTypesLoading = false;
  bool _hasLoadedVehicleTypes = false;
  String _selectedVehicleType = 'All Vehicles';

  List<Job> get jobs => _jobs;
  List<Job> get jobHistory => _jobHistory;
  bool get isLoading => _isLoading;
  bool get isHistoryLoading => _isHistoryLoading;
  String? get errorMessage => _errorMessage;
  String? get historyErrorMessage => _historyErrorMessage;
  String? get vehicleTypesErrorMessage => _vehicleTypesErrorMessage;
  Map<String, dynamic>? get lastCreatedJobResponse => _lastCreatedJobResponse;
  String? get lastCreatedJobCardId =>
      _extractJobCardId(_lastCreatedJobResponse);
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalJobs => _totalJobs;
  List<String> get vehicleTypes => _vehicleTypes;
  bool get isVehicleTypesLoading => _isVehicleTypesLoading;
  String get selectedVehicleType => _selectedVehicleType;

  // Fetch all jobs
  Future<void> fetchJobs({int page = 1, String? vehicleType}) async {
    final normalizedVehicleType = _normalizeFilterValue(
      vehicleType ?? _selectedVehicleType,
    );
    _selectedVehicleType = normalizedVehicleType ?? 'All Vehicles';
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('🎮 Controller: Fetching jobs - Page $page');
      final response = await _repository.getAllJobs(
        page: page,
        limit: 30,
        vehicleType: _vehicleTypeQueryValue(normalizedVehicleType),
      );

      final filteredJobs = _applyVehicleTypeFallbackFilter(
        response.jobs,
        normalizedVehicleType,
      );
      _jobs = page > 1 ? [..._jobs, ...filteredJobs] : filteredJobs;
      _currentPage = response.page;
      _totalPages = response.totalPages;
      final serverReturnedOnlySelected =
          normalizedVehicleType == null ||
          filteredJobs.length == response.jobs.length;
      _totalJobs = serverReturnedOnlySelected ? response.total : _jobs.length;

      print('✅ SUCCESS: ${_jobs.length} jobs loaded in controller');
    } catch (e) {
      _errorMessage = friendlyErrorMessage(
        e,
        fallback: 'Jobs could not be loaded right now. Please try again.',
      );
      print('❌ Controller Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchVehicleTypes({bool force = false}) async {
    if (_hasLoadedVehicleTypes && !force) return;

    _isVehicleTypesLoading = true;
    _vehicleTypesErrorMessage = null;
    notifyListeners();

    try {
      final apiTypes = await _repository.getVehicleTypes();
      _vehicleTypes = _mergeVehicleTypes(apiTypes);
      _hasLoadedVehicleTypes = true;
    } catch (e) {
      _vehicleTypesErrorMessage = friendlyErrorMessage(
        e,
        fallback: 'Vehicle types could not be loaded right now.',
      );
      _vehicleTypes = _mergeVehicleTypes(const []);
    } finally {
      _isVehicleTypesLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectVehicleType(String? vehicleType) {
    return fetchJobs(page: 1, vehicleType: vehicleType ?? 'All Vehicles');
  }

  // Fetch job history by vehicle number
  Future<void> fetchJobHistory(String vehicleNumber) async {
    _isHistoryLoading = true;
    _historyErrorMessage = null;
    notifyListeners();

    try {
      print('🎮 Controller: Fetching job history for vehicle: $vehicleNumber');
      final response = await _repository.getJobHistory(vehicleNumber);

      _jobHistory = response.data;

      print(
        '✅ SUCCESS: ${_jobHistory.length} history jobs loaded in controller',
      );
    } catch (e) {
      _historyErrorMessage = friendlyErrorMessage(
        e,
        fallback: 'Job history could not be loaded right now. Please try again.',
      );
      print('❌ Controller Error in history: $e');
    } finally {
      _isHistoryLoading = false;
      notifyListeners();
    }
  }

  // Create new job
  Future<bool> createJob(
    Job job, {
    Map<String, dynamic>? inspectionChecklist,
    List<Map<String, dynamic>> inspectionAnswers = const [],
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _lastCreatedJobResponse = null;
    notifyListeners();

    try {
      print('🎮 Controller: Creating job for ${job.customerName}');
      final result = await _repository.createJob(
        job,
        inspectionChecklist: inspectionChecklist,
        inspectionAnswers: inspectionAnswers,
      );

      if (result['success']) {
        _lastCreatedJobResponse = Map<String, dynamic>.from(result);
        print('✅ SUCCESS: Job created successfully!');
        await fetchJobs();
        return true;
      } else {
        _errorMessage = friendlyErrorMessage(
          result['message'],
          fallback: 'Job could not be created. Please review the details and try again.',
        );
        print('❌ ERROR: ${result['message']}');
        return false;
      }
    } catch (e) {
      print('❌ Controller Error: $e');
      _errorMessage = friendlyErrorMessage(
        e,
        fallback: 'Job could not be created. Please review the details and try again.',
      );
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  static String? _extractJobCardId(Map<String, dynamic>? response) {
    if (response == null) return null;

    final candidates = <dynamic>[
      response['jobCardId'],
      response['id'],
      response['_id'],
    ];

    void addFromMap(Map map) {
      candidates.addAll([map['jobCardId'], map['id'], map['_id']]);
    }

    final data = response['data'];
    if (data is Map) {
      addFromMap(data);
      final nestedData = data['data'];
      if (nestedData is Map) addFromMap(nestedData);
      final job = data['job'] ?? data['jobCard'] ?? data['createdJob'];
      if (job is Map) addFromMap(job);
    }

    for (final candidate in candidates) {
      final value = candidate?.toString().trim() ?? '';
      if (value.isNotEmpty && value.toLowerCase() != 'null') return value;
    }

    return null;
  }

  // Update job
  Future<bool> updateJob(String id, Job job) async {
    _isLoading = true;
    notifyListeners();

    try {
      print('🎮 Controller: Updating job $id');
      final result = await _repository.updateJob(id, job);

      if (result['success']) {
        print('✅ SUCCESS: Job updated successfully!');
        await fetchJobs();
        return true;
      } else {
        _errorMessage = friendlyErrorMessage(
          result['message'],
          fallback: 'Job could not be updated. Please review the details and try again.',
        );
        print('❌ ERROR: ${result['message']}');
        return false;
      }
    } catch (e) {
      print('❌ Controller Error: $e');
      _errorMessage = friendlyErrorMessage(
        e,
        fallback: 'Job could not be updated. Please review the details and try again.',
      );
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete job
  Future<bool> deleteJob(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      print('🎮 Controller: Deleting job $id');
      final result = await _repository.deleteJob(id);

      if (result['success']) {
        print('✅ SUCCESS: Job deleted successfully!');
        await fetchJobs();
        return true;
      } else {
        _errorMessage = friendlyErrorMessage(
          result['message'],
          fallback: 'Job could not be deleted right now. Please try again.',
        );
        print('❌ ERROR: ${result['message']}');
        return false;
      }
    } catch (e) {
      print('❌ Controller Error: $e');
      _errorMessage = friendlyErrorMessage(
        e,
        fallback: 'Job could not be deleted right now. Please try again.',
      );
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear job history
  void clearJobHistory() {
    _jobHistory = [];
    _historyErrorMessage = null;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getSingleJob(String id) async {
    try {
      return await _repository.getSingleJob(id);
    } catch (e) {
      _errorMessage = friendlyErrorMessage(
        e,
        fallback: 'Job details could not be loaded right now. Please try again.',
      );
      notifyListeners();
      return null;
    }
  }

  Future<Map<String, dynamic>?> getAllGarageVehicleServiceHistory() async {
    try {
      return await _repository.getAllGarageVehicleServiceHistory();
    } catch (e) {
      _historyErrorMessage = friendlyErrorMessage(
        e,
        fallback: 'Vehicle service history could not be loaded right now.',
      );
      notifyListeners();
      return null;
    }
  }

  Future<Map<String, dynamic>?> getGarageHistory({
    String? employeeId,
    String? mechanicName,
    String? vehicleNumber,
    String? status,
    String? dateFrom,
    String? dateTo,
  }) async {
    try {
      return await _repository.getGarageHistory(
        employeeId: employeeId,
        mechanicName: mechanicName,
        vehicleNumber: vehicleNumber,
        status: status,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
    } catch (e) {
      _historyErrorMessage = friendlyErrorMessage(
        e,
        fallback: 'Garage history could not be loaded right now.',
      );
      notifyListeners();
      return null;
    }
  }

  Future<Map<String, dynamic>?> searchVehicleHistory({
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
    try {
      return await _repository.getVehicleHistorySearch(
        vehicleNumber: vehicleNumber,
        registrationNumber: registrationNumber,
        phoneNumber: phoneNumber,
        customerName: customerName,
        status: status,
        mechanicName: mechanicName,
        vehicleType: vehicleType,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
    } catch (e) {
      _historyErrorMessage = friendlyErrorMessage(
        e,
        fallback: 'Vehicle history could not be loaded right now.',
      );
      notifyListeners();
      return null;
    }
  }

  Future<Map<String, dynamic>?> getInspectionChecklist(
    String vehicleType,
  ) async {
    try {
      return await _repository.getInspectionChecklist(vehicleType);
    } catch (e) {
      _errorMessage = friendlyErrorMessage(
        e,
        fallback: 'Inspection checklist could not be loaded right now.',
      );
      notifyListeners();
      return null;
    }
  }

  Future<bool> saveInspectionResult({
    required String jobCardId,
    required String vehicleType,
    required List<Map<String, dynamic>> inspectionAnswers,
  }) async {
    try {
      final response = await _repository.saveInspectionResult(
        jobCardId: jobCardId,
        vehicleType: vehicleType,
        inspectionAnswers: inspectionAnswers,
      );
      return response['success'] != false;
    } catch (e) {
      _errorMessage = friendlyErrorMessage(
        e,
        fallback: 'Inspection result could not be saved right now.',
      );
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>?> getInspectionResult({
    required String jobCardId,
    required String vehicleType,
  }) async {
    try {
      return await _repository.getInspectionResult(
        jobCardId: jobCardId,
        vehicleType: vehicleType,
      );
    } catch (e) {
      _errorMessage = friendlyErrorMessage(
        e,
        fallback: 'Inspection result could not be loaded right now.',
      );
      notifyListeners();
      return null;
    }
  }

  List<String> _mergeVehicleTypes(List<String> apiTypes) {
    final values = <String>[
      'All Vehicles',
      'Two Wheeler',
      'Three Wheeler',
      'Four Wheeler',
      ...apiTypes,
    ];
    final seen = <String>{};
    return values.where((type) {
      final normalized = type.trim();
      if (normalized.isEmpty || normalized.toLowerCase() == 'null') {
        return false;
      }
      final key = normalized.toLowerCase().replaceAll(RegExp(r'[\s_-]+'), ' ');
      if (seen.contains(key)) return false;
      seen.add(key);
      return true;
    }).toList();
  }

  String? _normalizeFilterValue(String? value) {
    final normalized = value?.trim();
    if (normalized == null ||
        normalized.isEmpty ||
        normalized.toLowerCase() == 'all vehicles') {
      return null;
    }
    return normalized;
  }

  String? _vehicleTypeQueryValue(String? value) {
    if (value == null) return null;
    switch (_vehicleTypeKey(value)) {
      case 'four wheeler':
        return 'Car';
      case 'two wheeler':
        return 'Bike';
      case 'three wheeler':
        return 'Three Wheeler';
      default:
        return value;
    }
  }

  List<Job> _applyVehicleTypeFallbackFilter(
    List<Job> jobs,
    String? vehicleType,
  ) {
    if (vehicleType == null) return jobs;
    return jobs
        .where((job) => _vehicleTypesMatch(job.vehicleType, vehicleType))
        .toList();
  }

  bool _vehicleTypesMatch(String jobVehicleType, String selectedVehicleType) {
    final jobKey = _vehicleTypeKey(jobVehicleType);
    final selectedKey = _vehicleTypeKey(selectedVehicleType);
    if (jobKey.isEmpty) return false;
    if (jobKey == selectedKey) return true;

    const equivalentTypes = {
      'two wheeler': {'two wheeler', 'bike', 'motorcycle', 'scooter'},
      'three wheeler': {'three wheeler', 'auto', 'rickshaw'},
      'four wheeler': {'four wheeler', 'car', 'suv', 'jeep'},
    };

    final selectedGroup = equivalentTypes[selectedKey];
    if (selectedGroup != null && selectedGroup.contains(jobKey)) return true;

    return equivalentTypes.values.any(
      (group) => group.contains(selectedKey) && group.contains(jobKey),
    );
  }

  String _vehicleTypeKey(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
