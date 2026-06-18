import 'dart:async';
import 'package:hornvin/localization/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/models/location_selection.dart';
import 'package:hornvin/services/location_service.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  final LocationService _locationService = LocationService();
  Timer? _debounce;
  List<LocationSelection> _results = const [];
  bool _isSearching = false;
  bool _isDetecting = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      _searchLocations(_searchController.text);
    });
  }

  Future<void> _searchLocations(String query) async {
    if (query.trim().length < 3) {
      if (!mounted) return;
      setState(() {
        _results = const [];
        _message = null;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _message = null;
    });

    try {
      final results = await _locationService.searchLocations(query);
      if (!mounted) return;
      setState(() {
        _results = results;
        _message = results.isEmpty ? 'No location found' : null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _results = const [];
        _message = 'No locations found. Check internet and try again.';
      });
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _isDetecting = true;
      _message = null;
    });

    try {
      final selection = await _locationService.getCurrentLocation();
      if (!mounted) return;
      Navigator.pop(context, selection);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _message = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isDetecting = false);
      }
    }
  }

  void _selectLocation(LocationSelection selection) {
    _locationService.printSelectedLocation(selection);
    Navigator.pop(context, selection);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actionsIconTheme: const IconThemeData(color: AppColors.textPrimary),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr('confirm_location'),
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: _isDetecting ? null : _useCurrentLocation,
            child: Container(
              color: const Color(0xFFF0F0F0),
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
              child: Row(
                children: [
                  _isDetecting
                      ? const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(strokeWidth: 2.4),
                        )
                      : const Icon(
                          Icons.my_location_rounded,
                          color: Color(0xFF43A047),
                          size: 30,
                        ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('use_current_location'),
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          context.tr('for_service_confirmation'),
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.lato(fontSize: 15),
              decoration: InputDecoration(
                hintText: context.tr('search_location_hint'),
                hintStyle: GoogleFonts.lato(
                  color: const Color(0xFFB3BAC6),
                  fontSize: 15,
                ),
                prefixIcon: const Icon(Icons.search_rounded, size: 30),
                suffixIcon: _isSearching
                    ? const Padding(
                        padding: EdgeInsets.all(14),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE1E4EA)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE1E4EA)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),
          if (_message != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                context.trData(_message!),
                style: GoogleFonts.lato(color: AppColors.grey, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: _results.isEmpty ? _buildEmptyState() : _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 82,
            color: Color(0xFF9E9E9E),
          ),
          const SizedBox(height: 18),
          Text(
            context.tr('search_for_locations'),
            style: GoogleFonts.lato(fontSize: 16, color: AppColors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            context.tr('type_location_hint'),
            style: GoogleFonts.lato(
              fontSize: 13,
              color: const Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
      itemCount: _results.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final location = _results[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 8,
          ),
          leading: const Icon(
            Icons.location_on_outlined,
            color: AppColors.primary,
          ),
          title: Text(
            context.trData(location.displayName),
            style: GoogleFonts.lato(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            '${location.address}\nLat: ${location.latitude}, Long: ${location.longitude}',
            style: GoogleFonts.lato(fontSize: 11, color: AppColors.grey),
          ),
          isThreeLine: true,
          onTap: () => _selectLocation(location),
        );
      },
    );
  }
}
