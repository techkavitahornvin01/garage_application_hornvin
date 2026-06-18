// lib/repositories/garage_repository.dart

import 'dart:convert';
import 'dart:io';

import 'package:hornvin/models/job_model/garage_profile_model.dart';

import '../services/api_service.dart';
import '../utils/constants.dart';

class GarageRepository {
  final ApiService _apiService = ApiService();

  // GET: Fetch garage profile
  Future<GarageProfileResponse> getGarageProfile() async {
    print('\n🏪 ========== GET GARAGE PROFILE START ==========');

    try {
      final endpoint = ApiConstants.garageProfile;
      print('🌐 Request URL: ${ApiConstants.baseUrl}$endpoint');

      final response = await _apiService.get(endpoint);

      print('📦 Raw API Response:');
      print('─' * 60);
      print(response);
      print('─' * 60);

      print('🔄 Parsing response to GarageProfileResponse...');
      final profileResponse = GarageProfileResponse.fromJson(response);

      print('✅ Parse successful!');
      print('📊 Profile Data:');
      print('   - Success: ${profileResponse.success}');
      print('   - Message: ${profileResponse.message}');
      print('   - Garage Name: ${profileResponse.data.businessName}');
      print('   - Owner Name: ${profileResponse.data.name}');
      print('   - Email: ${profileResponse.data.email}');
      print('   - Phone: ${profileResponse.data.phoneNumber}');

      print('🏪 ========== GET GARAGE PROFILE END ==========\n');
      return profileResponse;
    } catch (e, stackTrace) {
      print('❌ ERROR in getGarageProfile:');
      print('   - Error: $e');
      print('   - StackTrace: $stackTrace');
      print('🔴 ========== GET GARAGE PROFILE FAILED ==========\n');
      throw Exception('Failed to fetch garage profile: $e');
    }
  }

  // POST: Update garage profile (same endpoint as GET)
  Future<Map<String, dynamic>> updateGarageProfile(
    Map<String, dynamic> updateData,
    File? profilePhoto,
  ) async {
    print('\n✏️ ========== UPDATE GARAGE PROFILE START ==========');

    try {
      final endpoint = ApiConstants.garageProfile;
      print('🌐 Request URL: ${ApiConstants.baseUrl}$endpoint');
      print('📤 Update Data:');
      print('─' * 60);
      updateData.forEach((key, value) {
        print('   $key: $value');
      });
      print('─' * 60);

      final response = profilePhoto == null
          ? await _apiService.post(endpoint, updateData)
          : await _apiService.postMultipart(
              endpoint,
              fields: updateData.map(
                (key, value) =>
                    MapEntry(key, value is String ? value : jsonEncode(value)),
              ),
              files: {
                'photo': [profilePhoto],
              },
            );

      print('📦 Raw API Response:');
      print('─' * 60);
      print(response);
      print('─' * 60);

      print('✅ Profile updated successfully!');
      print('✏️ ========== UPDATE GARAGE PROFILE END ==========\n');

      return {
        'success': true,
        'data': response,
        'message': 'Profile updated successfully',
      };
    } catch (e, stackTrace) {
      print('❌ ERROR in updateGarageProfile:');
      print('   - Error: $e');
      print('   - StackTrace: $stackTrace');
      print('🔴 ========== UPDATE GARAGE PROFILE FAILED ==========\n');
      return {
        'success': false,
        'message': 'Failed to update profile: ${e.toString()}',
      };
    }
  }
}
