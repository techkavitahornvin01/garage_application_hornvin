import 'package:hornvin/localization/app_localizations.dart';
// import 'package:flutter/material.dart';

// class GarageSupplyCard extends StatelessWidget {
//   final String name;
//   final String location;
//   final String status;

//   const GarageSupplyCard({
//     super.key,
//     required this.name,
//     required this.location,
//     required this.status,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.05),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF5B31A).withValues(alpha: 0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(Icons.local_shipping, color: Color(0xFFF5B31A), size: 30),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(context.trData(//                   name),
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(context.trData(//                   location),
//                   style: TextStyle(
//                     color: Colors.white.withValues(alpha: 0.7),
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.green.withValues(alpha: 0.2),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(context.trData(//                   status),
//                   style: const TextStyle(
//                     color: Colors.green,
//                     fontSize: 10,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   IconButton(
//                     onPressed: () {},
//                     icon: const Icon(Icons.call, color: Color(0xFFF5B31A), size: 20),
//                   ),
//                   TextButton(
//                     onPressed: () {},
//                     child: const Text(context.trData(//                       'Order'),
//                       style: TextStyle(color: Color(0xFFF5B31A), fontSize: 12),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/controllers/login_controller.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';

// ─────────────────────────────────────────
// HORNVIN LOGO WIDGET
// ─────────────────────────────────────────
class HornvinLogo extends StatelessWidget {
  static const String assetPath = 'assets/logo.png';

  final double size;
  final Color color;
  final bool showTagline;

  const HornvinLogo({
    super.key,
    this.size = 56,
    this.color = AppColors.white,
    this.showTagline = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 2.6,
      height: size,
      child: Image.asset(assetPath, fit: BoxFit.contain),
    );
  }
}

// ─────────────────────────────────────────
// PRIMARY BUTTON
// ─────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                context.trData(label),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// HORNVIN APP BAR
// ─────────────────────────────────────────
class HornvinAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showMenu;
  final VoidCallback? onMenuTap;

  const HornvinAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showMenu = true,
    this.onMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.secondary,
      leading: showMenu
          ? IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
            )
          : null,
      title: Text(
        context.trData(title),
        style: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
        if (actions != null) ...actions!,
      ],
      elevation: 0,
    );
  }
}

// ─────────────────────────────────────────
// HORNVIN BOTTOM NAV
// ─────────────────────────────────────────
class HornvinBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const HornvinBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: AppColors.secondary,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      selectedLabelStyle: GoogleFonts.lato(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.lato(fontSize: 10),
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          activeIcon: Icon(Icons.bar_chart),
          label: 'Monthly',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_outlined),
          activeIcon: Icon(Icons.grid_view),
          label: 'Mportd',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Noprs',
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.trData(title),
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              context.trData(actionLabel!),
              style: GoogleFonts.lato(
                fontSize: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// PRODUCT CARD
// ─────────────────────────────────────────
class ProductCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String price;
  final Color tagColor;
  final String? tag;

  const ProductCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.price,
    this.tagColor = AppColors.primary,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Container(
                  height: 90,
                  width: double.infinity,
                  color: AppColors.lightGrey,
                  child: const Icon(
                    Icons.tire_repair,
                    size: 44,
                    color: AppColors.grey,
                  ),
                ),
              ),
              if (tag != null)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: tagColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      context.trData(tag!),
                      style: GoogleFonts.lato(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.trData(name),
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  context.trData(subtitle),
                  style: GoogleFonts.lato(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  context.trData(price),
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      context.trText('Add'),
                      style: GoogleFonts.lato(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// COUNTER/GARAGE CARD
// ─────────────────────────────────────────
class CounterCard extends StatelessWidget {
  final String name;
  final String location;
  final String? lastOrder;
  final String? status;
  final Color statusColor;
  final bool showCall;

  const CounterCard({
    super.key,
    required this.name,
    required this.location,
    this.lastOrder,
    this.status,
    this.statusColor = AppColors.success,
    this.showCall = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.garage_outlined,
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
                  context.trData(name),
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 12,
                      color: AppColors.grey,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      context.trData(location),
                      style: GoogleFonts.lato(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (lastOrder != null)
                  Text(
                    context.trData(lastOrder!),
                    style: GoogleFonts.lato(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (showCall)
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.phone,
                    size: 13,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    context.trText('Call'),
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  context.trText('View Details'),
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// DRAWER / SIDE MENU
// ─────────────────────────────────────────
class HornvinDrawer extends StatelessWidget {
  const HornvinDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {'icon': Icons.people_outline, 'label': 'My Counters'},
      {'icon': Icons.local_shipping_outlined, 'label': 'Active Supply'},
      {'icon': Icons.receipt_long_outlined, 'label': 'Create Invoice'},
      {'icon': Icons.payment_outlined, 'label': 'Payment Reminder'},
      {'icon': Icons.inventory_2_outlined, 'label': 'Stock Management'},
      {'icon': Icons.storefront_outlined, 'label': 'Marketplace'},
      {'icon': Icons.chat_bubble_outline, 'label': 'Chat / Broadcast'},
    ];

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.secondary, AppColors.secondaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 122,
                  height: 46,
                  child: Image.asset(
                    HornvinLogo.assetPath,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  context.trText('HORNVIN'),
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  context.trText('Distributor Account'),
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return ListTile(
                  leading: Icon(
                    item['icon'] as IconData,
                    color: AppColors.secondary,
                    size: 22,
                  ),
                  title: Text(
                    context.trData(item['label'] as String),
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.grey,
                    size: 18,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    switch (item['label']) {
                      case 'Active Supply':
                        Navigator.pushNamed(context, '/active_supply');
                        break;
                      case 'Create Invoice':
                        Navigator.pushNamed(context, '/create_invoice');
                        break;
                      case 'Payment Reminder':
                        Navigator.pushNamed(context, '/payment_reminder');
                        break;
                      case 'Stock Management':
                        Navigator.pushNamed(context, '/stock_management');
                        break;
                      case 'Chat / Broadcast':
                        Navigator.pushNamed(context, '/chat');
                        break;
                    }
                  },
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: AppColors.primary,
              size: 22,
            ),
            title: Text(
              context.trText('Logout'),
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
            onTap: () async {
              await LoginController.logout();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (r) => false,
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
