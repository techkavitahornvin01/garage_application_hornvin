import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hornvin/models/location_selection.dart';
import 'package:hornvin/services/api_service.dart';
import 'package:hornvin/utils/constants.dart';
import 'package:http/http.dart' as http;

class LocationService {
  final ApiService _apiService = ApiService();

  Future<LocationSelection> getCurrentLocation() async {
    final permission = await _ensurePermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const LocationServiceException(
        'Location permission is required to detect current location.',
      );
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    final address = await _addressFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final selection = LocationSelection(
      name: address.name,
      address: address.address,
      latitude: position.latitude,
      longitude: position.longitude,
    );
    _printSelection(selection);
    return selection;
  }

  Future<List<LocationSelection>> searchLocations(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.length < 3) {
      return const [];
    }

    final nominatimResults = await _searchWithNominatim(trimmedQuery);
    if (nominatimResults.isNotEmpty) {
      return nominatimResults;
    }

    final locations = await locationFromAddress(trimmedQuery);
    final limitedLocations = locations.take(8);
    final results = <LocationSelection>[];

    for (final location in limitedLocations) {
      final address = await _addressFromCoordinates(
        location.latitude,
        location.longitude,
        fallbackName: trimmedQuery,
      );
      results.add(
        LocationSelection(
          name: address.name,
          address: address.address,
          latitude: location.latitude,
          longitude: location.longitude,
        ),
      );
    }

    return results;
  }

  Future<Map<String, dynamic>> findNearestDistributors({
    required double latitude,
    required double longitude,
  }) async {
    final endpoint = Uri(
      path: ApiConstants.nearestDistributors,
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      },
    ).toString();

    debugPrint('Nearest distributor endpoint: $endpoint');

    try {
      final decoded = await _apiService.get(endpoint);
      if (decoded is! Map<String, dynamic>) {
        throw const LocationServiceException(
          'Invalid nearest distributor response.',
        );
      }

      return decoded;
    } catch (error) {
      if (error is LocationServiceException) {
        rethrow;
      }
      throw LocationServiceException(
        'Unable to fetch nearest distributors: $error',
      );
    }
  }

  Future<List<LocationSelection>> _searchWithNominatim(String query) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': query,
      'format': 'jsonv2',
      'addressdetails': '1',
      'countrycodes': 'in',
      'accept-language': 'en-IN',
      'limit': '15',
    });

    try {
      final response = await http.get(
        uri,
        headers: const {
          'Accept': 'application/json',
          'User-Agent': 'HornvinGaragePartner/1.0',
        },
      );

      if (response.statusCode != 200) {
        return const [];
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        return const [];
      }

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(_selectionFromNominatim)
          .whereType<LocationSelection>()
          .toList();
    } catch (_) {
      return const [];
    }
  }

  LocationSelection? _selectionFromNominatim(Map<String, dynamic> item) {
    final lat = double.tryParse(item['lat']?.toString() ?? '');
    final lon = double.tryParse(item['lon']?.toString() ?? '');
    final displayName = item['display_name']?.toString().trim() ?? '';

    if (lat == null || lon == null || displayName.isEmpty) {
      return null;
    }

    final address = item['address'];
    final name = _nameFromAddress(address, displayName);

    return LocationSelection(
      name: name,
      address: displayName,
      latitude: lat,
      longitude: lon,
    );
  }

  String _nameFromAddress(Object? address, String displayName) {
    if (address is Map) {
      final candidates = [
        address['house_number'],
        address['amenity'],
        address['shop'],
        address['building'],
        address['road'],
        address['suburb'],
        address['neighbourhood'],
        address['quarter'],
        address['city_district'],
        address['city'],
        address['town'],
        address['village'],
        address['state'],
      ];

      for (final candidate in candidates) {
        final value = candidate?.toString().trim();
        if (value != null && value.isNotEmpty) {
          return value;
        }
      }
    }

    return displayName.split(',').first.trim();
  }

  void printSelectedLocation(LocationSelection selection) {
    _printSelection(selection);
  }

  Future<LocationPermission> _ensurePermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return permission;
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceException(
        'Please turn on location service and try again.',
      );
    }

    return permission;
  }

  Future<_ResolvedAddress> _addressFromCoordinates(
    double latitude,
    double longitude, {
    String fallbackName = 'Current Location',
  }) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) {
        return _ResolvedAddress(fallbackName, fallbackName);
      }

      final place = placemarks.first;
      final nameParts = [
        place.subLocality,
        place.locality,
      ].where((part) => part != null && part.trim().isNotEmpty).cast<String>();
      final addressParts = [
        place.name,
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.country,
      ].where((part) => part != null && part.trim().isNotEmpty).cast<String>();

      final name = nameParts.isEmpty ? fallbackName : nameParts.join(', ');
      final address = addressParts.isEmpty ? name : addressParts.join(', ');
      return _ResolvedAddress(name, address);
    } catch (_) {
      return _ResolvedAddress(fallbackName, fallbackName);
    }
  }

  void _printSelection(LocationSelection selection) {
    debugPrint('Selected location: ${selection.toJson()}');
    debugPrint(
      'Latitude: ${selection.latitude}, Longitude: ${selection.longitude}',
    );
  }
}

class LocationServiceException implements Exception {
  final String message;

  const LocationServiceException(this.message);

  @override
  String toString() => message;
}

class _ResolvedAddress {
  final String name;
  final String address;

  const _ResolvedAddress(this.name, this.address);
}
