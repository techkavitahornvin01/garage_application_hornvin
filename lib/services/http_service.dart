import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class HttpService {
  static const int timeoutDuration = 30;

  // Headers
  static Map<String, String> getBaseHeaders() {
    return {'Content-Type': 'application/json', 'Accept': 'application/json'};
  }

  // POST request
  static Future<Map<String, dynamic>> post({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? customHeaders,
  }) async {
    try {
      final headers = customHeaders ?? getBaseHeaders();

      if (kDebugMode) {
        print('🌐 POST Request: $url');
        print('📦 Request Body: ${json.encode(body)}');
        print('📋 Headers: $headers');
      }

      final response = await http
          .post(Uri.parse(url), headers: headers, body: json.encode(body))
          .timeout(
            Duration(seconds: timeoutDuration),
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );

      if (kDebugMode) {
        print('✅ Response Status: ${response.statusCode}');
        print('📦 Response Body: ${response.body}');
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      return {
        'statusCode': response.statusCode,
        'data': responseData,
        'success': response.statusCode >= 200 && response.statusCode < 300,
      };
    } on http.ClientException catch (e) {
      if (kDebugMode) {
        print('❌ Network Error: $e');
      }
      return {
        'success': false,
        'statusCode': 0,
        'message': 'Network error: ${e.message}',
      };
    } catch (e) {
      if (kDebugMode) {
        print('❌ Unexpected Error: $e');
      }
      return {
        'success': false,
        'statusCode': 500,
        'message': 'An unexpected error occurred: $e',
      };
    }
  }

  // GET request
  static Future<Map<String, dynamic>> get({
    required String url,
    Map<String, String>? customHeaders,
  }) async {
    try {
      final headers = customHeaders ?? getBaseHeaders();

      if (kDebugMode) {
        print('🌐 GET Request: $url');
        print('📋 Headers: $headers');
      }

      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(
            Duration(seconds: timeoutDuration),
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection.',
              );
            },
          );

      if (kDebugMode) {
        print('✅ Response Status: ${response.statusCode}');
        print('📦 Response Body: ${response.body}');
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      return {
        'statusCode': response.statusCode,
        'data': responseData,
        'success': response.statusCode >= 200 && response.statusCode < 300,
      };
    } on http.ClientException catch (e) {
      if (kDebugMode) {
        print('❌ Network Error: $e');
      }
      return {
        'success': false,
        'statusCode': 0,
        'message': 'Network error: ${e.message}',
      };
    } catch (e) {
      if (kDebugMode) {
        print('❌ Unexpected Error: $e');
      }
      return {
        'success': false,
        'statusCode': 500,
        'message': 'An unexpected error occurred: $e',
      };
    }
  }
}
