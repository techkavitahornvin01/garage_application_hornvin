import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/controllers/login_controller.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';
import 'package:hornvin/widgets/common_widgets.dart';
import 'package:hornvin/localization/app_localizations.dart';

/// GarageSidebarDrawer — Fully Clickable Professional Sidebar
///
/// Index Mapping (passed via onItemSelected):
///   0 → Home (bottom nav index 0)
///   1 → Chat (bottom nav index 1)
///   2 → Bill Payment (bottom nav index 3)
///   3 → Scan (push new page)
///   4 → Service Orders (push new page)
///   5 → Spare Parts (push new page)
///   6 → Job History (bottom nav index 2)
///   7 → Profile (push profile page)
///   Reports / Settings / Help → push new pages from HomeScreen handler

class GarageSidebarDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userRole;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const GarageSidebarDrawer({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userRole,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 292,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────────
            _SidebarHeader(
              userName: userName,
              userEmail: userEmail,
              userRole: userRole,
            ),

            // ── Navigation List ─────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                physics: const BouncingScrollPhysics(),
                children: [
                  // MAIN Section
                  _SectionLabel('MAIN'),
                  _NavTile(
                    icon: Icons.home_rounded,
                    label: 'home',
                    subtitle: 'home_dashboard_subtitle',
                    accentColor: const Color(0xFF6366F1),
                    index: 0,
                    selectedIndex: selectedIndex,
                    onTap: () => onItemSelected(0),
                  ),
                  _NavTile(
                    icon: Icons.car_repair_rounded,
                    label: 'service_orders',
                    subtitle: 'service_orders_subtitle',
                    accentColor: const Color(0xFF0EA5E9),
                    index: 4,
                    selectedIndex: selectedIndex,
                    onTap: () => onItemSelected(4),
                  ),
                  _NavTile(
                    icon: Icons.build_circle_rounded,
                    label: 'spare_parts',
                    subtitle: 'spare_parts_subtitle',
                    accentColor: const Color(0xFFF59E0B),
                    index: 5,
                    selectedIndex: selectedIndex,
                    onTap: () => onItemSelected(5),
                  ),
                  _PlainTile(
                    icon: Icons.storefront_rounded,
                    label: 'distributors',
                    subtitle: 'distributors_subtitle',
                    accentColor: const Color(0xFFE11D48),
                    onTap: () => onItemSelected(12),
                  ),
                  _NavTile(
                    icon: Icons.history_rounded,
                    label: 'job_history',
                    subtitle: 'job_history_subtitle',
                    accentColor: const Color(0xFF10B981),
                    index: 6,
                    selectedIndex: selectedIndex,
                    onTap: () => onItemSelected(6),
                  ),
                  _NavTile(
                    icon: Icons.qr_code_scanner_rounded,
                    label: 'scan_qr',
                    subtitle: 'scan_qr_subtitle',
                    accentColor: const Color(0xFF8B5CF6),
                    index: 3,
                    selectedIndex: selectedIndex,
                    onTap: () => onItemSelected(3),
                  ),

                  const SizedBox(height: 4),

                  // COMMUNICATION Section
                  _SectionLabel('COMMUNICATION'),
                  _NavTile(
                    icon: Icons.chat_bubble_rounded,
                    label: 'chat',
                    subtitle: 'chat_subtitle',
                    accentColor: const Color(0xFF06B6D4),
                    index: 1,
                    selectedIndex: selectedIndex,
                    onTap: () => onItemSelected(1),
                  ),

                  const SizedBox(height: 4),

                  // ACCOUNT Section
                  _SectionLabel('ACCOUNT'),
                  _NavTile(
                    icon: Icons.person_rounded,
                    label: 'profile',
                    subtitle: 'profile_subtitle',
                    accentColor: const Color(0xFF8B5CF6),
                    index: 7,
                    selectedIndex: selectedIndex,
                    onTap: () => onItemSelected(7),
                  ),
                  _PlainTile(
                    icon: Icons.people_alt_rounded,
                    label: 'customers',
                    subtitle: 'customers_subtitle',
                    accentColor: const Color(0xFFEC4899),
                    onTap: () => onItemSelected(11),
                  ),
                  _PlainTile(
                    icon: Icons.inventory_2_rounded,
                    label: 'inventory',
                    subtitle: 'inventory_subtitle',
                    accentColor: const Color(0xFF14B8A6),
                    onTap: () => Navigator.pop(context),
                  ),

                  const SizedBox(height: 4),

                  // MORE Section
                  _SectionLabel('MORE'),
                  _PlainTile(
                    icon: Icons.analytics_rounded,
                    label: 'reports_analytics',
                    subtitle: 'reports_subtitle',
                    accentColor: const Color(0xFFF97316),
                    onTap: () => onItemSelected(8),
                  ),
                  _PlainTile(
                    icon: Icons.settings_rounded,
                    label: 'garage_settings',
                    subtitle: 'settings_subtitle',
                    accentColor: const Color(0xFF64748B),
                    onTap: () => onItemSelected(9),
                  ),
                  _PlainTile(
                    icon: Icons.help_outline_rounded,
                    label: 'help_support',
                    subtitle: 'help_subtitle',
                    accentColor: const Color(0xFF0284C7),
                    onTap: () => onItemSelected(10),
                  ),

                  const SizedBox(height: 12),

                  // Logout
                  _LogoutTile(context: context),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // ── Footer ─────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.only(bottom: 24, top: 8),
              child: Column(
                children: [
                  const Divider(indent: 30, endIndent: 30),
                  const SizedBox(height: 8),
                  Text(
                    context.tr('Hornvin v1.0.0  ·  Garage Partner'),
                    style: GoogleFonts.lato(
                      fontSize: 10,
                      color: const Color(0xFFB0BAD0),
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── SIDEBAR HEADER ──────────────────────────────────────────────────────────
class _SidebarHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userRole;

  const _SidebarHeader({
    required this.userName,
    required this.userEmail,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 56, 22, 26),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondary, Color(0xFF1E3A8A)],
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32),
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Logo / Avatar ─────────────────────────
              SizedBox(
                width: 132,
                height: 52,
                child: Image.asset(
                  HornvinLogo.assetPath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Center(
                    child: Icon(
                      Icons.car_repair_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // ── Online Badge ──────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4ADE80),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      context.tr('online'),
                      style: GoogleFonts.lato(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            context.trData(userName),
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            context.trData(userEmail),
            style: GoogleFonts.lato(fontSize: 11, color: Colors.white60),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              // Role chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.trData(userRole),
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Rating chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 13,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '4.8',
                      style: GoogleFonts.lato(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── SECTION LABEL ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, top: 12, bottom: 4),
      child: Text(
        context.trData(text),
        style: GoogleFonts.lato(
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          color: const Color(0xFFB0BAD0),
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

// ─── NAV TILE (with active highlight + subtitle) ───────────────────────────────
class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color accentColor;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  const _NavTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.accentColor,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(
                  color: accentColor.withValues(alpha: 0.28),
                  width: 1.2,
                )
              : null,
        ),
        child: Row(
          children: [
            // Icon Box
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: isSelected ? 0.18 : 0.09),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accentColor, size: 19),
            ),
            const SizedBox(width: 12),
            // Label + Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.trData(label),
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected ? accentColor : const Color(0xFF374151),
                    ),
                  ),
                  Text(
                    context.trData(subtitle),
                    style: GoogleFonts.lato(
                      fontSize: 10,
                      color: isSelected
                          ? accentColor.withValues(alpha: 0.7)
                          : const Color(0xFFB0BAD0),
                    ),
                  ),
                ],
              ),
            ),
            // Active indicator
            if (isSelected)
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
              )
            else
              const Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: Color(0xFFD1D5DB),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── PLAIN TILE (no selected state, placeholder pages) ───────────────────────
class _PlainTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  const _PlainTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accentColor, size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.trData(label),
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF374151),
                    ),
                  ),
                  Text(
                    context.trData(subtitle),
                    style: GoogleFonts.lato(
                      fontSize: 10,
                      color: const Color(0xFFB0BAD0),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: Color(0xFFD1D5DB),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── LOGOUT TILE ─────────────────────────────────────────────────────────────
class _LogoutTile extends StatelessWidget {
  final BuildContext context;
  const _LogoutTile({required this.context});

  @override
  Widget build(BuildContext _) {
    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Colors.red,
                size: 19,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.trText('Logout'),
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    context.trText('Sign out of your account'),
                    style: GoogleFonts.lato(
                      fontSize: 10,
                      color: Colors.red.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  context.trText('Logout'),
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.trText(
                    'Are you sure you want to logout from your Hornvin Garage account?',
                  ),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    color: const Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 26),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                        child: Text(
                          context.trText('Cancel'),
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await LoginController.logout();
                          if (context.mounted) {
                            Navigator.pop(ctx);
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          context.trText('Logout'),
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
