import 'dart:convert';
import 'package:hornvin/localization/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/screens/garage_products_page.dart';
import 'package:hornvin/services/location_service.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DistributorsScreen extends StatefulWidget {
  const DistributorsScreen({super.key});

  @override
  State<DistributorsScreen> createState() => _DistributorsScreenState();
}

class _DistributorsScreenState extends State<DistributorsScreen> {
  final LocationService _locationService = LocationService();
  List<Map<String, dynamic>> _distributors = const [];
  bool _isLoading = true;
  String? _message;

  @override
  void initState() {
    super.initState();
    _loadDistributors();
  }

  Future<void> _loadDistributors() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedResponse = prefs.getString('nearestDistributorsResponse');
      Map<String, dynamic>? response;

      if (savedResponse != null && savedResponse.trim().isNotEmpty) {
        final decoded = jsonDecode(savedResponse);
        if (decoded is Map<String, dynamic>) {
          response = decoded;
        }
      }

      var latitude = prefs.getDouble('selectedLocationLatitude');
      var longitude = prefs.getDouble('selectedLocationLongitude');

      if ((latitude == null || longitude == null) &&
          (response == null || _itemsFromResponse(response).isEmpty)) {
        final selection = await _locationService.getCurrentLocation();
        latitude = selection.latitude;
        longitude = selection.longitude;
        await prefs.setString('selectedLocationName', selection.displayName);
        await prefs.setString('selectedLocationAddress', selection.address);
        await prefs.setDouble('selectedLocationLatitude', selection.latitude);
        await prefs.setDouble('selectedLocationLongitude', selection.longitude);
      }

      if ((response == null || _itemsFromResponse(response).isEmpty) &&
          latitude != null &&
          longitude != null) {
        response = await _locationService.findNearestDistributors(
          latitude: latitude,
          longitude: longitude,
        );
        await prefs.setString(
          'nearestDistributorsResponse',
          jsonEncode(response),
        );
      }

      if (!mounted) return;

      final distributors = _itemsFromResponse(response);
      setState(() {
        _distributors = distributors;
        _message = distributors.isEmpty ? 'No distributors found' : null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _distributors = const [];
        _message = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<Map<String, dynamic>> _itemsFromResponse(
    Map<String, dynamic>? response,
  ) {
    return _extractList(response);
  }

  List<Map<String, dynamic>> _extractList(Object? value) {
    if (value is List) {
      return value.whereType<Map>().map(Map<String, dynamic>.from).toList();
    }

    if (value is Map) {
      final map = Map<String, dynamic>.from(value);
      for (final key in const [
        'data',
        'distributors',
        'nearestDistributors',
        'nearest_distributors',
        'results',
        'items',
      ]) {
        final nested = _extractList(map[key]);
        if (nested.isNotEmpty) return nested;
      }
    }

    return const [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          context.trText('Distributors'),
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actionsIconTheme: const IconThemeData(color: AppColors.textPrimary),
        surfaceTintColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _isLoading ? null : _refreshFromCurrentLocation,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _distributors.isEmpty
          ? _EmptyDistributorsState(message: _message)
          : RefreshIndicator(
              onRefresh: _refreshFromCurrentLocation,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _distributors.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _DistributorCard(data: _distributors[index]);
                },
              ),
            ),
    );
  }

  Future<void> _refreshFromCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      final selection = await _locationService.getCurrentLocation();
      final response = await _locationService.findNearestDistributors(
        latitude: selection.latitude,
        longitude: selection.longitude,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedLocationName', selection.displayName);
      await prefs.setString('selectedLocationAddress', selection.address);
      await prefs.setDouble('selectedLocationLatitude', selection.latitude);
      await prefs.setDouble('selectedLocationLongitude', selection.longitude);
      await prefs.setString(
        'nearestDistributorsResponse',
        jsonEncode(response),
      );

      if (!mounted) return;
      setState(() {
        _distributors = _itemsFromResponse(response);
        _message = _distributors.isEmpty ? 'No distributors found' : null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _message = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class _DistributorCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _DistributorCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final distributor = _distributorMap(data);
    final name =
        distributor['name']?.toString() ??
        distributor['full_name']?.toString() ??
        distributor['business_name']?.toString() ??
        data['name']?.toString() ??
        'Distributor';
    final distributorId = _distributorId(data);
    final city =
        distributor['city']?.toString() ?? data['city']?.toString() ?? '';
    final type =
        distributor['distributionType']?.toString() ??
        data['distributionType']?.toString() ??
        '';
    final radius =
        distributor['serviceRadius'] ??
        distributor['radiusKm'] ??
        data['serviceRadius'] ??
        data['radiusKm'];
    final capacity =
        distributor['maxDailyCapacity'] ?? data['maxDailyCapacity'];
    final available =
        (distributor['isAvailable'] ?? data['isAvailable']) == true;
    final active = (distributor['isActive'] ?? data['isActive']) == true;
    final coordinates = _coordinatesText(
      context.trData(distributor['location'] ?? data['location']),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: distributorId.isEmpty
            ? null
            : () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GarageProductsPage(
                    distributorId: distributorId,
                    distributorName: name,
                  ),
                ),
              ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.trData(name),
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (city.isNotEmpty)
                          Text(
                            context.trData(city),
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: AppColors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  _StatusChip(
                    label: available ? 'Available' : 'Unavailable',
                    color: available ? Colors.green : Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (type.isNotEmpty)
                    _InfoChip(icon: Icons.category_rounded, label: type),
                  if (radius != null)
                    _InfoChip(icon: Icons.radar_rounded, label: '$radius km'),
                  if (capacity != null)
                    _InfoChip(
                      icon: Icons.inventory_2_rounded,
                      label: '$capacity/day',
                    ),
                  _InfoChip(
                    icon: Icons.check_circle_outline_rounded,
                    label: active ? 'Active' : 'Inactive',
                  ),
                ],
              ),
              if (coordinates.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  context.trData(coordinates),
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    color: AppColors.grey,
                  ),
                ),
              ],
              if (distributorId.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.inventory_2_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      context.trText('View products'),
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _distributorId(Map<String, dynamic> distributor) {
    final nestedDistributor = _distributorMap(distributor);
    final candidates = [
      distributor['distributorId'],
      distributor['assignedDistributorId'],
      distributor['nearestDistributorId'],
      distributor['_id'],
      distributor['id'],
      distributor['userId'],
      nestedDistributor['distributorId'],
      nestedDistributor['_id'],
      nestedDistributor['id'],
      nestedDistributor['userId'],
    ];

    for (final candidate in candidates) {
      final value = candidate?.toString().trim() ?? '';
      if (value.isNotEmpty) return value;
    }

    return '';
  }

  Map<String, dynamic> _distributorMap(Map<String, dynamic> data) {
    for (final key in const [
      'distributor',
      'distributorDetails',
      'nearestDistributor',
      'user',
    ]) {
      final value = data[key];
      if (value is Map) return Map<String, dynamic>.from(value);
    }

    return data;
  }

  String _coordinatesText(Object? location) {
    if (location is! Map) {
      return '';
    }

    final coordinates = location['coordinates'];
    if (coordinates is! List || coordinates.length < 2) {
      return '';
    }

    return 'Lat: ${coordinates[1]}, Long: ${coordinates[0]}';
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(
            context.trData(label),
            style: GoogleFonts.lato(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        context.trData(label),
        style: GoogleFonts.lato(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _EmptyDistributorsState extends StatelessWidget {
  final String? message;

  const _EmptyDistributorsState({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.storefront_outlined,
              size: 76,
              color: Color(0xFF9E9E9E),
            ),
            const SizedBox(height: 16),
            Text(
              context.trData(message ?? 'No distributors found'),
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(fontSize: 14, color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
