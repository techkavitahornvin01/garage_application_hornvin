import '../repositories/auth_repository.dart';

class SignupController {
  static final AuthRepository _authRepository = AuthRepository();

  static Future<Map<String, dynamic>> register({
    required String name,
    required String businessName,
    required String phoneNumber,
    required String garageType,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Prepare data according to API format
    final Map<String, dynamic> userData = {
      'full_name': name,
      'business_name': businessName,
      'phone': phoneNumber,
      'garage_type': garageType,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    };

    // Call repository
    return await _authRepository.register(userData);
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    return await _authRepository.verifyOtp(phoneNumber, otp);
  }

  static String formatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    String cleaned = phoneNumber.replaceAll(RegExp(r'\D'), '');
    return cleaned;
  }

  static Map<String, bool> checkPasswordStrength(String password) {
    return {
      'length': password.length >= 8,
      'uppercase': password.contains(RegExp(r'[A-Z]')),
      'lowercase': password.contains(RegExp(r'[a-z]')),
      'digits': password.contains(RegExp(r'[0-9]')),
      'specialChars': password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
    };
  }

  // Garage types based on API requirement
  static List<String> getGarageTypes() {
    return ['independent', 'franchise', 'chain', 'authorized'];
  }

  static String getDisplayNameForGarageType(String type) {
    switch (type) {
      case 'independent':
        return 'Independent Garage';
      case 'franchise':
        return 'Franchise';
      case 'chain':
        return 'Chain Garage';
      case 'authorized':
        return 'Authorized Service Center';
      default:
        return type;
    }
  }
}
