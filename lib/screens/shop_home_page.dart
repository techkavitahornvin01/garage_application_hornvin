import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hornvin/controllers/order_management_controller.dart';
import 'package:hornvin/models/order_management_model.dart';
import 'package:hornvin/repositories/order_management_repository.dart';
import 'package:hornvin/screens/garage_cart_page.dart';
import 'package:hornvin/screens/garage_products_page.dart';
import 'package:hornvin/services/location_service.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopHomePage extends StatefulWidget {
  final String garageName;

  const ShopHomePage({super.key, required this.garageName});

  @override
  State<ShopHomePage> createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {
  static const _ink = Color(0xFF061039);
  static const _muted = Color(0xFF626B8B);
  static const _line = Color(0xFFE6EAF2);
  static const _soft = Color(0xFFF7F8FC);
  static const _red = Color(0xFFF00620);
  static const _green = Color(0xFF008F45);
  static const _allCategory = 'All';
  static const _allVehicleType = 'All';

  final TextEditingController _searchController = TextEditingController();
  final PageController _bannerController = PageController();
  final LocationService _locationService = LocationService();
  final OrderManagementRepository _orderRepository = OrderManagementRepository();
  final Set<String> _wishlist = <String>{};
  Timer? _bannerTimer;
  List<_HomeProduct> _distributorProducts = const [];
  bool _isLoadingDistributorProducts = true;
  String? _distributorMessage;
  String _selectedCategory = _allCategory;
  String _selectedVehicleType = _allVehicleType;
  _SortMode _sortMode = _SortMode.popular;
  int _activeBannerIndex = 0;

  late final List<_HomeProduct> _fallbackProducts = [
    const _HomeProduct(
      name: 'Hornvin 10W30',
      subtitle: 'Hornvin Synthetic Engine Oil',
      meta: 'API SN  |  JASO MA2',
      rating: '4.8 (125)',
      unit: '1 Litre',
      price: '599',
      oldPrice: '750',
      off: '20% OFF',
      image: 'assets/catalog/prod_oil_black.png',
      category: 'Engine Oil',
      vehicleType: '2W',
      ratingValue: 4.8,
      popularity: 1,
    ),
    const _HomeProduct(
      name: 'Hornvin 20W40',
      subtitle: 'Hornvin Premium Engine Oil',
      meta: 'API SN  |  JASO MA2',
      rating: '4.6 (98)',
      unit: '1 Litre',
      price: '650',
      oldPrice: '810',
      off: '20% OFF',
      image: 'assets/catalog/prod_oil_gold.png',
      category: 'Engine Oil',
      vehicleType: '2W',
      ratingValue: 4.6,
      popularity: 2,
    ),
    const _HomeProduct(
      name: 'Hornvin 3W Engine Oil',
      subtitle: 'Hornvin Auto Rickshaw Oil',
      meta: '3W  |  Heavy Duty',
      rating: '4.7 (82)',
      unit: '1 Litre',
      price: '620',
      oldPrice: '780',
      off: '20% OFF',
      image: 'assets/catalog/prod_oil_gold.png',
      category: 'Engine Oil',
      vehicleType: '3W',
      ratingValue: 4.7,
      popularity: 3,
    ),
    const _HomeProduct(
      name: 'Hornvin 2W Brake Pad Set',
      subtitle: 'Hornvin Front Brake Pad',
      meta: 'Hornvin Premium Quality',
      rating: '4.7 (64)',
      unit: '1 Set',
      price: '450',
      oldPrice: '550',
      off: '18% OFF',
      image: 'assets/home_ref/prod_brake_pad.png',
      category: 'Spare Parts',
      vehicleType: '2W',
      ratingValue: 4.7,
      popularity: 4,
    ),
    const _HomeProduct(
      name: 'Hornvin 2W Air Filter',
      subtitle: 'Hornvin Scooter Air Filter',
      meta: 'Hornvin High Performance',
      rating: '4.7 (78)',
      unit: '1 Pc',
      price: '180',
      oldPrice: '220',
      off: '18% OFF',
      image: 'assets/home_ref/prod_air_filter.png',
      category: 'Filters',
      vehicleType: '2W',
      ratingValue: 4.7,
      popularity: 5,
    ),
    const _HomeProduct(
      name: 'Hornvin 3W Spark Plug',
      subtitle: 'Hornvin Iridium Technology',
      meta: 'Hornvin High Performance',
      rating: '4.6 (64)',
      unit: '1 Pc',
      price: '120',
      oldPrice: '150',
      off: '20% OFF',
      image: 'assets/home_ref/prod_spark_plug.png',
      category: 'Spare Parts',
      vehicleType: '3W',
      ratingValue: 4.6,
      popularity: 6,
    ),
    const _HomeProduct(
      name: 'Hornvin 3W Power Oil',
      subtitle: 'Hornvin 4T Synthetic Technology',
      meta: '3W  |  API SN',
      rating: '4.5 (70)',
      unit: '1 Litre',
      price: '699',
      oldPrice: '850',
      off: '18% OFF',
      image: 'assets/catalog/prod_oil_black.png',
      category: 'Engine Oil',
      vehicleType: '3W',
      ratingValue: 4.5,
      popularity: 7,
    ),
  ];

  late final List<_PromoBanner> _promoBanners = [
    const _PromoBanner(
      title: 'HORNVIN OILS',
      subtitle: '2W & 3W engine protection',
      action: 'SHOP NOW',
      badge: '20%\nOFF',
      colors: [Color(0xFF061039), Color(0xFF101E4F)],
      images: [
        'assets/home_ref/hornvin_oil_black_transparent.png',
        'assets/home_ref/hornvin_oil_gold_transparent.png',
        'assets/home_ref/hornvin_oil_black_transparent.png',
        'assets/home_ref/hornvin_oil_gold_transparent.png',
      ],
      category: _allCategory,
    ),
    const _PromoBanner(
      title: '2W SERVICE PARTS',
      subtitle: 'Brake pads, filters and fast moving spares',
      action: 'EXPLORE',
      badge: 'BEST\nSELLER',
      colors: [Color(0xFF7A1018), Color(0xFFE31E24)],
      images: [
        'assets/catalog/scooter.png',
        'assets/home_ref/prod_brake_pad.png',
        'assets/home_ref/prod_air_filter.png',
      ],
      category: 'Spare Parts',
    ),
    const _PromoBanner(
      title: 'TYRES & BATTERY',
      subtitle: 'Daily essentials for workshop orders',
      action: 'VIEW ALL',
      badge: 'QUICK\nBUY',
      colors: [Color(0xFF0B3D2E), Color(0xFF008F45)],
      images: [
        'assets/home_ref/cat_tyres.png',
        'assets/home_ref/cat_battery.png',
        'assets/home_ref/cat_filters.png',
      ],
      category: _allCategory,
    ),
  ];

  List<_HomeProduct> get _products =>
      _distributorProducts.isNotEmpty ? _distributorProducts : _fallbackProducts;

  @override
  void initState() {
    super.initState();
    _loadDistributorProducts();
    _startBannerAutoScroll();
  }

  void _startBannerAutoScroll() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_bannerController.hasClients) return;
      final nextIndex = (_activeBannerIndex + 1) % _promoBanners.length;
      _bannerController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  List<_HomeProduct> get _visibleProducts {
    final query = _searchController.text.trim().toLowerCase();
    final products = _products.where((product) {
      final matchesQuery =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.subtitle.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          product.vehicleType.toLowerCase().contains(query) ||
          product.meta.toLowerCase().contains(query);
      final matchesCategory =
          _selectedCategory == _allCategory ||
          product.category == _selectedCategory;
      final matchesVehicleType =
          _selectedVehicleType == _allVehicleType ||
          product.vehicleType == _selectedVehicleType;
      return matchesQuery && matchesCategory && matchesVehicleType;
    }).toList();

    switch (_sortMode) {
      case _SortMode.priceLow:
        products.sort((a, b) => a.priceValue.compareTo(b.priceValue));
        break;
      case _SortMode.priceHigh:
        products.sort((a, b) => b.priceValue.compareTo(a.priceValue));
        break;
      case _SortMode.rating:
        products.sort((a, b) => b.ratingValue.compareTo(a.ratingValue));
        break;
      case _SortMode.popular:
        products.sort((a, b) => a.popularity.compareTo(b.popularity));
        break;
    }
    return products;
  }

  Future<void> _loadDistributorProducts() async {
    setState(() {
      _isLoadingDistributorProducts = true;
      _distributorMessage = null;
    });

    try {
      final distributors = await _loadDistributors();
      final products = <_HomeProduct>[];
      final seenKeys = <String>{};

      for (final distributor in distributors) {
        final distributorId = _distributorId(distributor);
        if (distributorId.isEmpty) continue;

        final distributorName = _distributorName(distributor);
        final response = await _orderRepository.getProductResponse(
          distributorId: distributorId,
          limit: 12,
        );

        for (final product in response.products) {
          final uniqueKey = '${product.distributorId}|${product.cartKey}';
          if (!seenKeys.add(uniqueKey)) continue;
          products.add(
            _HomeProduct.fromOrderProduct(
              product,
              distributorName: distributorName,
              popularity: products.length + 1,
            ),
          );
          if (products.length >= 18) break;
        }

        if (products.length >= 18) break;
      }

      if (!mounted) return;
      setState(() {
        _distributorProducts = products;
        if (products.isEmpty) {
          _distributorMessage = 'Distributor products not available right now';
        }
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _distributorProducts = const [];
        _distributorMessage = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingDistributorProducts = false);
      }
    }
  }

  Future<List<Map<String, dynamic>>> _loadDistributors() async {
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
        (response == null || _extractDistributorList(response).isEmpty)) {
      final selection = await _locationService.getCurrentLocation();
      latitude = selection.latitude;
      longitude = selection.longitude;
      await prefs.setString('selectedLocationName', selection.displayName);
      await prefs.setString('selectedLocationAddress', selection.address);
      await prefs.setDouble('selectedLocationLatitude', selection.latitude);
      await prefs.setDouble('selectedLocationLongitude', selection.longitude);
    }

    if ((response == null || _extractDistributorList(response).isEmpty) &&
        latitude != null &&
        longitude != null) {
      response = await _locationService.findNearestDistributors(
        latitude: latitude,
        longitude: longitude,
      );
      await prefs.setString('nearestDistributorsResponse', jsonEncode(response));
    }

    return _extractDistributorList(response);
  }

  List<Map<String, dynamic>> _extractDistributorList(Object? value) {
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
        final nested = _extractDistributorList(map[key]);
        if (nested.isNotEmpty) return nested;
      }
    }

    return const [];
  }

  Map<String, dynamic> _nestedDistributorMap(Map<String, dynamic> data) {
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

  String _distributorId(Map<String, dynamic> distributor) {
    final nestedDistributor = _nestedDistributorMap(distributor);
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

  String _distributorName(Map<String, dynamic> data) {
    final distributor = _nestedDistributorMap(data);
    return distributor['name']?.toString() ??
        distributor['full_name']?.toString() ??
        distributor['business_name']?.toString() ??
        data['name']?.toString() ??
        'Distributor';
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  TextStyle _font({
    double size = 12,
    FontWeight weight = FontWeight.w600,
    Color color = _ink,
    double height = 1.14,
  }) {
    return AppTheme.lato(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 112),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchRow(),
            const SizedBox(height: 12),
            _categoryRail(context),
            const SizedBox(height: 14),
            _promoBanner(context),
            const SizedBox(height: 10),
            _dots(),
            const SizedBox(height: 14),
            _topHeader(),
            const SizedBox(height: 10),
            _productGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _searchRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDDE2EF)),
              boxShadow: [
                BoxShadow(
                  color: _ink.withValues(alpha: 0.030),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF737A9D),
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    style: _font(
                      size: 12.5,
                      weight: FontWeight.w700,
                      color: _ink,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Search Parts, Oils, Vehicles...',
                      hintStyle: _font(
                        size: 12.5,
                        weight: FontWeight.w700,
                        color: _muted,
                      ),
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF737A9D),
                      size: 18,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Material(
          color: const Color(0xFFFFEDF1),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _showFilterSheet,
            child: const SizedBox(
              width: 52,
              height: 52,
              child: Icon(Icons.tune_rounded, color: _red, size: 22),
            ),
          ),
        ),
      ],
    );
  }

  Widget _categoryRail(BuildContext context) {
    final categories = [
      const _CategoryItem('Engine Oil', 'assets/home_ref/cat_engine_oil.png'),
      const _CategoryItem('Spare Parts', 'assets/home_ref/cat_spare_parts.png'),
      const _CategoryItem('Battery', 'assets/home_ref/cat_battery.png'),
      const _CategoryItem('Tyres', 'assets/home_ref/cat_tyres.png'),
      const _CategoryItem('Filters', 'assets/home_ref/cat_filters.png'),
      const _CategoryItem('View All', null),
    ];

    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final item = categories[index];
          final isViewAll = item.asset == null;
          final isSelected =
              _selectedCategory == item.title ||
              (isViewAll && _selectedCategory == _allCategory);
          return Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => setState(
                () => _selectedCategory = isViewAll ? _allCategory : item.title,
              ),
              child: SizedBox(
                width: 66,
                child: Column(
                  children: [
                    Container(
                      width: 62,
                      height: 58,
                      decoration: BoxDecoration(
                        color: isViewAll
                            ? const Color(0xFFFFEFF1)
                            : isSelected
                            ? const Color(0xFFFFF1F2)
                            : const Color(0xFFF7F9FC),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected || isViewAll
                              ? const Color(0xFFFFD9E0)
                              : const Color(0xFFEFF2F8),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _ink.withValues(alpha: 0.025),
                            blurRadius: 14,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: isViewAll
                          ? const Icon(
                              Icons.grid_view_rounded,
                              color: _red,
                              size: 29,
                            )
                          : Image.asset(item.asset!, fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: _font(size: 10, weight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _promoBanner(BuildContext context) {
    return SizedBox(
      height: 116,
      child: PageView.builder(
        controller: _bannerController,
        itemCount: _promoBanners.length,
        onPageChanged: (index) => setState(() => _activeBannerIndex = index),
        itemBuilder: (context, index) {
          final banner = _promoBanners[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                setState(() => _selectedCategory = banner.category);
                _openProducts(context);
              },
              child: _buildPromoBannerCard(banner),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPromoBannerCard(_PromoBanner banner) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: banner.colors,
        ),
        boxShadow: [
          BoxShadow(
            color: banner.colors.first.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: 4,
            bottom: 0,
            child: SizedBox(
              width: 232,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Positioned(
                    left: 0,
                    bottom: 1,
                    child: Image.asset(
                      banner.images[0],
                      width: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    left: 48,
                    bottom: 0,
                    child: Image.asset(
                      banner.images.length > 1
                          ? banner.images[1]
                          : banner.images[0],
                      width: 78,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    left: 103,
                    bottom: 1,
                    child: Image.asset(
                      banner.images.length > 2
                          ? banner.images[2]
                          : banner.images[0],
                      width: 76,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    left: 158,
                    bottom: 0,
                    child: Image.asset(
                      banner.images.length > 3
                          ? banner.images[3]
                          : banner.images.last,
                      width: 83,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 14,
            bottom: 14,
            right: 190,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  banner.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _font(
                    size: 19,
                    weight: FontWeight.w900,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  banner.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _font(
                    size: 11,
                    weight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.82),
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    banner.action,
                    style: _font(
                      size: 10,
                      weight: FontWeight.w900,
                      color: _ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 136,
            top: 16,
            child: Transform.rotate(
              angle: -0.16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 7,
                ),
                decoration: const BoxDecoration(
                  color: _red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  banner.badge,
                  textAlign: TextAlign.center,
                  style: _font(
                    size: 9.5,
                    weight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.05,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get _filterTitle {
    final category = _selectedCategory == _allCategory
        ? 'Top Products'
        : _selectedCategory;
    if (_selectedVehicleType == _allVehicleType) return category;
    return '$category - $_selectedVehicleType';
  }

  Widget _dots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_promoBanners.length, (index) {
        final isSelected = index == _activeBannerIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: isSelected ? 18 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: isSelected ? _red : const Color(0xFFC8CCD7),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }

  Widget _topHeader() {
    return Row(
      children: [
        Container(
          width: 3,
          height: 21,
          decoration: BoxDecoration(
            color: _red,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            _filterTitle,
            style: _font(size: 16, weight: FontWeight.w800),
          ),
        ),
        _HeaderAction(
          icon: Icons.swap_vert_rounded,
          label: 'Sort',
          onTap: _showSortSheet,
        ),
        const SizedBox(width: 14),
        _HeaderAction(
          icon: Icons.filter_alt_outlined,
          label: 'Filter',
          onTap: _showFilterSheet,
        ),
      ],
    );
  }

  Widget _productGrid(BuildContext context) {
    if (_isLoadingDistributorProducts && _distributorProducts.isEmpty) {
      return _productLoadingGrid();
    }

    final products = _visibleProducts;
    if (products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 42),
        child: Center(
          child: Text(
            _distributorMessage ?? 'No products found',
            style: _font(size: 14, weight: FontWeight.w800, color: _muted),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 620 ? 3 : 2;
        final tileExtent = width < 360 ? 250.0 : 240.0;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 7,
            mainAxisSpacing: 8,
            mainAxisExtent: tileExtent,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            final orderProduct = product.toOrderProduct(
              _products.indexOf(product),
            );
            return Consumer<OrderManagementController>(
              builder: (context, controller, _) {
                final quantity = controller.quantityFor(orderProduct);
                return _ProductTile(
                  product: product,
                  textStyle: _font,
                  isWishlisted: _wishlist.contains(product.id),
                  quantity: quantity,
                  onTap: null,
                  onWishlist: () => _toggleWishlist(product),
                  onDecrease: () => controller.decreaseCartItem(orderProduct),
                  onIncrease: () => _addToCart(context, controller, product),
                  onAddToCart: () => _addToCart(context, controller, product),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _productLoadingGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 620 ? 3 : 2;
        final tileExtent = width < 360 ? 250.0 : 240.0;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: crossAxisCount * 2,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 7,
            mainAxisSpacing: 8,
            mainAxisExtent: tileExtent,
          ),
          itemBuilder: (_, _) => const _ProductLoadingTile(),
        );
      },
    );
  }

  void _toggleWishlist(_HomeProduct product) {
    setState(() {
      if (!_wishlist.remove(product.id)) {
        _wishlist.add(product.id);
      }
    });
  }

  void _addToCart(
    BuildContext context,
    OrderManagementController controller,
    _HomeProduct product,
  ) {
    final orderProduct = product.toOrderProduct(_products.indexOf(product));
    final hasDifferentDistributor = controller.cart.any(
      (item) =>
          item.product.distributorId.isNotEmpty &&
          item.product.distributorId != orderProduct.distributorId,
    );

    if (hasDifferentDistributor) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ek time par sirf ek distributor ka order add kar sakte ho'),
        ),
      );
      return;
    }

    final previousQuantity = controller.quantityFor(orderProduct);
    controller.addToCart(orderProduct);
    final nextQuantity = controller.quantityFor(orderProduct);

    if (nextQuantity == previousQuantity) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            controller.errorMessage ?? 'Product cart me add nahi ho paya',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GarageCartPage()),
          ),
        ),
      ),
    );
  }

  void _showFilterSheet() {
    final categories = [
      _allCategory,
      'Engine Oil',
      'Spare Parts',
      'Battery',
      'Tyres',
      'Filters',
    ];
    const vehicleTypes = [_allVehicleType, '2W', '3W'];
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter products',
                  style: _font(size: 17, weight: FontWeight.w900),
                ),
                const SizedBox(height: 14),
                Text(
                  'Vehicle type',
                  style: _font(size: 12, weight: FontWeight.w900, color: _muted),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: vehicleTypes.map((type) {
                    return _FilterChipButton(
                      label: type == _allVehicleType ? 'All' : type,
                      isSelected: _selectedVehicleType == type,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() => _selectedVehicleType = type);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                Text(
                  'Category',
                  style: _font(size: 12, weight: FontWeight.w900, color: _muted),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((category) {
                    return _FilterChipButton(
                      label: category == _allCategory
                          ? 'All Products'
                          : category,
                      isSelected: _selectedCategory == category,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() => _selectedCategory = category);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSortSheet() {
    _showOptionSheet<_SortMode>(
      title: 'Sort products',
      value: _sortMode,
      items: _SortMode.values,
      label: (value) => value.label,
      onSelected: (value) => setState(() => _sortMode = value),
    );
  }

  void _showOptionSheet<T>({
    required String title,
    required T value,
    required List<T> items,
    required String Function(T value) label,
    required ValueChanged<T> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _font(size: 17, weight: FontWeight.w900)),
                const SizedBox(height: 10),
                ...items.map(
                  (item) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    trailing: item == value
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: _red,
                          )
                        : const Icon(
                            Icons.circle_outlined,
                            color: Color(0xFFB8BDCC),
                          ),
                    title: Text(
                      label(item),
                      style: _font(size: 13, weight: FontWeight.w800),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onSelected(item);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openProducts(BuildContext context) {
    if (_distributorProducts.isEmpty) return;

    final firstProduct = _distributorProducts.first.orderProduct;
    if (firstProduct == null || firstProduct.distributorId.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GarageProductsPage(
          distributorId: firstProduct.distributorId,
          distributorName: _distributorProducts.first.subtitle,
        ),
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HeaderAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: _ShopHomePageState._ink, size: 22),
            const SizedBox(width: 5),
            Text(
              label,
              style: AppTheme.lato(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: _ShopHomePageState._ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoBanner {
  final String title;
  final String subtitle;
  final String action;
  final String badge;
  final List<Color> colors;
  final List<String> images;
  final String category;

  const _PromoBanner({
    required this.title,
    required this.subtitle,
    required this.action,
    required this.badge,
    required this.colors,
    required this.images,
    required this.category,
  });
}

class _ProductLoadingTile extends StatelessWidget {
  const _ProductLoadingTile();

  @override
  Widget build(BuildContext context) {
    Widget block({
      required double width,
      required double height,
      double radius = 8,
    }) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFEFF1F6),
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _ShopHomePageState._line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              block(width: 52, height: 72, radius: 12),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: block(width: 20, height: 20, radius: 999),
                    ),
                    const SizedBox(height: 7),
                    block(width: double.infinity, height: 12),
                    const SizedBox(height: 6),
                    block(width: 92, height: 9),
                    const SizedBox(height: 6),
                    block(width: 72, height: 8),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          block(width: 120, height: 9),
          const SizedBox(height: 8),
          block(width: 54, height: 18),
          const SizedBox(height: 9),
          block(width: 86, height: 16),
          const SizedBox(height: 7),
          block(width: 64, height: 9),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: block(width: double.infinity, height: 30)),
              const SizedBox(width: 7),
              block(width: 40, height: 30, radius: 9),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? _ShopHomePageState._red : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected
                ? _ShopHomePageState._red
                : const Color(0xFFE2E6F0),
          ),
        ),
        child: Text(
          label,
          style: AppTheme.lato(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: isSelected ? Colors.white : _ShopHomePageState._ink,
          ),
        ),
      ),
    );
  }
}

enum _SortMode {
  popular('Popular'),
  priceLow('Price: Low to High'),
  priceHigh('Price: High to Low'),
  rating('Top Rated');

  final String label;
  const _SortMode(this.label);
}

class _ProductTile extends StatelessWidget {
  final _HomeProduct product;
  final bool isWishlisted;
  final int quantity;
  final VoidCallback? onTap;
  final VoidCallback onWishlist;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onAddToCart;
  final TextStyle Function({
    double size,
    FontWeight weight,
    Color color,
    double height,
  })
  textStyle;

  const _ProductTile({
    required this.product,
    required this.isWishlisted,
    required this.quantity,
    required this.onTap,
    required this.onWishlist,
    required this.onDecrease,
    required this.onIncrease,
    required this.onAddToCart,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _ShopHomePageState._line),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 54,
                  height: 86,
                  child: product.imageUrl.isNotEmpty
                      ? Image.network(
                          product.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => Image.asset(
                            product.image,
                            fit: BoxFit.contain,
                          ),
                        )
                      : Image.asset(product.image, fit: BoxFit.contain),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: onWishlist,
                          child: Icon(
                            isWishlisted
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isWishlisted
                                ? _ShopHomePageState._red
                                : const Color(0xFF747B9C),
                            size: 19,
                          ),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle(size: 11.8, weight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle(size: 9.8, weight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.meta,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle(
                          size: 9,
                          weight: FontWeight.w600,
                          color: _ShopHomePageState._muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFB000),
                  size: 14,
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    product.rating,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                style: textStyle(
                  size: 9.6,
                  weight: FontWeight.w700,
                  color: _ShopHomePageState._muted,
                ),
              ),
            ),
                Text(
                  product.inStock ? 'In Stock' : 'Out of stock',
                  style: textStyle(
                    size: 9.2,
                    weight: FontWeight.w800,
                    color: product.inStock
                        ? _ShopHomePageState._green
                        : _ShopHomePageState._red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: _ShopHomePageState._soft,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                product.unit,
                style: textStyle(size: 9.2, weight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '\u20B9${product.price}',
                  style: textStyle(size: 15, weight: FontWeight.w900),
                ),
                const SizedBox(width: 6),
                Text(
                  '\u20B9${product.oldPrice}',
                  style: textStyle(
                    size: 9.2,
                    weight: FontWeight.w700,
                    color: _ShopHomePageState._muted,
                  ).copyWith(decoration: TextDecoration.lineThrough),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              product.off,
              style: textStyle(
                size: 9.2,
                weight: FontWeight.w900,
                color: _ShopHomePageState._green,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 34,
                    decoration: BoxDecoration(
                      color: _ShopHomePageState._soft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        _StepperCell(
                          icon: Icons.remove_rounded,
                          onTap: quantity > 0 ? onDecrease : null,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              quantity == 0 ? '0' : quantity.toString(),
                              style: textStyle(
                                size: 11.5,
                                weight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        _StepperCell(
                          icon: Icons.add_rounded,
                          onTap: onIncrease,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                InkWell(
                  borderRadius: BorderRadius.circular(9),
                  onTap: onAddToCart,
                  child: Container(
                    width: 40,
                    height: 34,
                    decoration: BoxDecoration(
                      color: _ShopHomePageState._red,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      quantity > 0
                          ? Icons.shopping_cart_rounded
                          : Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 19,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperCell extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepperCell({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 26,
        child: Icon(
          icon,
          color: onTap == null
              ? _ShopHomePageState._muted.withValues(alpha: 0.35)
              : _ShopHomePageState._red,
          size: 15,
        ),
      ),
    );
  }
}

class _CategoryItem {
  final String title;
  final String? asset;

  const _CategoryItem(this.title, this.asset);
}

class _HomeProduct {
  final String id;
  final String name;
  final String subtitle;
  final String meta;
  final String rating;
  final String unit;
  final String price;
  final String oldPrice;
  final String off;
  final String image;
  final String imageUrl;
  final String category;
  final String vehicleType;
  final bool inStock;
  final double ratingValue;
  final int popularity;
  final OrderProduct? orderProduct;

  const _HomeProduct({
    String? id,
    required this.name,
    required this.subtitle,
    required this.meta,
    required this.rating,
    required this.unit,
    required this.price,
    required this.oldPrice,
    required this.off,
    required this.image,
    this.imageUrl = '',
    required this.category,
    required this.vehicleType,
    this.inStock = true,
    required this.ratingValue,
    required this.popularity,
    this.orderProduct,
  }) : id = id ?? name;

  factory _HomeProduct.fromOrderProduct(
    OrderProduct product, {
    required String distributorName,
    required int popularity,
  }) {
    final category = _categoryFor(product);
    final vehicleType = _vehicleTypeFor(product);
    final mrp =
        _intValue(
          product.raw['mrp'] ??
              product.raw['productPrice'] ??
              product.raw['price'],
        ) >
            product.price
        ? _intValue(
            product.raw['mrp'] ??
                product.raw['productPrice'] ??
                product.raw['price'],
          )
        : product.price + ((product.price * 0.18).round());

    return _HomeProduct(
      id: product.cartKey,
      name: product.name,
      subtitle: distributorName.isNotEmpty ? distributorName : product.brand,
      meta: '$category  |  $vehicleType',
      rating: product.stock > 0 ? '4.8 (${product.stock})' : '4.8 (0)',
      unit: _unitFor(product),
      price: product.price.toString(),
      oldPrice: mrp.toString(),
      off: product.stock > 0 ? 'Stock ${product.stock}' : 'Out of stock',
      image: _assetFor(product),
      imageUrl: product.imageUrl,
      category: category,
      vehicleType: vehicleType,
      inStock: product.stock > 0,
      ratingValue: 4.8,
      popularity: popularity,
      orderProduct: product,
    );
  }

  int get priceValue => int.tryParse(price) ?? 0;

  OrderProduct toOrderProduct(int index) {
    if (orderProduct != null) return orderProduct!;

    return OrderProduct(
      id: 'home-${id.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}',
      lineId: 'home-line-$index',
      cartKey: 'home-${id.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}',
      name: name,
      category: category,
      price: priceValue,
      stock: 99,
      brand: subtitle,
      distributorId: 'home-catalog',
      imageUrl: '',
      raw: {
        'source': 'home',
        'asset': image,
        'unit': unit,
        'vehicleType': vehicleType,
        'oldPrice': oldPrice,
        'off': off,
      },
    );
  }
}

int _intValue(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _categoryFor(OrderProduct product) {
  final source = '${product.category} ${product.name}'.toLowerCase();
  if (source.contains('oil') || source.contains('lub')) return 'Engine Oil';
  if (source.contains('battery')) return 'Battery';
  if (source.contains('tyre') || source.contains('tire')) return 'Tyres';
  if (source.contains('filter')) return 'Filters';
  return 'Spare Parts';
}

String _vehicleTypeFor(OrderProduct product) {
  final source =
      '${product.name} ${product.category} ${product.brand} ${product.raw}'
          .toLowerCase();
  if (source.contains('3w') ||
      source.contains('auto') ||
      source.contains('rickshaw')) {
    return '3W';
  }
  return '2W';
}

String _unitFor(OrderProduct product) {
  final raw = product.raw;
  final candidates = [
    raw['unit'],
    raw['packSize'],
    raw['size'],
    raw['quantityLabel'],
  ];
  for (final candidate in candidates) {
    final value = candidate?.toString().trim() ?? '';
    if (value.isNotEmpty) return value;
  }
  if (product.stock > 0) return 'Stock ${product.stock}';
  return '1 Pc';
}

String _assetFor(OrderProduct product) {
  final source = '${product.category} ${product.name}'.toLowerCase();
  if (source.contains('battery')) return 'assets/home_ref/cat_battery.png';
  if (source.contains('tyre') || source.contains('tire')) {
    return 'assets/home_ref/cat_tyres.png';
  }
  if (source.contains('filter')) return 'assets/home_ref/prod_air_filter.png';
  if (source.contains('brake')) return 'assets/home_ref/prod_brake_pad.png';
  if (source.contains('plug')) return 'assets/home_ref/prod_spark_plug.png';
  if (source.contains('gold') || source.contains('20w') || source.contains('3w')) {
    return 'assets/catalog/prod_oil_gold.png';
  }
  return 'assets/catalog/prod_oil_black.png';
}
