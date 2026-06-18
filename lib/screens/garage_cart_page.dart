import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/controllers/order_management_controller.dart';
import 'package:hornvin/models/order_management_model.dart';
import 'package:hornvin/screens/garage_orders_page.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';
import 'package:provider/provider.dart';
import 'package:hornvin/localization/app_localizations.dart';

class GarageCartPage extends StatelessWidget {
  final String? distributorId;

  const GarageCartPage({super.key, this.distributorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(
          context.trText('My Cart'),
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
      ),
      body: Consumer<OrderManagementController>(
        builder: (context, controller, child) {
          if (controller.cart.isEmpty) return _buildEmpty(context);

          return ListView(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 132),
            children: [
              _buildHeader(context, controller),
              const SizedBox(height: 12),
              ...controller.cart.map(
                (item) => _CartItemTile(item: item, controller: controller),
              ),
              const SizedBox(height: 10),
              _buildBill(context, controller),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<OrderManagementController>(
        builder: (context, controller, child) {
          if (controller.cart.isEmpty) return const SizedBox.shrink();
          return _buildCheckoutBar(context, controller);
        },
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    OrderManagementController controller,
  ) {
    return Row(
      children: [
        Text(
          '${controller.cartItemCount} items',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: controller.clearCart,
          child: Text(context.trText('Clear')),
        ),
      ],
    );
  }

  Widget _buildBill(
    BuildContext context,
    OrderManagementController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _billRow(context, 'Subtotal', controller.cartSubtotal),
          _billRow(context, 'Tax', controller.cartTax),
          _billRow(context, 'Delivery fee', controller.deliveryFee),
          Divider(color: Colors.grey.shade200, height: 22),
          _billRow(
            context,
            'Grand total',
            controller.cartGrandTotal,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _billRow(
    BuildContext context,
    String label,
    int amount, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            context.trText(label),
            style: GoogleFonts.lato(
              fontSize: isTotal ? 15 : 13,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
              color: isTotal ? const Color(0xFF1A237E) : Colors.grey.shade700,
            ),
          ),
          const Spacer(),
          Text(
            'Rs $amount',
            style: GoogleFonts.lato(
              fontSize: isTotal ? 16 : 13,
              fontWeight: FontWeight.w800,
              color: isTotal ? const Color(0xFFE31E24) : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar(
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
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: controller.isCreating
            ? null
            : () => _checkout(context, controller),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE31E24),
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: controller.isCreating
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                'Checkout - Rs ${controller.cartGrandTotal}',
                style: GoogleFonts.lato(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 78, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              context.trText('Your cart is empty'),
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.trText('Add products to create an order.'),
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: 190,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(minimumSize: const Size(0, 46)),
                child: Text(context.trText('Browse Products')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkout(
    BuildContext context,
    OrderManagementController controller,
  ) async {
    final payload = controller.orderRequestPayload(
      distributorId: distributorId,
    );
    debugPrint('Cart checkout payload: $payload');

    final success = await controller.createOrder(distributorId: distributorId);
    if (!context.mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.errorMessage ?? 'Order failed'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.trText('Order Created')),
        content: Text(
          context.trText('Your order has been placed successfully.'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.trText('OK')),
          ),
        ],
      ),
    );

    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(
              context.trText('Orders'),
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
          ),
          body: const GarageOrdersPage(),
        ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final OrderCartItem item;
  final OrderManagementController controller;

  const _CartItemTile({required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFE31E24),
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: product.imageUrl.isEmpty
                ? const Icon(Icons.inventory_2, color: Colors.white)
                : Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.inventory_2, color: Colors.white),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.trData(product.name),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Rs ${product.price}',
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _MiniStepper(
                      quantity: item.quantity,
                      onDecrease: () => controller.decreaseCartItem(product),
                      onIncrease: () => controller.addToCart(product),
                    ),
                    const Spacer(),
                    Text(
                      'Rs ${product.price * item.quantity}',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFE31E24),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Remove',
            onPressed: () => controller.removeCartItem(item),
            icon: const Icon(Icons.close, size: 19),
          ),
        ],
      ),
    );
  }
}

class _MiniStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _MiniStepper({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFF1A237E).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onPressed: onDecrease,
            icon: const Icon(Icons.remove, size: 17),
          ),
          Text(
            quantity.toString(),
            style: GoogleFonts.lato(fontWeight: FontWeight.w800),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onPressed: onIncrease,
            icon: const Icon(Icons.add, size: 17),
          ),
        ],
      ),
    );
  }
}
