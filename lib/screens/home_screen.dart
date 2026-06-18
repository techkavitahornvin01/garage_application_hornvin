// ignore_for_file: unused_element, unused_element_parameter

import 'dart:async';
import 'dart:convert';
import 'package:hornvin/localization/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/bottom_navi/bill_payment_screen.dart';
import 'package:hornvin/bottom_navi/job_history_screen.dart';
import 'package:hornvin/bottom_navi/scan_screen.dart';
import 'package:hornvin/models/job_model/job_model.dart';
import 'package:hornvin/repositories/garage_repository.dart';
import 'package:hornvin/repositories/job_repository.dart';
import 'package:hornvin/repositories/order_management_repository.dart';
import 'package:hornvin/screens/distributors_screen.dart';
import 'package:hornvin/screens/garage_sidebar.dart';
import 'package:hornvin/screens/help_support_screen.dart';
import 'package:hornvin/screens/shop_home_page.dart';
import 'package:hornvin/services/location_service.dart';
import 'package:hornvin/utils/friendly_error.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';
import 'package:hornvin/screens/garage_dashboard_page.dart';
import 'package:hornvin/screens/garage_orders_page.dart';
import 'package:hornvin/screens/garage_profile_page.dart';
import 'package:hornvin/screens/garage_tools_screen.dart';
import 'package:hornvin/screens/garage_wallet_page.dart';
import 'package:hornvin/screens/job_screen/job_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hornvin/screens/chat_screen.dart';
import 'package:hornvin/widgets/common_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String userRole = 'Garage';
  String userName = '';
  String userEmail = '';
  String currentLocationName = 'Location';
  bool _isDetectingLocation = false;
  final LocationService _locationService = LocationService();
  final GarageRepository _garageRepository = GarageRepository();

  @override
  void initState() {
    super.initState();
    _loadUserData().then((_) {
      if (mounted) {
        _setCurrentLocationFromDevice();
      }
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUser = _readStoredUser(prefs.getString('user_data'));
    final storedName = _firstText([
      prefs.getString('userName'),
      storedUser['name'],
      storedUser['full_name'],
      storedUser['fullName'],
      storedUser['businessName'],
      storedUser['business_name'],
    ], defaultValue: 'Garage Owner');
    final storedEmail = _firstText([
      prefs.getString('userEmail'),
      storedUser['email'],
      storedUser['phone'],
      storedUser['phoneNumber'],
    ], defaultValue: 'garage@example.com');
    final storedRole = _firstText([
      prefs.getString('userRole'),
      storedUser['role'],
    ], defaultValue: 'Garage');

    if (!mounted) return;
    setState(() {
      userRole = storedRole;
      userName = storedName;
      userEmail = storedEmail;
      currentLocationName =
          prefs.getString('selectedLocationName') ?? 'Location';
    });

    _refreshSidebarProfile(prefs);
  }

  Future<void> _refreshSidebarProfile(SharedPreferences prefs) async {
    try {
      final profile = await _garageRepository.getGarageProfile();
      final data = profile.data;
      final profileName = _firstText([
        data.name,
        data.full_name,
        data.businessName,
        data.business_name,
      ], defaultValue: userName);
      final profileEmail = _firstText([
        data.email,
        data.phoneNumber,
      ], defaultValue: userEmail);
      final profileRole = _firstText([data.role], defaultValue: userRole);

      await prefs.setString('userName', profileName);
      await prefs.setString('userEmail', profileEmail);
      await prefs.setString('userRole', profileRole);

      if (!mounted) return;
      setState(() {
        userName = profileName;
        userEmail = profileEmail;
        userRole = profileRole;
      });
    } catch (_) {
      // Sidebar still uses the login response values saved locally.
    }
  }

  Map<String, dynamic> _readStoredUser(String? raw) {
    if (raw == null || raw.trim().isEmpty) return {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return {};
  }

  String _firstText(List<dynamic> values, {String defaultValue = ''}) {
    for (final value in values) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty && text != 'null') return text;
    }
    return defaultValue;
  }

  Future<void> _setCurrentLocationFromDevice({bool showError = false}) async {
    if (_isDetectingLocation) return;

    setState(() => _isDetectingLocation = true);

    try {
      final selection = await _locationService.getCurrentLocation();
      if (!mounted) return;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedLocationName', selection.displayName);
      await prefs.setString('selectedLocationAddress', selection.address);
      await prefs.setDouble('selectedLocationLatitude', selection.latitude);
      await prefs.setDouble('selectedLocationLongitude', selection.longitude);

      if (mounted) {
        setState(() {
          currentLocationName = selection.displayName;
        });
      }

      final distributorsResponse = await _locationService
          .findNearestDistributors(
            latitude: selection.latitude,
            longitude: selection.longitude,
          );
      await prefs.setString(
        'nearestDistributorsResponse',
        jsonEncode(distributorsResponse),
      );
    } catch (error) {
      if (!mounted || !showError) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            friendlyErrorMessage(
              error,
              fallback: 'Location could not be updated. Please try again.',
            ),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isDetectingLocation = false);
      }
    }
  }

  List<Widget> get _bottomNavPages => [
    ShopHomePage(garageName: userName),
    const ChatScreen(),
    const JobListScreen(),
    const BillPaymentScreen(),
    const GarageWalletPage(),
  ];

  int get _safeSelectedIndex {
    final maxIndex = _bottomNavTitles.length - 1;
    if (_selectedIndex < 0) return 0;
    if (_selectedIndex > maxIndex) return 0;
    return _selectedIndex;
  }

  final List<String> _bottomNavTitles = [
    'home',
    'chat',
    'job_card',
    'payment',
    'wallet',
  ];

  final List<IconData> _bottomNavIcons = [
    Icons.home_outlined,
    Icons.chat_bubble_outline_rounded,
    Icons.explore_outlined,
    Icons.payments_outlined,
    Icons.account_balance_wallet_outlined,
  ];

  final List<IconData> _bottomNavActiveIcons = [
    Icons.home_rounded,
    Icons.chat_bubble_rounded,
    Icons.explore_outlined,
    Icons.payments_rounded,
    Icons.account_balance_wallet_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: GarageSidebarDrawer(
        userName: userName,
        userEmail: userEmail,
        userRole: userRole,
        selectedIndex: _safeSelectedIndex,
        onItemSelected: (index) {
          _handleDrawerNavigation(index);
        },
      ),
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: SizedBox.expand(
          child: KeyedSubtree(
            key: ValueKey('bottom-page-$_safeSelectedIndex'),
            child: _safeSelectedIndex == 4
                ? const GarageWalletPage()
                : _bottomNavPages[_safeSelectedIndex],
          ),
        ),
      ),
      bottomNavigationBar: _buildModernBottomNavigationBar(),
    );
  }

  void _handleDrawerNavigation(int index) {
    Navigator.pop(context); // Close drawer first
    Widget page;
    String title;

    switch (index) {
      case 0:
        setState(() => _selectedIndex = 0);
        return;
      case 1:
        setState(() => _selectedIndex = 1);
        return;
      case 2:
        setState(() => _selectedIndex = 3);
        return;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ScanScreen()),
        );
        return;
      case 4:
        page = const GarageOrdersPage();
        title = 'Service Orders';
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddPartsWorkbenchScreen()),
        );
        return;
      case 12:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DistributorsScreen()),
          );
        });
        return;
      case 6:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.textPrimary,
                  iconTheme: const IconThemeData(
                    color: AppColors.textPrimary,
                  ),
                  surfaceTintColor: Colors.white,
                  elevation: 0,
                  title: Text(
                    context.trText('Job History'),
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                body: const JobHistoryScreen(),
              ),
            ),
          );
        });
        return;
      case 7:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.textPrimary,
                iconTheme: const IconThemeData(color: AppColors.textPrimary),
                surfaceTintColor: Colors.white,
                elevation: 0,
                title: Text(
                  context.trText('garage_profile'),
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              body: const GarageProfileScreen(),
            ),
          ),
        );
        return;
      case 8:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ReportsAnalyticsScreen()),
        );
        return;
      case 9:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GarageSettingsScreen()),
        );
        return;
      case 10:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
        );
        return;
      case 11:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CustomersScreen()),
        );
        return;
      default:
        page = const GarageDashboardPage();
        title = 'Dashboard';
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.textPrimary,
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
            actionsIconTheme: const IconThemeData(color: AppColors.textPrimary),
            surfaceTintColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.textPrimary,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              context.trData(title),
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: page,
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.textPrimary,
      surfaceTintColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 154,
      leading: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AppBarButton(
                onTap: () => _scaffoldKey.currentState?.openDrawer(),
                child: Icon(
                  Icons.menu_rounded,
                  color: AppColors.textPrimary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 76,
                height: 36,
                child: Image.asset(
                  HornvinLogo.assetPath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.car_repair_rounded,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      title: const SizedBox.shrink(),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Center(
            child: _LocationAppBarButton(
              locationName: currentLocationName,
              isLoading: _isDetectingLocation,
              onTap: () => _setCurrentLocationFromDevice(showError: true),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernBottomNavigationBar() {
    final currentIndex = _safeSelectedIndex;
    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: SizedBox(
        height: 100,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth / _bottomNavTitles.length;
            final selectedCenterX = itemWidth * (currentIndex + 0.5);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 28,
                  bottom: 8,
                  child: CustomPaint(
                    painter: _BottomNavShapePainter(
                      selectedCenterX: selectedCenterX,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Row(
                    children: List.generate(_bottomNavTitles.length, (index) {
                      final isSelected = currentIndex == index;
                      return Expanded(
                        child: _BottomNavItem(
                          label: context.trText(_bottomNavTitles[index]),
                          icon: isSelected
                              ? _bottomNavActiveIcons[index]
                              : _bottomNavIcons[index],
                          isSelected: isSelected,
                          onTap: () => setState(() => _selectedIndex = index),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── APP BAR BUTTON ─────────────────────────────────────────────────────────
class _BottomNavShapePainter extends CustomPainter {
  final double selectedCenterX;

  const _BottomNavShapePainter({required this.selectedCenterX});

  @override
  void paint(Canvas canvas, Size size) {
    final shadowPaint = Paint()
      ..color = const Color(0xFF08112F).withValues(alpha: 0.10)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const cornerRadius = 16.0;
    const notchWidth = 82.0;
    const notchDepth = 25.0;
    final notchLeft = (selectedCenterX - notchWidth / 2).clamp(
      cornerRadius,
      size.width - cornerRadius,
    );
    final notchRight = (selectedCenterX + notchWidth / 2).clamp(
      cornerRadius,
      size.width - cornerRadius,
    );

    final barPath = Path()
      ..moveTo(cornerRadius, 0)
      ..lineTo(notchLeft, 0)
      ..cubicTo(
        selectedCenterX - 30,
        0,
        selectedCenterX - 31,
        notchDepth,
        selectedCenterX - 18,
        notchDepth,
      )
      ..lineTo(selectedCenterX + 18, notchDepth)
      ..cubicTo(
        selectedCenterX + 31,
        notchDepth,
        selectedCenterX + 30,
        0,
        notchRight,
        0,
      )
      ..lineTo(size.width - cornerRadius, 0)
      ..quadraticBezierTo(size.width, 0, size.width, cornerRadius)
      ..lineTo(size.width, size.height - cornerRadius)
      ..quadraticBezierTo(
        size.width,
        size.height,
        size.width - cornerRadius,
        size.height,
      )
      ..lineTo(cornerRadius, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - cornerRadius)
      ..lineTo(0, cornerRadius)
      ..quadraticBezierTo(0, 0, cornerRadius, 0)
      ..close();

    canvas.drawPath(barPath.shift(const Offset(0, 8)), shadowPaint);
    canvas.drawPath(barPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _BottomNavShapePainter oldDelegate) {
    return oldDelegate.selectedCenterX != selectedCenterX;
  }
}

class _BottomNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = AppColors.primary;
    final inactiveColor = const Color(0xFF8B8D93);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              top: isSelected ? 0 : 42,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                width: isSelected ? 62 : 28,
                height: isSelected ? 62 : 28,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: const Color(0xFFE7E9EF), width: 1.2)
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFF08112F,
                            ).withValues(alpha: 0.14),
                            blurRadius: 16,
                            offset: const Offset(0, 7),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? selectedColor : inactiveColor,
                  size: isSelected ? 28 : 24,
                ),
              ),
            ),
            Positioned(
              left: 2,
              right: 2,
              bottom: 22,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 10.5,
                  height: 1,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? const Color(0xFF3D3D3D) : inactiveColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBarButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  const _AppBarButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppColors.divider),
        ),
        child: child,
      ),
    );
  }
}

// ─── HOME PAGE CONTENT ───────────────────────────────────────────────────────
class _LocationAppBarButton extends StatelessWidget {
  final String locationName;
  final VoidCallback onTap;
  final bool isLoading;

  const _LocationAppBarButton({
    required this.locationName,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = locationName.trim().isEmpty ? 'Location' : locationName;
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        constraints: const BoxConstraints(minWidth: 128, maxWidth: 168),
        height: 46,
        padding: const EdgeInsets.fromLTRB(9, 6, 8, 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isLoading
                ? AppColors.primary.withValues(alpha: 0.34)
                : AppColors.divider,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.045),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                    : const Icon(
                        Icons.location_on_rounded,
                        color: AppColors.primary,
                        size: 19,
                      ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.trText(isLoading ? 'Detecting' : 'Current area'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                      fontSize: 8.5,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    context.trData(displayName),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                      fontSize: 11,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.grey.withValues(alpha: 0.9),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  static const List<String> _bannerImages = [
    'assets/catalog/home_dashboard_banner.png',
    'assets/catalog/home_dashboard_banner.png',
    'assets/catalog/home_dashboard_banner.png',
  ];

  final PageController _bannerController = PageController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _bannerTimer;
  int _bannerIndex = 0;
  String _homeSearchQuery = '';

  final JobRepository _jobRepository = JobRepository();
  final OrderManagementRepository _orderRepository =
      OrderManagementRepository();

  List<Job> _activeJobs = [];
  List<Map<String, dynamic>> _recentOrders = [];
  bool _isLoadingJobs = true;
  bool _isLoadingOrders = true;
  String? _jobsError;
  String? _ordersError;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || _bannerImages.length <= 1) return;
      _bannerIndex = (_bannerIndex + 1) % _bannerImages.length;
      _bannerController.animateToPage(
        _bannerIndex,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHomeData() async {
    await Future.wait([_loadActiveJobs(), _loadRecentOrders()]);
  }

  Future<void> _loadActiveJobs() async {
    if (mounted) {
      setState(() {
        _isLoadingJobs = true;
        _jobsError = null;
      });
    }

    try {
      final response = await _jobRepository.getAllJobs(page: 1, limit: 10);
      final activeJobs = response.jobs
          .where((job) => !_isClosedJob(job.status))
          .take(3)
          .toList();
      if (!mounted) return;
      setState(() {
        _activeJobs = activeJobs;
        _isLoadingJobs = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _jobsError = friendlyErrorMessage(
          error,
          fallback:
              'Active jobs could not be loaded right now. Please try again.',
        );
        _isLoadingJobs = false;
      });
    }
  }

  Future<void> _loadRecentOrders() async {
    if (mounted) {
      setState(() {
        _isLoadingOrders = true;
        _ordersError = null;
      });
    }

    try {
      final result = await _orderRepository.getOrders();
      final orders = result.map(_normalizeOrder).take(4).toList();
      if (!mounted) return;
      setState(() {
        _recentOrders = orders;
        _isLoadingOrders = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _ordersError = _friendlyOrderError(error);
        _isLoadingOrders = false;
      });
    }
  }

  void _openOrdersPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.textPrimary,
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
            actionsIconTheme: const IconThemeData(color: AppColors.textPrimary),
            surfaceTintColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.textPrimary,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              context.trText('Order List'),
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: const GarageOrdersPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: RefreshIndicator(
        onRefresh: _loadHomeData,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHomeHeader(context),
              _HomeBannerCarousel(
                images: _bannerImages,
                controller: _bannerController,
                currentIndex: _bannerIndex,
                onPageChanged: (index) => setState(() => _bannerIndex = index),
              ),

              _sectionHeader(context.trText('All Categories')),
              _buildCategoryCommandCenter(context),

              // ── Today's Summary ─────────────────────────────────────────────
              _sectionHeader('todays_summary'),
              _buildPerformancePanel(context),

              // ── Revenue Card ─────────────────────────────────────────────────
              _buildWorkshopInsights(context),

              // ── Quick Actions ─────────────────────────────────────────────────
              _sectionHeader(context.trText('Other Services')),
              _buildServiceToolkit(context),

              // ── Active Jobs ───────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('active_jobs'),
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/job-list'),
                      child: Text(
                        context.tr('view_all'),
                        style: GoogleFonts.lato(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              ..._buildActiveJobs(context),

              // ── Recent Orders ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('recent_orders'),
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _openOrdersPage(context),
                      child: Text(
                        context.tr('view_all'),
                        style: GoogleFonts.lato(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              ..._buildRecentOrders(context),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCommandCenter(BuildContext context) {
    final categories = [
      _CategoryStripItem(
        icon: Icons.assignment_rounded,
        title: context.trText('Jobs'),
        meta: '${_activeJobs.length} ${context.trText('Active')}',
        color: AppColors.secondary,
        onTap: () => Navigator.pushNamed(context, '/job-list'),
      ),
      _CategoryStripItem(
        icon: Icons.receipt_long_rounded,
        title: context.trText('Orders'),
        meta: '${_recentOrders.length} ${context.trText('Recent')}',
        color: AppColors.warning,
        onTap: () => _openOrdersPage(context),
      ),
      _CategoryStripItem(
        icon: Icons.handyman_outlined,
        title: context.trText('Spare Parts'),
        meta: context.trText('Products'),
        color: AppColors.primary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddPartsWorkbenchScreen()),
        ),
      ),
      _CategoryStripItem(
        icon: Icons.chat_bubble_outline_rounded,
        title: context.trText('Chat'),
        meta: context.trText('Support'),
        color: AppColors.success,
        onTap: () => Navigator.pushNamed(context, '/HornvinChatScreen'),
      ),
    ];

    return SizedBox(
      height: 84,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => categories[index],
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemCount: categories.length,
      ),
    );
  }

  Widget _buildPerformancePanel(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8EDF4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _SummaryLineMetric(
                  title: context.trText('total_orders'),
                  value: _recentOrders.length.toString(),
                  icon: Icons.shopping_bag_outlined,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryLineMetric(
                  title: context.trText('completed'),
                  value: _completedOrdersCount.toString(),
                  icon: Icons.verified_rounded,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryLineMetric(
                  title: context.trText('pending'),
                  value: _pendingOrdersCount.toString(),
                  icon: Icons.hourglass_top_rounded,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkshopInsights(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF161C2D),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF161C2D).withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.white,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr("todays_revenue"),
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.70),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Rs ${_formatAmount(_todayRevenue)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          _RevenueMiniPill(
            label: context.trText('Active jobs'),
            value: _activeJobs.length.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceToolkit(BuildContext context) {
    final actions = [
      _ToolkitActionData(
        title: 'order_list',
        icon: Icons.receipt_long_rounded,
        color: AppColors.primary,
        onTap: () => _openOrdersPage(context),
      ),
      _ToolkitActionData(
        title: 'add_parts',
        icon: Icons.add_box_outlined,
        color: AppColors.accent,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddPartsWorkbenchScreen()),
        ),
      ),
      _ToolkitActionData(
        title: 'scan_qr',
        icon: Icons.qr_code_scanner_rounded,
        color: AppColors.secondary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ScanScreen()),
        ),
      ),
      _ToolkitActionData(
        title: 'invoice',
        icon: Icons.request_quote_outlined,
        color: AppColors.success,
        onTap: () => _showInvoiceActions(context),
      ),
      _ToolkitActionData(
        title: 'distributors',
        icon: Icons.storefront_rounded,
        color: AppColors.secondaryLight,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DistributorsScreen()),
        ),
      ),
      _ToolkitActionData(
        title: 'customers',
        icon: Icons.people_alt_rounded,
        color: AppColors.primary,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CustomersScreen()),
        ),
      ),
      _ToolkitActionData(
        title: 'report',
        icon: Icons.insights_rounded,
        color: AppColors.warning,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ReportsAnalyticsScreen()),
        ),
      ),
      _ToolkitActionData(
        title: 'schedule',
        icon: Icons.calendar_month_rounded,
        color: const Color(0xFF7C3AED),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ScheduleScreen()),
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: actions.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          mainAxisExtent: 96,
        ),
        itemBuilder: (context, index) => _ToolkitAction(action: actions[index]),
      ),
    );
  }

  Widget _buildHomeHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.trText('Welcome'),
                      style: GoogleFonts.lato(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      context.trText('Manage your garage services'),
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) =>
                      setState(() => _homeSearchQuery = value),
                  textInputAction: TextInputAction.search,
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: context.trText('Search jobs, orders, vehicle...'),
                    hintStyle: GoogleFonts.lato(
                      fontSize: 12,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.grey,
                      size: 20,
                    ),
                    suffixIcon: _homeSearchQuery.trim().isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: AppColors.grey,
                              size: 18,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _homeSearchQuery = '');
                            },
                          ),
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 13,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActiveJobs(BuildContext context) {
    if (_isLoadingJobs) {
      return List.generate(2, (_) => _buildLoadingCard());
    }
    if (_jobsError != null) {
      return [
        _buildInlineState(
          icon: Icons.cloud_off_rounded,
          title: context.trText('Active jobs could not be loaded'),
          message: 'Pull down karke refresh karein.',
          onRetry: _loadActiveJobs,
        ),
      ];
    }
    if (_activeJobs.isEmpty) {
      return [
        _buildInlineState(
          icon: Icons.assignment_turned_in_rounded,
          title: context.trText('No active jobs'),
          message: 'Naye active jobs API se aate hi yaha dikhne lagenge.',
        ),
      ];
    }
    if (_filteredActiveJobs.isEmpty) {
      return [
        _buildInlineState(
          icon: Icons.search_off_rounded,
          title: context.trText('No matching active jobs'),
          message: 'Search text change karke dubara try karein.',
        ),
      ];
    }

    return _filteredActiveJobs.map((job) {
      final progress = _jobProgress(job.status);
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.directions_car_rounded,
                    color: AppColors.secondary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.customerName.isNotEmpty
                            ? job.customerName
                            : 'Customer',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${_vehicleTitle(job)} - ${_serviceTitle(job)}',
                        style: GoogleFonts.lato(
                          fontSize: 11,
                          color: AppColors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    _statusLabel(job.status),
                    style: GoogleFonts.lato(
                      fontSize: 10,
                      color: AppColors.warning,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 15,
                    color: AppColors.grey,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'Mechanic: ${job.mechanicName.isNotEmpty ? job.mechanicName : 'Not assigned'}',
                      style: GoogleFonts.lato(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: GoogleFonts.lato(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildRecentOrders(BuildContext context) {
    if (_isLoadingOrders) {
      return List.generate(3, (_) => _buildLoadingCard(compact: true));
    }
    if (_ordersError != null) {
      return [
        _buildInlineState(
          icon: Icons.receipt_long_outlined,
          title: context.trText('Recent orders could not be loaded'),
          message: _ordersError!,
          onRetry: _loadRecentOrders,
        ),
      ];
    }
    if (_recentOrders.isEmpty) {
      return [
        _buildInlineState(
          icon: Icons.inventory_2_outlined,
          title: context.trText('No recent orders'),
          message: 'Order API se data aate hi yaha list update hogi.',
        ),
      ];
    }
    if (_filteredRecentOrders.isEmpty) {
      return [
        _buildInlineState(
          icon: Icons.search_off_rounded,
          title: context.trText('No matching orders'),
          message: 'Order, distributor ya product ka naam search karein.',
        ),
      ];
    }

    final orders = _filteredRecentOrders;
    /*
    final orders = [
      {
        'id': '#ORD1000',
        'car': 'Toyota Camry',
        'service': 'Engine Repair',
        'amount': '₹7,500',
        'status': 'In Progress',
        'isActive': true,
      },
      {
        'id': '#ORD999',
        'car': 'Hyundai Creta',
        'service': 'Oil Change',
        'amount': '₹2,500',
        'status': 'Completed',
        'isActive': false,
      },
      {
        'id': '#ORD998',
        'car': 'Tata Nexon',
        'service': 'Tyre Replacement',
        'amount': '₹5,000',
        'status': 'Completed',
        'isActive': false,
      },
    ];

    */
    return orders.map((order) {
      final statusColor = _orderStatusColor(order['status']);
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.car_repair_rounded,
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
                    _shortId(order['id']),
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${order['vehicle']} - ${order['service']}',
                    style: GoogleFonts.lato(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: AppColors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _asString(order['date']),
                          style: GoogleFonts.lato(
                            fontSize: 10,
                            color: AppColors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rs ${_formatAmount(order['amount'])}',
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    _statusLabel(order['status'] as String),
                    style: GoogleFonts.lato(
                      fontSize: 10,
                      color: statusColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _sectionHeader(String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.trData(title),
              style: GoogleFonts.lato(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (onTap != null)
            TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                minimumSize: const Size(0, 34),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Text(
                context.tr('view_all'),
                style: GoogleFonts.lato(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard({bool compact = false}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: EdgeInsets.all(compact ? 14 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _loadingLine(width: 150),
                const SizedBox(height: 8),
                _loadingLine(width: 210, height: 9),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingLine({required double width, double height = 12}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildInlineState({
    required IconData icon,
    required String title,
    required String message,
    VoidCallback? onRetry,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.secondary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.trData(title),
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.trData(message),
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (onRetry != null)
            IconButton(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: AppColors.primary),
              tooltip: 'Retry',
            ),
        ],
      ),
    );
  }

  Map<String, dynamic> _normalizeOrder(Map<String, dynamic> order) {
    final customer = order['customer'];
    final vehicle = order['vehicle'];
    final items = order['items'];
    return {
      ...order,
      'id': _asString(order['_id'] ?? order['id'] ?? order['orderId']),
      'customer': customer is Map
          ? _asString(customer['name'] ?? customer['fullName'])
          : _asString(
              order['customerName'] ?? order['garageName'] ?? 'Customer',
            ),
      'service': items is List && items.isNotEmpty
          ? '${items.length} spare part${items.length == 1 ? '' : 's'}'
          : _asString(
              order['service'] ?? order['description'] ?? 'Garage order',
            ),
      'vehicle': vehicle is Map
          ? _asString(vehicle['vehicleNumber'] ?? vehicle['model'])
          : _asString(order['vehicleNumber'] ?? order['vehicle'] ?? 'N/A'),
      'date': _formatDate(order['createdAt'] ?? order['date']),
      'status': _statusText(order['status']),
      'amount': _asInt(
        order['totalAmount'] ?? order['amount'] ?? order['total'],
      ),
    };
  }

  bool _isClosedJob(String status) {
    final value = status.toLowerCase();
    return value.contains('complete') ||
        value.contains('cancel') ||
        value.contains('closed') ||
        value.contains('delivered');
  }

  double _jobProgress(String status) {
    final value = status.toLowerCase();
    if (value.contains('progress') || value.contains('working')) return 0.65;
    if (value.contains('accept') || value.contains('assign')) return 0.45;
    if (value.contains('pending')) return 0.2;
    return 0.35;
  }

  String _statusLabel(String status) {
    final value = status.trim().isEmpty ? 'Pending' : status.trim();
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  String _vehicleTitle(Job job) {
    final model = job.vehicleModel.trim();
    final number = job.vehicleNumber.trim();
    if (model.isNotEmpty && number.isNotEmpty) return '$model ($number)';
    if (model.isNotEmpty) return model;
    if (number.isNotEmpty) return number;
    return 'Vehicle';
  }

  String _serviceTitle(Job job) {
    if (job.description.trim().isNotEmpty) return job.description.trim();
    if (job.parts.isNotEmpty) {
      return '${job.parts.length} part${job.parts.length == 1 ? '' : 's'}';
    }
    return 'Garage service';
  }

  int get _completedOrdersCount => _recentOrders
      .where((order) => _statusBucket(order['status']) == 'completed')
      .length;

  int get _pendingOrdersCount => _recentOrders
      .where((order) => _isActiveOrderStatus(order['status']))
      .length;

  int get _todayRevenue =>
      _recentOrders.fold<int>(0, (sum, order) => sum + _asInt(order['amount']));

  String _statusText(dynamic value) {
    final status = _asString(value).trim();
    return status.isEmpty ? 'Pending' : status;
  }

  String _statusBucket(dynamic value) {
    final status = _statusText(value).toLowerCase();
    if (status.contains('progress') || status.contains('accept')) {
      return 'in_progress';
    }
    if (status.contains('complete') || status.contains('delivered')) {
      return 'completed';
    }
    if (status.contains('cancel') || status.contains('reject')) {
      return 'cancelled';
    }
    return 'pending';
  }

  bool _isActiveOrderStatus(dynamic value) {
    final bucket = _statusBucket(value);
    return bucket == 'pending' || bucket == 'in_progress';
  }

  Color _orderStatusColor(dynamic value) {
    switch (_statusBucket(value)) {
      case 'completed':
        return AppColors.success;
      case 'in_progress':
        return Colors.blue.shade700;
      case 'cancelled':
        return Colors.red.shade700;
      default:
        return AppColors.warning;
    }
  }

  String _friendlyOrderError(Object error) {
    final text = error.toString().toLowerCase();
    if (text.contains('socket') ||
        text.contains('network') ||
        text.contains('connection') ||
        text.contains('timeout')) {
      return 'We could not refresh recent orders. Please check your internet connection and try again.';
    }
    if (text.contains('401') || text.contains('unauthorized')) {
      return 'Your session has expired. Please sign in again to view orders.';
    }
    if (text.contains('500') || text.contains('server')) {
      return 'The order service is temporarily unavailable. Please try again in a moment.';
    }
    return 'Recent orders could not be loaded right now. Please try again.';
  }

  String _formatDate(dynamic value) {
    final text = _asString(value);
    if (text.isEmpty) return 'N/A';
    final date = DateTime.tryParse(text);
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

  String _shortId(dynamic value) {
    final id = _asString(value);
    if (id.isEmpty) return '#ORDER';
    final visible = id.length > 6 ? id.substring(id.length - 6) : id;
    return '#${visible.toUpperCase()}';
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _asString(dynamic value) => value?.toString() ?? '';

  List<Job> get _filteredActiveJobs {
    final query = _homeSearchQuery.trim().toLowerCase();
    if (query.isEmpty) return _activeJobs;
    return _activeJobs.where((job) {
      return [
        job.customerName,
        job.vehicleNumber,
        job.vehicleModel,
        job.mechanicName,
        job.description,
        job.jobCardId,
      ].any((value) => value.toLowerCase().contains(query));
    }).toList();
  }

  List<Map<String, dynamic>> get _filteredRecentOrders {
    final query = _homeSearchQuery.trim().toLowerCase();
    if (query.isEmpty) return _recentOrders;
    return _recentOrders.where((order) {
      return [
        order['id'],
        order['orderNumber'],
        order['distributorName'],
        order['title'],
        order['status'],
      ].any((value) => _asString(value).toLowerCase().contains(query));
    }).toList();
  }

  void _showInvoiceActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.receipt_long_rounded),
                  title: Text(context.tr('view_invoices')),
                  subtitle: Text(
                    context.trText('See invoice API response and actions'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/view_invoices');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HomeBannerCarousel extends StatelessWidget {
  final List<String> images;
  final PageController controller;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const _HomeBannerCarousel({
    required this.images,
    required this.controller,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8EDF4), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: AspectRatio(
          aspectRatio: 16 / 7,
          child: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                controller: controller,
                itemCount: images.length,
                onPageChanged: onPageChanged,
                itemBuilder: (context, index) {
                  return Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.10),
                            AppColors.secondary.withValues(alpha: 0.08),
                            const Color(0xFFF8FAFC),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image_outlined,
                        color: AppColors.primary.withValues(alpha: 0.42),
                        size: 36,
                      ),
                    ),
                  );
                },
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.04),
                        Colors.black.withValues(alpha: 0.22),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.38),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(23),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 12,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.22),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(images.length, (index) {
                        final active = index == currentIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: active ? 20 : 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: active
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.52),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryStripItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String meta;
  final Color color;
  final VoidCallback onTap;

  const _CategoryStripItem({
    required this.icon,
    required this.title,
    required this.meta,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 128,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE8EDF4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 14,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 19),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryLineMetric extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryLineMetric({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 19),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RevenueMiniPill extends StatelessWidget {
  final String label;
  final String value;

  const _RevenueMiniPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.13)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCommandCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCommandCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE8EDF4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.045),
                blurRadius: 18,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.11),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_outward_rounded,
                    color: color.withValues(alpha: 0.86),
                    size: 19,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8EDF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DarkInsightChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DarkInsightChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.13)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lato(
                fontSize: 10,
                color: Colors.white.withValues(alpha: 0.76),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolkitActionData {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _ToolkitActionData({
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
  });
}

class _ToolkitAction extends StatelessWidget {
  final _ToolkitActionData action;

  const _ToolkitAction({required this.action});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE8EDF4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.030),
                blurRadius: 14,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: action.color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(action.icon, color: action.color, size: 21),
              ),
              const SizedBox(height: 8),
              Text(
                context.trData(action.title),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: 112,
          height: 112,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.045),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: color, size: 21),
                  ),
                  const Spacer(),
                  Container(
                    width: 26,
                    height: 24,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: color,
                      size: 14,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── MINI CHIP ───────────────────────────────────────────────────────────────
// ─── STAT CARD ───────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 112),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(height: 12),
          Text(
            context.trData(value),
            style: GoogleFonts.lato(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            context.trData(title),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
              fontSize: 10.5,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── QUICK ACTION ─────────────────────────────────────────────────────────────
class _QuickAction extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  const _QuickAction({
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 6),
              Text(
                context.trData(title),
                style: GoogleFonts.lato(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
