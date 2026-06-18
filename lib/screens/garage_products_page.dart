import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/controllers/order_management_controller.dart';
import 'package:hornvin/localization/app_localizations.dart';
import 'package:hornvin/models/order_management_model.dart';
import 'package:hornvin/screens/garage_cart_page.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';
import 'package:provider/provider.dart';

class GarageProductsPage extends StatefulWidget {
  final String? distributorId;
  final String? distributorName;

  const GarageProductsPage({
    super.key,
    this.distributorId,
    this.distributorName,
  });

  @override
  State<GarageProductsPage> createState() => _GarageProductsPageState();
}

class _GarageProductsPageState extends State<GarageProductsPage> {
  late final OrderManagementController _controller;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _controller = OrderManagementController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchProducts());
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: AppColors.scaffold,
        appBar: AppBar(
          leading: Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => Navigator.pop(context),
                )
              : null,
          title: Text(
            widget.distributorName == null
                ? 'Create Order'
                : '${widget.distributorName} Products',
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
              icon: const Icon(Icons.refresh),
              color: AppColors.primary,
              onPressed: _fetchProducts,
            ),
          ],
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: Consumer<OrderManagementController>(
                builder: (context, controller, child) {
                  final queryFiltered = controller.products.where((product) {
                    final query = _query.toLowerCase();
                    return query.isEmpty ||
                        product.name.toLowerCase().contains(query) ||
                        product.brand.toLowerCase().contains(query) ||
                        product.category.toLowerCase().contains(query);
                  }).toList();
                  final distributorId = widget.distributorId?.trim() ?? '';
                  final distributorProducts = distributorId.isEmpty
                      ? queryFiltered
                      : queryFiltered
                            .where(
                              (product) =>
                                  product.distributorId == distributorId,
                            )
                            .toList();
                  final products = distributorProducts.isEmpty
                      ? queryFiltered
                      : distributorProducts;

                  if (controller.isLoading && controller.products.isEmpty) {
                    return _buildLoading('Loading products...');
                  }

                  if (controller.errorMessage != null &&
                      controller.products.isEmpty) {
                    return _buildError(controller.errorMessage!);
                  }

                  if (products.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _fetchProducts,
                      color: AppColors.primary,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.55,
                            child: _buildEmpty('No products found'),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _fetchProducts,
                    color: AppColors.primary,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            mainAxisExtent: 286,
                          ),
                      itemBuilder: (context, index) {
                        return KeyedSubtree(
                          key: ValueKey(products[index].cartKey),
                          child: _buildProductGridCard(
                            context,
                            products[index],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: Consumer<OrderManagementController>(
          builder: (context, controller, child) {
            if (controller.cart.isEmpty) return const SizedBox.shrink();
            return _buildCartSummary(context, controller);
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _query = value),
          onSubmitted: (_) => _fetchProducts(),
          decoration: InputDecoration(
            hintText: context.trText('Search products, brand, category...'),
            hintStyle: GoogleFonts.lato(color: AppColors.grey),
            prefixIcon: const Icon(Icons.search, color: AppColors.primary),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductGridCard(BuildContext context, OrderProduct product) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.75)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 122,
            width: double.infinity,
            child: GestureDetector(
              onTap: () => _showProductDetails(context, product),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                clipBehavior: Clip.antiAlias,
                child: product.imageUrl.isEmpty
                    ? Icon(
                        _iconFor(product.category),
                        color: Colors.white,
                        size: 40,
                      )
                    : Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(
                          _iconFor(product.category),
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            context.trData(product.name),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
              fontSize: 13,
              height: 1.16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            context.trData(product.brand),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
              fontSize: 10.5,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Rs ${product.price}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              _buildSmallStock(product),
            ],
          ),
          const SizedBox(height: 8),
          Consumer<OrderManagementController>(
            builder: (context, controller, child) {
              final quantity = controller.quantityFor(product);
              if (quantity == 0) {
                return _buildGridAddButton(
                  onPressed: () => controller.addToCart(product),
                );
              }

              return _buildGridQuantityStepper(
                quantity: quantity,
                onDecrease: () => controller.decreaseCartItem(product),
                onIncrease: () => controller.addToCart(product),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStock(OrderProduct product) {
    final color = product.stock > 0 ? Colors.green : Colors.red;
    return Container(
      constraints: const BoxConstraints(maxWidth: 72),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Stock ${product.stock}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: GoogleFonts.lato(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildGridAddButton({required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 38,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add, size: 18),
        label: Text(context.trText('Add')),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
          foregroundColor: AppColors.secondary,
          minimumSize: const Size(0, 38),
          maximumSize: const Size(double.infinity, 38),
          textStyle: GoogleFonts.lato(
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildGridQuantityStepper({
    required int quantity,
    required VoidCallback onDecrease,
    required VoidCallback onIncrease,
  }) {
    return Container(
      height: 36,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            onPressed: onDecrease,
            icon: const Icon(Icons.remove, size: 18),
            color: AppColors.secondary,
          ),
          Expanded(
            child: Text(
              quantity.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                color: AppColors.secondary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            onPressed: onIncrease,
            icon: const Icon(Icons.add, size: 18),
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary(
    BuildContext context,
    OrderManagementController controller,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.paddingOf(context).bottom + 12,
      ),
      color: Colors.white,
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${controller.cartItemCount} items - Rs ${controller.cartTotal}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: controller.isCreating
                  ? null
                  : () => _openCartPage(context, controller),
              icon: controller.isCreating
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.shopping_cart_checkout, size: 18),
              label: Text(controller.isCreating ? 'Ordering...' : 'View Cart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(116, 44),
                maximumSize: const Size(150, 44),
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCartPage(
    BuildContext context,
    OrderManagementController controller,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: controller,
          child: GarageCartPage(distributorId: widget.distributorId),
        ),
      ),
    );
  }

  Widget _buildLoading(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            context.trData(message),
            style: GoogleFonts.lato(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return RefreshIndicator(
      onRefresh: _fetchProducts,
      color: AppColors.primary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.62,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline_rounded,
                      size: 38,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    context.trText('Products unavailable'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.trData(message),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 18),
                  OutlinedButton.icon(
                    onPressed: _fetchProducts,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(context.trText('Retry')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(String message) {
    return Center(
      child: Text(
        context.trData(message),
        style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showProductDetails(BuildContext context, OrderProduct product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.trData(product.name),
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 14),
              _detailRow('Price', 'Rs ${product.price}'),
              _detailRow('Stock', product.stock.toString()),
              _detailRow('Category', product.category),
              _detailRow('Brand/SKU', product.brand),
              _detailRow(
                'Distributor',
                product.distributorId.isEmpty
                    ? 'Not linked'
                    : product.distributorId,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              context.trData(label),
              style: GoogleFonts.lato(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              context.trData(value),
              style: GoogleFonts.lato(
                fontSize: 13,
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String category) {
    final value = category.toLowerCase();
    if (value.contains('brake')) return Icons.circle;
    if (value.contains('electric')) return Icons.electrical_services;
    if (value.contains('engine')) return Icons.settings;
    return Icons.inventory_2;
  }

  Future<void> _fetchProducts() {
    return _controller.fetchProducts(
      distributorId: widget.distributorId,
      search: _query,
    );
  }
}
