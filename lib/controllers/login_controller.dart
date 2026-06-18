import 'dart:convert';

import '../repositories/auth_repository.dart';
import '../services/storage_service.dart';

class LoginController {
  static final AuthRepository _authRepository = AuthRepository();

  // Login with email or phone (using same endpoint)
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    print('========== LOGIN CONTROLLER ==========');
    print('email: $email');
    print('Password: $password');

    try {
      final response = await _authRepository.login(email, password);

      print('Response: $response');
      print('========================================');

      return response;
    } catch (error) {
      final parsedError = _parseLoginException(error);
      print('Login API error: $parsedError');
      print('========================================');
      return parsedError;
    }
  }

  // Format phone number for API
  static String formatPhoneNumber(String phoneNumber) {
    String cleaned = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length == 10) {
      cleaned = '+91$cleaned';
    }
    return cleaned;
  }

  // Save user data after successful login
  static Future<void> saveUserSession(Map<String, dynamic> response) async {
    if (requiresAdminApproval(response)) {
      await StorageService.logout();
      return;
    }

    final data = response['data'];
    final dataMap = data is Map ? data : const {};
    final user = dataMap['user'] ?? response['user'] ?? dataMap['garage'];
    final token = _firstText([
      dataMap['token'],
      dataMap['accessToken'],
      dataMap['access_token'],
      response['token'],
      response['accessToken'],
      response['access_token'],
    ]);

    if (token.isNotEmpty) {
      await StorageService.saveToken(token);
      await StorageService.setLoggedIn(true);
    }

    if (user is Map) {
      await StorageService.saveUserData(Map<String, dynamic>.from(user));
    } else if (dataMap.isNotEmpty) {
      await StorageService.saveUserData(Map<String, dynamic>.from(dataMap));
    }

    final savedToken = await StorageService.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print('Login response did not include token. Response: $response');
    } else {
      print('User session saved successfully');
    }

    if (response['data'] is Map &&
        token.isEmpty &&
        response['data']['token'] != null) {
      // Save token
      if (response['data']['token'] != null) {
        await StorageService.saveToken(response['data']['token']);
      }

      // Save user data
      if (response['data']['user'] != null) {
        await StorageService.saveUserData(response['data']['user']);
      }

      await StorageService.setLoggedIn(true);
      print('✅ User session saved successfully');
    }
  }

  static bool requiresAdminApproval(Map<String, dynamic> response) {
    final message = (response['message'] ?? '').toString().toLowerCase();
    final data = response['data'];
    final dataMap = data is Map ? data : const {};
    final user = dataMap['user'];
    final userMap = user is Map ? user : const {};
    final approvalStatus =
        (userMap['approvalStatus'] ??
                userMap['approval_status'] ??
                dataMap['approvalStatus'] ??
                dataMap['approval_status'] ??
                '')
            .toString()
            .toLowerCase();
    final isActive = userMap['isActive'] ?? dataMap['isActive'];

    return message.contains('admin approval') ||
        message.contains('please wait for admin') ||
        message.contains('pending approval') ||
        approvalStatus.contains('pending') ||
        isActive == false;
  }

  static Future<void> logout() async {
    try {
      await _authRepository.logout();
    } catch (e) {
      print('Logout API failed, clearing local session anyway: $e');
    } finally {
      await StorageService.logout();
    }
  }

  // Handle different error messages
  static String getErrorMessage(Map<String, dynamic> response) {
    final message = (response['message'] ?? 'Login failed').toString().trim();
    return message.isEmpty ? 'Login failed' : message;
  }

  static String getExceptionMessage(Object error) {
    return _parseLoginException(error)['message']?.toString() ?? 'Login failed';
  }

  static Map<String, dynamic> _parseLoginException(Object error) {
    final raw = error.toString();
    final statusCode = _extractStatusCode(raw);
    final apiMessage = _extractApiMessage(raw);

    return {
      'success': false,
      'message': apiMessage.isEmpty ? _cleanExceptionText(raw) : apiMessage,
      'statusCode': statusCode,
    };
  }

  static int? _extractStatusCode(String raw) {
    final match = RegExp(r'Failed:\s*(\d+)').firstMatch(raw);
    if (match == null) return null;
    return int.tryParse(match.group(1) ?? '');
  }

  static String _extractApiMessage(String raw) {
    final jsonStart = raw.indexOf('{');
    if (jsonStart == -1) return '';

    final jsonText = raw.substring(jsonStart).trim();
    try {
      final decoded = jsonDecode(jsonText);
      if (decoded is Map) {
        final nestedData = decoded['data'];
        final message =
            decoded['message'] ??
            decoded['error'] ??
            (nestedData is Map ? nestedData['message'] : null);
        return message?.toString().trim() ?? '';
      }
    } catch (_) {}

    return '';
  }

  static String _cleanExceptionText(String raw) {
    return raw
        .replaceFirst('Exception: Network error:', '')
        .replaceFirst('Network error:', '')
        .replaceFirst('Exception:', '')
        .trim();
  }

  static String _firstText(List<dynamic> values) {
    for (final value in values) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty && text != 'null') return text;
    }
    return '';
  }
}
