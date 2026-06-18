import '../services/api_service.dart';
import '../utils/constants.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    return await _apiService.post(ApiConstants.register, userData);
  }

  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp) async {
    return await _apiService.post(ApiConstants.verifyOtp, {
      'phoneNumber': phoneNumber,
      'otp': otp,
    });
  }

  Future<Map<String, dynamic>> login(String identifier, String password) async {
    print('🏪 AuthRepository.login() called');
    print('Identifier: $identifier');

    return await _apiService.post(ApiConstants.login, {
      'identifier': identifier,
      'email': identifier,
      'password': password,
    });
  }

  Future<Map<String, dynamic>> updateLanguagePreference(
    String language,
  ) async {
    print('========== UPDATE LANGUAGE API START ==========');
    print('URL: ${ApiConstants.baseUrl}${ApiConstants.garageLanguage}');
    print('Language: $language');

    final response = await _apiService.patch(ApiConstants.garageLanguage, {
      'language': language,
    });

    print('Language Response: $response');
    print('========== UPDATE LANGUAGE API END ==========');
    return response is Map<String, dynamic> ? response : {'data': response};
  }

  Future<Map<String, dynamic>> logout() async {
    print('========== LOGOUT API START ==========');
    print('URL: ${ApiConstants.baseUrl}${ApiConstants.logout}');

    final response = await _apiService.get(ApiConstants.logout);

    print('Logout Response: $response');
    print('========== LOGOUT API END ==========');
    return response is Map<String, dynamic> ? response : {'data': response};
  }
}
