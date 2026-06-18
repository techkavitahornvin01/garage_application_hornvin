import 'package:flutter/material.dart';
import 'package:hornvin/repositories/auth_repository.dart';
import 'package:hornvin/services/storage_service.dart';

class LanguageController extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> loadSavedLanguage() async {
    final code = await StorageService.getLanguageCode();
    _locale = Locale(code ?? 'en');
  }

  Future<Map<String, dynamic>?> changeLanguage(String languageCode) async {
    final normalizedCode = _normalizeLanguageCode(languageCode);
    final token = await StorageService.getToken();
    Map<String, dynamic>? response;

    if (token != null && token.isNotEmpty) {
      response = await _authRepository.updateLanguagePreference(
        _languageNameForCode(normalizedCode),
      );
    }

    final serverCode = _extractLanguageCode(response);
    final selectedCode = serverCode ?? normalizedCode;

    _locale = Locale(selectedCode);
    await StorageService.setLanguageCode(selectedCode);
    notifyListeners();
    return response;
  }

  String _normalizeLanguageCode(String languageCode) {
    final value = languageCode.trim().toLowerCase();
    if (value == 'hi' || value == 'hindi') return 'hi';
    return 'en';
  }

  String _languageNameForCode(String languageCode) {
    return languageCode == 'hi' ? 'Hindi' : 'English';
  }

  String? _extractLanguageCode(Map<String, dynamic>? response) {
    final data = response?['data'];
    if (data is Map) {
      final code = data['languageCode']?.toString().trim().toLowerCase();
      if (code == 'hi' || code == 'en') return code;

      final language = data['language']?.toString().trim().toLowerCase();
      if (language == 'hindi') return 'hi';
      if (language == 'english') return 'en';
    }

    return null;
  }
}
