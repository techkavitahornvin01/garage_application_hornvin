// // // import 'dart:convert';
// // // import 'package:http/http.dart' as http;
// // // import '../utils/constants.dart';

// // // class ApiService {
// // //   Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
// // //     try {
// // //       final response = await http.post(
// // //         Uri.parse('${ApiConstants.baseUrl}$endpoint'),
// // //         headers: {
// // //           ApiConstants.contentType: ApiConstants.applicationJson,
// // //         },
// // //         body: jsonEncode(body),
// // //       );

// // //       final Map<String, dynamic> responseData = jsonDecode(response.body);

// // //       if (response.statusCode == 200 || response.statusCode == 201) {
// // //         return {
// // //           'success': true,
// // //           'message': responseData['message'] ?? 'Success',
// // //           'data': responseData['data'],
// // //           'statusCode': response.statusCode,
// // //         };
// // //       } else {
// // //         return {
// // //           'success': false,
// // //           'message': responseData['message'] ?? 'Request failed',
// // //           'statusCode': response.statusCode,
// // //         };
// // //       }
// // //     } catch (e) {
// // //       return {
// // //         'success': false,
// // //         'message': 'Network error: ${e.toString()}',
// // //       };
// // //     }
// // //   }
// // // }
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import '../utils/constants.dart';

// // class ApiService {
// //   // Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
// //   //   try {
// //   //     final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');

// //   //     // Debug: Print request details
// //   //     print('========== API REQUEST ==========');
// //   //     print('URL: $url');
// //   //     print('Method: POST');
// //   //     print('Headers: {${ApiConstants.contentType}: ${ApiConstants.applicationJson}}');
// //   //     print('Request Body: ${jsonEncode(body)}');
// //   //     print('==================================');

// //   //     final response = await http.post(
// //   //       url,
// //   //       headers: {
// //   //         ApiConstants.contentType: ApiConstants.applicationJson,
// //   //       },
// //   //       body: jsonEncode(body),
// //   //     );

// //   //     // Debug: Print response details
// //   //     print('========== API RESPONSE ==========');
// //   //     print('Status Code: ${response.statusCode}');
// //   //     print('Response Body: ${response.body}');
// //   //     print('==================================');

// //   //     final Map<String, dynamic> responseData = jsonDecode(response.body);

// //   //     if (response.statusCode == 200 || response.statusCode == 201) {
// //   //       print('✅ API Success: ${responseData['message']}');
// //   //       return {
// //   //         'success': true,
// //   //         'message': responseData['message'] ?? 'Success',
// //   //         'data': responseData['data'],
// //   //         'statusCode': response.statusCode,
// //   //       };
// //   //     } else {
// //   //       print('❌ API Failed: ${responseData['message']}');
// //   //       return {
// //   //         'success': false,
// //   //         'message': responseData['message'] ?? 'Request failed',
// //   //         'statusCode': response.statusCode,
// //   //       };
// //   //     }
// //   //   } catch (e) {
// //   //     print('❌ API Error: $e');
// //   //     return {
// //   //       'success': false,
// //   //       'message': 'Network error: ${e.toString()}',
// //   //     };
// //   //   }
// //   // }

// //    static final ApiService _instance = ApiService._internal();
// //   factory ApiService() => _instance;
// //   ApiService._internal();

// //   String? _authToken;

// //   void setAuthToken(String token) {
// //     _authToken = token;
// //   }

// //   Map<String, String> _getHeaders() {
// //     final headers = {
// //       ApiConstants.contentType: ApiConstants.applicationJson,
// //     };

// //     if (_authToken != null) {
// //       headers['Authorization'] = 'Bearer $_authToken';
// //     }

// //     return headers;
// //   }

// //   Future<Map<String, dynamic>> get(String endpoint) async {
// //     final response = await http.get(
// //       Uri.parse('${ApiConstants.baseUrl}$endpoint'),
// //       headers: _getHeaders(),
// //     );
// //     return _handleResponse(response);
// //   }

// //   Future<Map<String, dynamic>> post(String endpoint, dynamic data) async {
// //     final response = await http.post(
// //       Uri.parse('${ApiConstants.baseUrl}$endpoint'),
// //       headers: _getHeaders(),
// //       body: json.encode(data),
// //     );
// //     return _handleResponse(response);
// //   }

// //   Future<Map<String, dynamic>> put(String endpoint, dynamic data) async {
// //     final response = await http.put(
// //       Uri.parse('${ApiConstants.baseUrl}$endpoint'),
// //       headers: _getHeaders(),
// //       body: json.encode(data),
// //     );
// //     return _handleResponse(response);
// //   }

// //   Future<Map<String, dynamic>> delete(String endpoint) async {
// //     final response = await http.delete(
// //       Uri.parse('${ApiConstants.baseUrl}$endpoint'),
// //       headers: _getHeaders(),
// //     );
// //     return _handleResponse(response);
// //   }

// //   Map<String, dynamic> _handleResponse(http.Response response) {
// //     if (response.statusCode >= 200 && response.statusCode < 300) {
// //       return json.decode(response.body);
// //     } else {
// //       throw Exception('Failed: ${response.statusCode} - ${response.body}');
// //     }
// //   }
// // }

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:hornvin/services/storage_service.dart';
// import '../utils/constants.dart';

// class ApiService {
//   static const String baseUrl = ApiConstants.baseUrl;

//   // Get token from storage
//   Future<String?> _getToken() async {
//     return await StorageService.getToken();
//   }

//   // Get headers with token
//   Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
//     final headers = {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//     };

//     if (requiresAuth) {
//       final token = await _getToken();
//       if (token != null && token.isNotEmpty) {
//         headers['Authorization'] = 'Bearer $token';
//         print('🔑 Token added to headers: Bearer ${token.substring(0, token.length > 20 ? 20 : token.length)}...');
//       } else {
//         print('⚠️ No token available for authenticated request');
//       }
//     }

//     return headers;
//   }

//   // GET Request
//   Future<dynamic> get(String endpoint, {bool requiresAuth = true}) async {
//     final url = Uri.parse('$baseUrl$endpoint');
//     print('🌐 GET Request: $url');

//     final headers = await _getHeaders(requiresAuth: requiresAuth);

//     try {
//       final response = await http.get(url, headers: headers);
//       return _handleResponse(response);
//     } catch (e) {
//       print('❌ GET Request Failed: $e');
//       throw Exception('Network error: $e');
//     }
//   }

//   // POST Request
//   Future<dynamic> post(String endpoint, dynamic data, {bool requiresAuth = true}) async {
//     final url = Uri.parse('$baseUrl$endpoint');
//     print('🌐 POST Request: $url');
//     print('📦 Request Body: $data');

//     final headers = await _getHeaders(requiresAuth: requiresAuth);

//     try {
//       final response = await http.post(
//         url,
//         headers: headers,
//         body: jsonEncode(data),
//       );
//       return _handleResponse(response);
//     } catch (e) {
//       print('❌ POST Request Failed: $e');
//       throw Exception('Network error: $e');
//     }
//   }

//   // PUT Request
//   Future<dynamic> put(String endpoint, dynamic data, {bool requiresAuth = true}) async {
//     final url = Uri.parse('$baseUrl$endpoint');
//     print('🌐 PUT Request: $url');

//     final headers = await _getHeaders(requiresAuth: requiresAuth);

//     try {
//       final response = await http.put(
//         url,
//         headers: headers,
//         body: jsonEncode(data),
//       );
//       return _handleResponse(response);
//     } catch (e) {
//       print('❌ PUT Request Failed: $e');
//       throw Exception('Network error: $e');
//     }
//   }

//   // DELETE Request
//   Future<dynamic> delete(String endpoint, {bool requiresAuth = true}) async {
//     final url = Uri.parse('$baseUrl$endpoint');
//     print('🌐 DELETE Request: $url');

//     final headers = await _getHeaders(requiresAuth: requiresAuth);

//     try {
//       final response = await http.delete(url, headers: headers);
//       return _handleResponse(response);
//     } catch (e) {
//       print('❌ DELETE Request Failed: $e');
//       throw Exception('Network error: $e');
//     }
//   }

//   // Response Handler
//   dynamic _handleResponse(http.Response response) {
//     print('📥 Response Status: ${response.statusCode}');
//     print('📥 Response Body: ${response.body}');

//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       if (response.body.isEmpty) {
//         return {'success': true};
//       }
//       try {
//         return jsonDecode(response.body);
//       } catch (e) {
//         print('⚠️ Response is not JSON: ${response.body}');
//         return {'success': true, 'data': response.body};
//       }
//     } else if (response.statusCode == 401) {
//       print('🔐 Unauthorized! Token may be expired or invalid');
//       throw Exception('Unauthorized: Please login again');
//     } else {
//       throw Exception('Failed: ${response.statusCode} - ${response.body}');
//     }
//   }
// }

// lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:hornvin/services/storage_service.dart';
import 'package:mime/mime.dart';
import '../utils/constants.dart';

class ApiService {
  static const String baseUrl = ApiConstants.baseUrl;

  // Get token from storage
  Future<String?> _getToken() async {
    return await StorageService.getToken();
  }

  // Get headers with token
  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    final languageCode = await StorageService.getLanguageCode() ?? 'en';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Language': languageCode,
      'X-Language': languageCode,
    };

    if (requiresAuth) {
      final token = await _getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
        print('🔑 Token added to headers');
      } else {
        print('⚠️ No token available for authenticated request');
      }
    }

    return headers;
  }

  // GET Request
  Future<dynamic> get(String endpoint, {bool requiresAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('🌐 GET Request: $url');

    final headers = await _getHeaders(requiresAuth: requiresAuth);

    try {
      final response = await http.get(url, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      print('❌ GET Request Failed: $e');
      throw Exception('Network error: $e');
    }
  }

  // POST Request
  Future<dynamic> post(
    String endpoint,
    dynamic data, {
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('🌐 POST Request: $url');
    print('📦 Request Body: $data');

    final headers = await _getHeaders(requiresAuth: requiresAuth);

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      print('❌ POST Request Failed: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<dynamic> postMultipart(
    String endpoint, {
    required Map<String, String> fields,
    required Map<String, List<File>> files,
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('POST Multipart Request: $url');
    print('Multipart JSON Fields:');
    for (final entry in fields.entries) {
      print('${entry.key}: ${entry.value}');
    }
    print(
      'Multipart Files: ${files.map((key, value) => MapEntry(key, value.map((file) => file.path).toList()))}',
    );

    final headers = await _getHeaders(requiresAuth: requiresAuth);
    headers.remove('Content-Type');

    try {
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);
      request.fields.addAll(fields);

      for (final entry in files.entries) {
        for (final file in entry.value) {
          if (!await file.exists()) continue;
          request.files.add(
            await http.MultipartFile.fromPath(
              entry.key,
              file.path,
              contentType: await _contentTypeForFile(file),
            ),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } catch (e) {
      print('POST Multipart Request Failed: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<MediaType> _contentTypeForFile(File file) async {
    final headerBytes = await file
        .openRead(0, 16)
        .fold<List<int>>(<int>[], (previous, chunk) => previous..addAll(chunk));
    final mimeType =
        lookupMimeType(file.path, headerBytes: headerBytes) ??
        _fallbackMimeType(file.path) ??
        'image/jpeg';
    final parts = mimeType.split('/');
    print('Multipart File Content-Type: ${file.path} => $mimeType');
    return MediaType(parts.first, parts.length > 1 ? parts[1] : 'jpeg');
  }

  String? _fallbackMimeType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    if (lower.endsWith('.heic')) return 'image/heic';
    if (lower.endsWith('.heif')) return 'image/heif';
    if (lower.endsWith('.mp4')) return 'video/mp4';
    if (lower.endsWith('.mov')) return 'video/quicktime';
    if (lower.endsWith('.avi')) return 'video/x-msvideo';
    if (lower.endsWith('.mkv')) return 'video/x-matroska';
    return null;
  }

  // PUT Request
  Future<dynamic> put(
    String endpoint,
    dynamic data, {
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('🌐 PUT Request: $url');

    final headers = await _getHeaders(requiresAuth: requiresAuth);

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      print('❌ PUT Request Failed: $e');
      throw Exception('Network error: $e');
    }
  }

  // PATCH Request
  Future<dynamic> patch(
    String endpoint,
    dynamic data, {
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('PATCH Request: $url');
    print('Request Body: $data');

    final headers = await _getHeaders(requiresAuth: requiresAuth);

    try {
      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      print('PATCH Request Failed: $e');
      throw Exception('Network error: $e');
    }
  }

  // DELETE Request
  Future<dynamic> delete(String endpoint, {bool requiresAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print('🌐 DELETE Request: $url');

    final headers = await _getHeaders(requiresAuth: requiresAuth);

    try {
      final response = await http.delete(url, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      print('❌ DELETE Request Failed: $e');
      throw Exception('Network error: $e');
    }
  }

  // Response Handler
  dynamic _handleResponse(http.Response response) {
    print('📥 Response Status: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      try {
        return jsonDecode(response.body);
      } catch (e) {
        print('⚠️ Response is not JSON: ${response.body}');
        return {'success': true, 'data': response.body};
      }
    } else if (response.statusCode == 401) {
      print('🔐 Unauthorized! Token may be expired or invalid');
      if (response.body.isNotEmpty) {
        throw Exception('Failed: ${response.statusCode} - ${response.body}');
      }
      throw Exception('Unauthorized: Please login again');
    } else {
      throw Exception('Failed: ${response.statusCode} - ${response.body}');
    }
  }
}
