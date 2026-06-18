// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class StorageService {
//   static const String _tokenKey = 'auth_token';
//   static const String _userDataKey = 'user_data';
//   static const String _isLoggedInKey = 'is_logged_in';

//   static late SharedPreferences _preferences;

//   // Initialize shared preferences
//   static Future<void> init() async {
//     _preferences = await SharedPreferences.getInstance();
//   }

//   // Save auth token
//   static Future<bool> saveToken(String token) async {
//     return await _preferences.setString(_tokenKey, token);
//   }

//   // Get auth token
//   static String? getToken() {
//     return _preferences.getString(_tokenKey);
//   }

//   // Save user data
//   static Future<bool> saveUserData(Map<String, dynamic> userData) async {
//     return await _preferences.setString(_userDataKey, json.encode(userData));
//   }

//   // Get user data
//   static Map<String, dynamic>? getUserData() {
//     final userDataString = _preferences.getString(_userDataKey);
//     if (userDataString != null) {
//       return json.decode(userDataString) as Map<String, dynamic>;
//     }
//     return null;
//   }

//   // Set login status
//   static Future<bool> setLoggedIn(bool isLoggedIn) async {
//     return await _preferences.setBool(_isLoggedInKey, isLoggedIn);
//   }

//   // Check if user is logged in
//   static bool isLoggedIn() {
//     return _preferences.getBool(_isLoggedInKey) ?? false;
//   }

//   // Clear all user data (logout)
//   static Future<void> clearUserData() async {
//     await _preferences.remove(_tokenKey);
//     await _preferences.remove(_userDataKey);
//     await _preferences.remove(_isLoggedInKey);
//   }
// }

// import 'package:shared_preferences/shared_preferences.dart';

// class StorageService {
//   static late SharedPreferences _prefs;

//   static Future<void> init() async {
//     _prefs = await SharedPreferences.getInstance();
//   }

//   static Future<void> saveToken(String token) async {
//     await _prefs.setString('auth_token', token);
//   }

//   static Future<void> saveUserData(Map<String, dynamic> user) async {
//     await _prefs.setString('user_data', user.toString());
//   }

//   static Future<void> setLoggedIn(bool value) async {
//     await _prefs.setBool('is_logged_in', value);
//   }
// }

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveToken(String token) async {
    await _prefs.setString('auth_token', token);
  }

  static Future<String?> getToken() async {
    return _prefs.getString('auth_token');
  }

  static Future<void> savePhoneNumber(String phoneNumber) async {
    await _prefs.setString('phone_number', phoneNumber);
  }

  static Future<String?> getPhoneNumber() async {
    return _prefs.getString('phone_number');
  }

  static Future<void> saveUserData(Map<String, dynamic> user) async {
    await _prefs.setString('user_data', jsonEncode(user));
    await _prefs.setString(
      'userName',
      _firstText([
        user['name'],
        user['full_name'],
        user['fullName'],
        user['businessName'],
        user['business_name'],
      ], defaultValue: 'Garage Owner'),
    );
    await _prefs.setString(
      'userEmail',
      _firstText([user['email'], user['phone'], user['phoneNumber']]),
    );
    await _prefs.setString(
      'userRole',
      _firstText([user['role']], defaultValue: 'Garage'),
    );
  }

  static Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool('is_logged_in', value);
  }

  static Future<bool> isLoggedIn() async {
    return _prefs.getBool('is_logged_in') ?? false;
  }

  static Future<void> setIntroSeen() async {
    await _prefs.setBool('has_seen_intro', true);
  }

  // Check if intro has been seen
  static Future<bool> hasSeenIntro() async {
    return _prefs.getBool('has_seen_intro') ?? false;
  }

  static Future<void> setLanguageCode(String languageCode) async {
    await _prefs.setString('language_code', languageCode);
  }

  static Future<String?> getLanguageCode() async {
    return _prefs.getString('language_code');
  }

  static Future<bool> hasSelectedLanguage() async {
    return _prefs.getString('language_code') != null;
  }

  static Future<void> saveLocation(
    String address,
    double lat,
    double lng,
  ) async {
    await _prefs.setString('user_address', address);
    await _prefs.setDouble('user_lat', lat);
    await _prefs.setDouble('user_lng', lng);
  }

  static Future<Map<String, dynamic>?> getLocation() async {
    final address = _prefs.getString('user_address');
    final lat = _prefs.getDouble('user_lat');
    final lng = _prefs.getDouble('user_lng');

    if (address != null && lat != null && lng != null) {
      return {'address': address, 'latitude': lat, 'longitude': lng};
    }
    return null;
  }

  static Future<void> logout() async {
    await _prefs.remove('auth_token');
    await _prefs.remove('is_logged_in');
    await _prefs.remove('user_data');
    await _prefs.remove('phone_number');
    await _prefs.remove('userName');
    await _prefs.remove('userEmail');
    await _prefs.remove('userRole');
  }

  static Future<void> clearAll() async {
    await _prefs.clear();
  }

  static String _firstText(List<dynamic> values, {String defaultValue = ''}) {
    for (final value in values) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty && text != 'null') return text;
    }
    return defaultValue;
  }
}
