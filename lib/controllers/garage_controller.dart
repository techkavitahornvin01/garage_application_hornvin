// lib/controllers/garage_controller.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hornvin/models/job_model/garage_profile_model.dart';
import 'package:hornvin/utils/friendly_error.dart';
import '../repositories/garage_repository.dart';

class GarageController extends ChangeNotifier {
  final GarageRepository _repository = GarageRepository();

  GarageData? _profileData;
  bool _isLoading = false;
  bool _isUpdating = false;
  String? _errorMessage;
  String? _updateMessage;
  bool _updateSuccess = false;

  GarageData? get profileData => _profileData;
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  String? get errorMessage => _errorMessage;
  String? get updateMessage => _updateMessage;
  bool get updateSuccess => _updateSuccess;

  // Fetch garage profile
  Future<void> fetchGarageProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('🎮 Controller: Fetching garage profile');
      final response = await _repository.getGarageProfile();

      _profileData = response.data;
      _updateSuccess = false;

      print('✅ SUCCESS: Profile loaded in controller');
      print('   - Garage: ${_profileData?.businessName}');
      print('   - Owner: ${_profileData?.name}');
      print('   - Email: ${_profileData?.email}');
    } catch (e) {
      _errorMessage = friendlyErrorMessage(
        e,
        fallback: 'Garage profile could not be loaded right now. Please try again.',
      );
      print('❌ Controller Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update garage profile
  Future<bool> updateGarageProfile({
    required String businessName,
    required String name,
    required String email,
    required String phoneNumber,
    required String garageType,
    String? address,
    File? profilePhoto,
  }) async {
    _isUpdating = true;
    _updateMessage = null;
    _updateSuccess = false;
    notifyListeners();

    try {
      print('🎮 Controller: Updating garage profile');

      // Prepare update data
      final Map<String, dynamic> updateData = {
        'businessName': businessName,
        'business_name': businessName,
        'name': name,
        'full_name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'phone': phoneNumber,
        'garageType': garageType,
        'garage_type': garageType,
      };

      // Add address if provided
      final trimmedAddress = address?.trim();
      if (trimmedAddress != null && trimmedAddress.isNotEmpty) {
        updateData['businessAddress'] = {'country': trimmedAddress};
      }

      print('📤 Update Data: $updateData');

      final result = await _repository.updateGarageProfile(
        updateData,
        profilePhoto,
      );

      if (result['success']) {
        print('✅ SUCCESS: Profile updated successfully!');
        _updateMessage = result['message'];
        _updateSuccess = true;

        // Refresh profile data after update
        await fetchGarageProfile();

        notifyListeners();
        return true;
      } else {
        print('❌ ERROR: ${result['message']}');
        _updateMessage = result['message'];
        _updateSuccess = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('❌ Controller Error: $e');
      _updateMessage = friendlyErrorMessage(
        e,
        fallback: 'Garage profile could not be updated right now. Please try again.',
      );
      _updateSuccess = false;
      notifyListeners();
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // Update specific field
  Future<bool> updateGarageField(String field, dynamic value) async {
    _isUpdating = true;
    _updateMessage = null;
    notifyListeners();

    try {
      final updateData = {field: value};
      final result = await _repository.updateGarageProfile(updateData, null);

      if (result['success']) {
        _updateMessage =
            '${field.replaceFirst(field[0], field[0].toUpperCase())} updated successfully';
        _updateSuccess = true;
        await fetchGarageProfile();
        notifyListeners();
        return true;
      } else {
        _updateMessage = result['message'];
        _updateSuccess = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _updateMessage = friendlyErrorMessage(
        e,
        fallback: 'Garage profile could not be updated right now. Please try again.',
      );
      _updateSuccess = false;
      notifyListeners();
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // Clear messages
  void clearMessages() {
    _updateMessage = null;
    _errorMessage = null;
    _updateSuccess = false;
    notifyListeners();
  }
}
