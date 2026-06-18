import 'package:flutter/material.dart';
import 'package:hornvin/controllers/login_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userType;
  String? _userName;

  bool get isAuthenticated => _isAuthenticated;
  String? get userType => _userType;
  String? get userName => _userName;

  Future<void> loginWithEmail(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1000000));

    // Demo credentials
    if (email == "demo@hornvin.com" && password == "123456") {
      _isAuthenticated = true;
      _userType = "Distributor";
      _userName = "HORNVIN Distributor";
      await _saveSession();
      notifyListeners();
    } else {
      throw Exception("Invalid credentials");
    }
  }

  Future<void> loginWithOTP(String phoneNumber, String otp) async {
    await Future.delayed(const Duration(seconds: 1));

    // Demo OTP - any 4-digit code works for demo
    if (otp.length == 4 && otp == "1234") {
      _isAuthenticated = true;
      _userType = "Distributor";
      _userName = "HORNVIN Distributor";
      await _saveSession();
      notifyListeners();
    } else {
      throw Exception("Invalid OTP");
    }
  }

  Future<void> sendOTP(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate sending OTP
    debugPrint("OTP sent to $phoneNumber: 1234");
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);
    await prefs.setString('userType', _userType!);
    await prefs.setString('userName', _userName!);
  }

  Future<void> checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _userType = prefs.getString('userType');
    _userName = prefs.getString('userName');
    notifyListeners();
  }

  Future<void> logout() async {
    await LoginController.logout();
    _isAuthenticated = false;
    _userType = null;
    _userName = null;
    notifyListeners();
  }
}
