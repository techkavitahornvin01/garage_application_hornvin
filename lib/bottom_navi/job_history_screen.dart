import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/repositories/job_repository.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';
import 'package:hornvin/localization/app_localizations.dart';

class JobHistoryScreen extends StatefulWidget {
  const JobHistoryScreen({super.key});

  @override
  State<JobHistoryScreen> createState() => _JobHistoryScreenState();
}

class _JobHistoryScreenState extends State<JobHistoryScreen> {
  final JobRepository _jobRepository = JobRepository();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _vehicles = [];
  Map<String, dynamic> _summary = const {};
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadGarageHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadGarageHistory() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final response = await _fetchGarageHistoryResponse();
      final vehicles = _extractVehicles(response);
      final summary = _extractSummary(response, vehicles);

      if (!mounted) return;
      setState(() {
        _summary = summary;
        _vehicles = vehicles;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> _fetchGarageHistoryResponse() async {
    Object? lastError;
    for (final fetch in <Future<Map<String, dynamic>> Function()>[
      _jobRepository.getAllGarageVehicleServiceHistory,
      _jobRepository.getGarageVehicleHistory,
      _jobRepository.getGarageHistory,
    ]) {
      try {
        return await fetch();
      } catch (e) {
        lastError = e;
      }
    }
    throw lastError ?? Exception('History could not be loaded');
  }

  List<Map<String, dynamic>> get _filteredVehicles {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return _vehicles;

    return _vehicles.where((vehicle) {
      final jobs = vehicle['jobHistory'] as List<Map<String, dynamic>>;
      return vehicle['vehicleNumber'].toString().toLowerCase().contains(
            query,
          ) ||
          vehicle['customerName'].toString().toLowerCase().contains(query) ||
          vehicle['phoneNumber'].toString().toLowerCase().contains(query) ||
          vehicle['vehicleModel'].toString().toLowerCase().contains(query) ||
          jobs.any(
            (job) =>
                job['description'].toString().toLowerCase().contains(query) ||
                job['mechanicName'].toString().toLowerCase().contains(query),
          );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.scaffold,
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _loadGarageHistory,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? _buildErrorState()
            : _vehicles.isEmpty
            ? _buildEmptyState()
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 14),
                  _buildSummary(),
                  const SizedBox(height: 14),
                  _buildSearch(),
                  const SizedBox(height: 14),
                  ..._filteredVehicles.map(_buildVehicleCard),
                  if (_filteredVehicles.isEmpty) _buildNoSearchResult(),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.secondary, AppColors.secondaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.16),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.manage_history_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('garage_history'),
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  context.tr('garage_history_subtitle'),
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.76),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            'vehicles',
            _summary['totalVehicles'].toString(),
            Icons.directions_car_rounded,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _summaryCard(
            'jobs',
            _summary['totalJobs'].toString(),
            Icons.build_circle_outlined,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _summaryCard(
            'revenue',
            '₹${_formatAmount(_summary['totalRevenue'])}',
            Icons.account_balance_wallet_outlined,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(
    String titleKey,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            context.trData(value),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            context.tr(titleKey),
            style: GoogleFonts.lato(fontSize: 10, color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _query = value),
      decoration: InputDecoration(
        hintText: context.tr('search_history_hint'),
        prefixIcon: const Icon(Icons.search, color: AppColors.grey),
        suffixIcon: _query.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
                icon: const Icon(Icons.close, color: AppColors.grey),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
        ),
      ),
      style: GoogleFonts.lato(fontSize: 13),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle) {
    final jobs = vehicle['jobHistory'] as List<Map<String, dynamic>>;
    final latestJob = jobs.isNotEmpty ? jobs.first : null;
    final revenue = jobs.fold<int>(
      0,
      (sum, job) => sum + _asInt(job['totalPrice']),
    );

    return InkWell(
      onTap: () => _showVehicleDetails(vehicle),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.75)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.045),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.directions_car_filled_rounded,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.trData(vehicle['vehicleNumber']),
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.secondary,
                        ),
                      ),
                      Text(
                        '${vehicle['vehicleModel']} - ${vehicle['customerName']}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _statusChip(latestJob?['status'] ?? 'pending'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _metaPill(Icons.phone_outlined, vehicle['phoneNumber']),
                const SizedBox(width: 8),
                _metaPill(Icons.speed_rounded, '${vehicle['kmsDriven']} km'),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(child: _smallStat('jobs', jobs.length.toString())),
                  _thinDivider(),
                  Expanded(
                    child: _smallStat(
                      'latest',
                      latestJob == null
                          ? 'N/A'
                          : _formatDate(latestJob['serviceDate']),
                    ),
                  ),
                  _thinDivider(),
                  Expanded(
                    child: _smallStat('revenue', '₹${_formatAmount(revenue)}'),
                  ),
                ],
              ),
            ),
            if (latestJob != null) const SizedBox(height: 10),
            if (latestJob != null)
              Text(
                context.trData(latestJob['description']),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(fontSize: 12, color: AppColors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _metaPill(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 13, color: AppColors.secondary),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                context.trData(text),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallStat(String labelKey, String value) {
    return Column(
      children: [
        Text(
          context.trData(value),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.lato(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          context.tr(labelKey),
          style: GoogleFonts.lato(fontSize: 10, color: AppColors.grey),
        ),
      ],
    );
  }

  Widget _thinDivider() {
    return Container(width: 1, height: 34, color: AppColors.divider);
  }

  Widget _statusChip(String status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        context.tr(
          status.toLowerCase(),
        ), // Using key for status like 'completed', 'pending'
        style: GoogleFonts.lato(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }

  void _showVehicleDetails(Map<String, dynamic> vehicle) {
    final jobs = vehicle['jobHistory'] as List<Map<String, dynamic>>;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.88,
          minChildSize: 0.55,
          maxChildSize: 0.94,
          builder: (context, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                      children: [
                        Text(
                          context.trData(vehicle['vehicleNumber']),
                          style: GoogleFonts.lato(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.secondary,
                          ),
                        ),
                        Text(
                          '${vehicle['customerName']} - ${vehicle['phoneNumber']}',
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            color: AppColors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _detailPanel(
                          children: [
                            _detailRow('vehicle_type', vehicle['vehicleType']),
                            _detailRow(
                              'vehicle_model',
                              vehicle['vehicleModel'],
                            ),
                            _detailRow(
                              'year',
                              vehicle['vehicleYear'].toString(),
                            ),
                            _detailRow('fuel_type', vehicle['fuelType']),
                            _detailRow(
                              'kms_driven',
                              vehicle['kmsDriven'].toString(),
                            ),
                            _detailRow('color', vehicle['vehicleColor']),
                            _detailRow('owner', vehicle['ownershipDetails']),
                            _detailRow(
                              'tyre_condition',
                              vehicle['tyreCondition'],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _sectionTitle('job_history'),
                        const SizedBox(height: 8),
                        ...jobs.map(_jobCard),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _jobCard(Map<String, dynamic> job) {
    final parts = job['parts'] as List<Map<String, dynamic>>;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _formatDate(job['serviceDate']),
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _statusChip(job['status']),
            ],
          ),
          const SizedBox(height: 8),
          _detailRow('description', job['description']),
          _detailRow(
            'mechanic',
            '${job['mechanicName']} (${job['mechanicProfile']})',
          ),
          const SizedBox(height: 8),
          ...parts.map((part) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      context.trData(part['partName']),
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '₹${_formatAmount(part['cost'])}',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            );
          }),
          const Divider(height: 18),
          _detailRow(
            'total_price',
            '₹${_formatAmount(job['totalPrice'])}',
            isAmount: true,
          ),
        ],
      ),
    );
  }

  Widget _detailPanel({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.7)),
      ),
      child: Column(children: children),
    );
  }

  Widget _sectionTitle(String titleKey) {
    return Text(
      context.tr(titleKey),
      style: GoogleFonts.lato(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _detailRow(String labelKey, String value, {bool isAmount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              context.tr(labelKey),
              style: GoogleFonts.lato(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.trData(value.isEmpty ? 'N/A' : value),
              textAlign: TextAlign.right,
              style: GoogleFonts.lato(
                fontSize: isAmount ? 14 : 12,
                fontWeight: isAmount ? FontWeight.w800 : FontWeight.w600,
                color: isAmount ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSearchResult() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off, size: 48, color: AppColors.grey),
          const SizedBox(height: 10),
          Text(
            context.tr('no_matching_history'),
            style: GoogleFonts.lato(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 120),
        const Icon(Icons.history_toggle_off, size: 72, color: AppColors.grey),
        const SizedBox(height: 14),
        Text(
          context.tr('no_garage_history'),
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 120),
        Icon(Icons.cloud_off, size: 72, color: Colors.red.shade300),
        const SizedBox(height: 14),
        Text(
          context.tr('history_load_error'),
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.trData(_errorMessage ?? ''),
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(fontSize: 12, color: AppColors.grey),
        ),
        const SizedBox(height: 18),
        Center(
          child: ElevatedButton.icon(
            onPressed: _loadGarageHistory,
            icon: const Icon(Icons.refresh),
            label: Text(context.tr('retry')),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(120, 42),
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _extractVehicles(Map<String, dynamic> response) {
    final rawItems = _historyListFrom(response);
    if (rawItems.isEmpty) return [];

    final grouped = <String, Map<String, dynamic>>{};
    for (final raw in rawItems.whereType<Map>()) {
      final item = Map<String, dynamic>.from(raw);
      final normalized = _normalizeVehicle(item);
      final jobHistory = normalized['jobHistory'] as List<Map<String, dynamic>>;
      final hasNestedJobs = jobHistory.isNotEmpty;
      final job = hasNestedJobs ? null : _normalizeJobFromHistoryEntry(item);
      final key = _vehicleKey(normalized);

      grouped.putIfAbsent(key, () {
        return {
          ...normalized,
          'jobHistory': <Map<String, dynamic>>[],
        };
      });

      final targetJobs =
          grouped[key]!['jobHistory'] as List<Map<String, dynamic>>;
      if (hasNestedJobs) {
        targetJobs.addAll(jobHistory);
      } else if (job != null) {
        targetJobs.add(job);
      }
    }

    final vehicles = grouped.values.toList();
    for (final vehicle in vehicles) {
      final jobs = vehicle['jobHistory'] as List<Map<String, dynamic>>;
      jobs.sort((a, b) {
        final first = DateTime.tryParse(_asString(a['serviceDate']));
        final second = DateTime.tryParse(_asString(b['serviceDate']));
        if (first == null && second == null) return 0;
        if (first == null) return 1;
        if (second == null) return -1;
        return second.compareTo(first);
      });
    }
    return vehicles;
  }

  List<dynamic> _historyListFrom(Map<String, dynamic> response) {
    final data = response['data'];
    final candidates = <dynamic>[
      data,
      if (data is Map) ...[
        data['vehicles'],
        data['vehicleHistories'],
        data['histories'],
        data['history'],
        data['records'],
        data['items'],
        data['jobs'],
        data['docs'],
        data['results'],
      ],
      response['vehicles'],
      response['vehicleHistories'],
      response['histories'],
      response['history'],
      response['records'],
      response['items'],
      response['jobs'],
      response['docs'],
      response['results'],
    ];

    for (final candidate in candidates) {
      if (candidate is List) return candidate;
    }
    if (data is Map && _looksLikeHistoryRecord(data)) return [data];
    if (_looksLikeHistoryRecord(response)) return [response];
    return const [];
  }

  bool _looksLikeHistoryRecord(Map<dynamic, dynamic> value) {
    return value.containsKey('vehicleNumber') ||
        value.containsKey('vehicle_number') ||
        value.containsKey('vehicle_id') ||
        value.containsKey('registrationNumber') ||
        value.containsKey('customerName') ||
        value.containsKey('customer_name') ||
        value.containsKey('jobHistory') ||
        value.containsKey('service_type') ||
        value.containsKey('problem_description');
  }

  Map<String, dynamic> _extractSummary(
    Map<String, dynamic> response,
    List<Map<String, dynamic>> vehicles,
  ) {
    final data = response['data'];
    final source = data is Map ? data : response;
    final calculatedJobs = vehicles.fold<int>(
      0,
      (sum, vehicle) =>
          sum + (vehicle['jobHistory'] as List<Map<String, dynamic>>).length,
    );
    final calculatedRevenue = vehicles.fold<int>(0, (sum, vehicle) {
      final jobs = vehicle['jobHistory'] as List<Map<String, dynamic>>;
      return sum +
          jobs.fold<int>(0, (jobSum, job) => jobSum + _asInt(job['totalPrice']));
    });

    return {
      'totalVehicles': _asInt(
        source['totalVehicles'] ??
            source['totalVehicle'] ??
            source['vehicleCount'],
        defaultValue: vehicles.length,
      ),
      'totalJobs': _asInt(
        source['totalJobs'] ?? source['jobCount'] ?? source['count'],
        defaultValue: calculatedJobs,
      ),
      'totalRevenue': _asInt(
        source['totalRevenue'] ?? source['revenue'] ?? source['totalAmount'],
        defaultValue: calculatedRevenue,
      ),
    };
  }

  Map<String, dynamic> _normalizeVehicle(Map<String, dynamic> vehicle) {
    return {
      'vehicleNumber': _firstString([
        vehicle['vehicleNumber'],
        vehicle['vehicle_number'],
        vehicle['vehicle_id'],
        vehicle['registrationNumber'],
        vehicle['registration_number'],
        vehicle['regNo'],
      ]),
      'registrationNumber': _firstString([
        vehicle['registrationNumber'],
        vehicle['registration_number'],
        vehicle['vehicleNumber'],
        vehicle['vehicle_id'],
      ]),
      'customerName': _asString(
        vehicle['customerName'] ?? vehicle['customer_name'] ?? vehicle['name'],
        defaultValue: 'Customer',
      ),
      'phoneNumber': _firstString([
        vehicle['phoneNumber'],
        vehicle['phone_number'],
        vehicle['mobile'],
        vehicle['customerPhone'],
      ]),
      'vehicleType': _firstString([
        vehicle['vehicleType'],
        vehicle['vehicle_type'],
        vehicle['type'],
      ]),
      'vehicleModel': _asString(
        vehicle['vehicleModel'] ?? vehicle['vehicle_model'] ?? vehicle['model'],
        defaultValue: 'Vehicle',
      ),
      'vehicleYear': _asInt(vehicle['vehicleYear'] ?? vehicle['year']),
      'fuelType': _asString(vehicle['fuelType'] ?? vehicle['fuel_type']),
      'kmsDriven': _asInt(
        vehicle['kmsDriven'] ?? vehicle['kms_driven'] ?? vehicle['odometer'],
      ),
      'vehicleColor': _asString(vehicle['vehicleColor'] ?? vehicle['color']),
      'ownershipDetails': _asString(
        vehicle['ownershipDetails'] ?? vehicle['ownership_details'],
      ),
      'tyreCondition': _asString(
        vehicle['tyreCondition'] ?? vehicle['tyre_condition'],
      ),
      'jobHistory': _normalizeJobs(
        vehicle['jobHistory'] ??
            vehicle['jobs'] ??
            vehicle['history'] ??
            vehicle['serviceHistory'],
      ),
    };
  }

  List<Map<String, dynamic>> _normalizeJobs(dynamic value) {
    if (value is! List) return [];
    return value.whereType<Map>().map((job) {
      return {
        'id': _firstString([job['_id'], job['id']]),
        'serviceDate':
            job['serviceDate'] ??
            job['service_date'] ??
            job['createdAt'] ??
            job['created_at'] ??
            job['updatedAt'],
        'description': _firstString([
          job['description'],
          job['problem_description'],
          job['service_type'],
          job['notes'],
        ]),
        'mechanicName': _firstString([
          job['mechanicName'],
          job['mechanic_name'],
          job['mechanic'],
        ], defaultValue: 'N/A'),
        'mechanicProfile': _firstString([
          job['mechanicProfile'],
          job['mechanic_profile'],
          job['employeeProfile'],
        ], defaultValue: 'Mechanic'),
        'parts': _normalizeParts(job['parts']),
        'totalPrice': _asInt(
          job['totalPrice'] ??
              job['total_price'] ??
              job['estimated_cost'] ??
              job['cost'] ??
              job['amount'],
        ),
        'status': _asString(job['status'], defaultValue: 'pending'),
      };
    }).toList();
  }

  Map<String, dynamic>? _normalizeJobFromHistoryEntry(
    Map<String, dynamic> item,
  ) {
    final hasHistoryFields =
        item.containsKey('service_type') ||
        item.containsKey('problem_description') ||
        item.containsKey('estimated_cost') ||
        item.containsKey('status') ||
        item.containsKey('serviceDate') ||
        item.containsKey('description');
    if (!hasHistoryFields) return null;

    return {
      'id': _firstString([item['_id'], item['id']]),
      'serviceDate':
          item['serviceDate'] ??
          item['service_date'] ??
          item['createdAt'] ??
          item['created_at'] ??
          item['updatedAt'],
      'description': _firstString([
        item['description'],
        item['problem_description'],
        item['service_type'],
        item['notes'],
      ]),
      'mechanicName': _firstString([
        item['mechanicName'],
        item['mechanic_name'],
        item['mechanic'],
      ], defaultValue: 'N/A'),
      'mechanicProfile': _firstString([
        item['mechanicProfile'],
        item['mechanic_profile'],
        item['employeeProfile'],
      ], defaultValue: 'Mechanic'),
      'parts': _normalizeParts(item['parts']),
      'totalPrice': _asInt(
        item['totalPrice'] ??
            item['total_price'] ??
            item['estimated_cost'] ??
            item['cost'] ??
            item['amount'],
      ),
      'status': _asString(item['status'], defaultValue: 'pending'),
    };
  }

  List<Map<String, dynamic>> _normalizeParts(dynamic value) {
    if (value is! List) return [];
    return value.whereType<Map>().map((part) {
      return {
        'partName': _firstString([
          part['partName'],
          part['part_name'],
          part['name'],
        ], defaultValue: 'Part'),
        'cost': _asInt(part['cost'] ?? part['price'] ?? part['amount']),
      };
    }).toList();
  }

  String _vehicleKey(Map<String, dynamic> vehicle) {
    return _firstString([
      vehicle['vehicleNumber'],
      vehicle['registrationNumber'],
      vehicle['phoneNumber'],
      vehicle['customerName'],
    ], defaultValue: 'vehicle-${vehicle.hashCode}');
  }

  Color _statusColor(String status) {
    final value = status.toLowerCase();
    if (value.contains('complete') || value.contains('delivered')) {
      return Colors.green;
    }
    if (value.contains('progress')) return Colors.blue;
    if (value.contains('cancel')) return Colors.red;
    return Colors.orange;
  }

  String _formatDate(dynamic value) {
    final text = _asString(value);
    if (text.isEmpty) return 'N/A';
    final date = DateTime.tryParse(text)?.toLocal();
    if (date == null) return text;
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatAmount(dynamic value) {
    final amount = _asInt(value).toString();
    final buffer = StringBuffer();
    for (var i = 0; i < amount.length; i++) {
      final fromEnd = amount.length - i;
      buffer.write(amount[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
    }
    return buffer.toString();
  }

  int _asInt(dynamic value, {int defaultValue = 0}) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? defaultValue;
  }

  String _asString(dynamic value, {String defaultValue = ''}) {
    final text = value?.toString() ?? '';
    return text.isEmpty ? defaultValue : text;
  }

  String _firstString(List<dynamic> values, {String defaultValue = ''}) {
    for (final value in values) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty && text.toLowerCase() != 'null') return text;
    }
    return defaultValue;
  }
}
