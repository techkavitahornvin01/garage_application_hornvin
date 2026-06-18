import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/localization/app_localizations.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: _simpleAppBar(context, 'Help & Support'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeroPanel(
            icon: Icons.support_agent_rounded,
            title: 'How can we help?',
            subtitle: 'Get quick help for job cards, invoices, orders and app issues.',
            color: const Color(0xFF0284C7),
          ),
          const SizedBox(height: 16),
          _ActionTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Chat support',
            subtitle: 'Talk to Hornvin support team',
            color: AppColors.success,
            onTap: () => Navigator.pushNamed(context, '/HornvinChatScreen'),
          ),
          _ActionTile(
            icon: Icons.receipt_long_rounded,
            title: 'Invoice help',
            subtitle: 'PDF, payment and invoice lookup issues',
            color: AppColors.primary,
          ),
          _ActionTile(
            icon: Icons.assignment_outlined,
            title: 'Job card help',
            subtitle: 'Photos, mechanic details and job sheet PDF',
            color: AppColors.secondary,
          ),
          _SectionTitle('Common Questions'),
          _FaqTile('Why is invoice PDF not showing?', 'Check job card id, vehicle number and phone number match with invoice.'),
          _FaqTile('How do I add vehicle photos?', 'Open job card create screen, use Camera or Gallery in Vehicle Photos.'),
          _FaqTile('How do I contact support?', 'Use Chat support from this page or the app chat tab.'),
        ],
      ),
    );
  }
}

class GarageSettingsScreen extends StatelessWidget {
  const GarageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: _simpleAppBar(context, 'Garage Settings'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeroPanel(
            icon: Icons.settings_rounded,
            title: 'Garage Settings',
            subtitle: 'Manage business profile, invoice defaults and app preferences.',
            color: const Color(0xFF64748B),
          ),
          const SizedBox(height: 16),
          _ActionTile(
            icon: Icons.store_mall_directory_rounded,
            title: 'Garage profile',
            subtitle: 'Business name, address and contact details',
            color: AppColors.primary,
            onTap: () => Navigator.pushNamed(context, '/home'),
          ),
          _ActionTile(
            icon: Icons.request_quote_outlined,
            title: 'Invoice defaults',
            subtitle: 'Company name, GST, tax and payment preferences',
            color: AppColors.success,
          ),
          _ActionTile(
            icon: Icons.notifications_active_outlined,
            title: 'Notifications',
            subtitle: 'Service reminders and order updates',
            color: AppColors.warning,
          ),
          _ActionTile(
            icon: Icons.language_rounded,
            title: 'Language',
            subtitle: 'Change app language',
            color: AppColors.secondary,
            onTap: () => Navigator.pushNamed(context, '/language'),
          ),
        ],
      ),
    );
  }
}

class ReportsAnalyticsScreen extends StatelessWidget {
  const ReportsAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: _simpleAppBar(context, 'Reports & Analytics'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeroPanel(
            icon: Icons.analytics_rounded,
            title: 'Reports & Analytics',
            subtitle:
                'A clear view of jobs, invoices, orders and workshop performance.',
            color: const Color(0xFFF97316),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF97316).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFF97316).withValues(alpha: 0.18),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule_rounded, color: Color(0xFFF97316)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.trText(
                      'Detailed analytics dashboards are coming soon.',
                    ),
                    style: GoogleFonts.lato(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(
                child: _MetricCard(
                  title: 'Jobs',
                  value: 'Soon',
                  icon: Icons.assignment_rounded,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  title: 'Invoices',
                  value: 'Soon',
                  icon: Icons.receipt_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Expanded(
                child: _MetricCard(
                  title: 'Orders',
                  value: 'Soon',
                  icon: Icons.shopping_bag_rounded,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  title: 'Revenue',
                  value: 'Soon',
                  icon: Icons.currency_rupee_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _SectionTitle('Reports'),
          _ActionTile(
            icon: Icons.calendar_month_rounded,
            title: 'Daily job report',
            subtitle: 'Open and completed job cards',
            color: AppColors.primary,
          ),
          _ActionTile(
            icon: Icons.payments_outlined,
            title: 'Payment report',
            subtitle: 'Paid, pending and partial invoices',
            color: AppColors.success,
          ),
          _ActionTile(
            icon: Icons.inventory_2_outlined,
            title: 'Parts usage',
            subtitle: 'Parts added to job cards and orders',
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }
}

PreferredSizeWidget _simpleAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.textPrimary,
    iconTheme: const IconThemeData(color: AppColors.textPrimary),
    actionsIconTheme: const IconThemeData(color: AppColors.textPrimary),
    surfaceTintColor: Colors.white,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
      onPressed: () => Navigator.pop(context),
    ),
    title: Text(
      context.trText(title),
      style: GoogleFonts.lato(
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    ),
  );
}

class _HeroPanel extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _HeroPanel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.trText(title),
                  style: GoogleFonts.lato(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.trText(subtitle),
                  style: GoogleFonts.lato(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                    height: 1.35,
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

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color),
        title: Text(
          context.trText(title),
          style: GoogleFonts.lato(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          context.trText(subtitle),
          style: GoogleFonts.lato(fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 12, 2, 10),
      child: Text(
        context.trText(title),
        style: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final String title;
  final String body;

  const _FaqTile(this.title, this.body);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 12),
      childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      backgroundColor: Colors.white,
      collapsedBackgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(context.trText(title), style: GoogleFonts.lato(fontWeight: FontWeight.w600)),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(context.trText(body), style: GoogleFonts.lato(fontSize: 12.5)),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 12),
          Text(
            context.trText(value),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            context.trText(title),
            style: GoogleFonts.lato(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
