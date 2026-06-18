import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/localization/app_localizations.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';

class AddPartsWorkbenchScreen extends StatelessWidget {
  const AddPartsWorkbenchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: _toolAppBar(context, 'Add Parts'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ToolHero(
            icon: Icons.add_box_outlined,
            title: 'Parts Workspace',
            subtitle:
                'Add, review and organize spare parts before attaching them to job cards or stock records.',
            color: AppColors.accent,
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(
                child: _MiniMetric(
                  label: 'Draft Parts',
                  value: '0',
                  icon: Icons.inventory_2_outlined,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _MiniMetric(
                  label: 'Ready To Use',
                  value: '0',
                  icon: Icons.check_circle_outline_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionTitle('Quick Actions'),
          _ActionRow(
            icon: Icons.post_add_rounded,
            title: 'Create part entry',
            subtitle: 'Part name, quantity, price and category',
            color: AppColors.primary,
          ),
          _ActionRow(
            icon: Icons.upload_file_rounded,
            title: 'Bulk import parts',
            subtitle: 'Upload stock list from Excel or CSV',
            color: AppColors.secondary,
          ),
          _ActionRow(
            icon: Icons.assignment_outlined,
            title: 'Attach to job card',
            subtitle: 'Use saved parts while creating a job card',
            color: AppColors.success,
          ),
          const SizedBox(height: 10),
          _ComingSoonBand(
            message:
                'Parts workspace is being prepared. For now, add parts directly inside a job card.',
          ),
        ],
      ),
    );
  }
}

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ToolComingSoonScreen(
      title: 'Customers',
      icon: Icons.people_alt_rounded,
      color: Color(0xFFEC4899),
      subtitle:
          'Customer profiles, vehicle history and follow-up reminders will be available here soon.',
      actions: [
        _ToolActionInfo(
          icon: Icons.person_add_alt_1_rounded,
          title: 'Create customer profile',
          subtitle: 'Name, phone, address and vehicles',
        ),
        _ToolActionInfo(
          icon: Icons.directions_car_filled_outlined,
          title: 'Vehicle history',
          subtitle: 'View past job cards and invoices',
        ),
        _ToolActionInfo(
          icon: Icons.notifications_active_outlined,
          title: 'Service reminders',
          subtitle: 'Follow up at the right time',
        ),
      ],
    );
  }
}

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ToolComingSoonScreen(
      title: 'Schedule',
      icon: Icons.calendar_month_rounded,
      color: Color(0xFF7C3AED),
      subtitle:
          'Appointments, mechanic allocation and daily workshop planning are coming soon.',
      actions: [
        _ToolActionInfo(
          icon: Icons.event_available_rounded,
          title: 'Book appointment',
          subtitle: 'Plan service visits by date and time',
        ),
        _ToolActionInfo(
          icon: Icons.engineering_rounded,
          title: 'Assign mechanic',
          subtitle: 'Balance work across your team',
        ),
        _ToolActionInfo(
          icon: Icons.today_rounded,
          title: 'Daily agenda',
          subtitle: 'See all work planned for the day',
        ),
      ],
    );
  }
}

class _ToolComingSoonScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String subtitle;
  final List<_ToolActionInfo> actions;

  const _ToolComingSoonScreen({
    required this.title,
    required this.icon,
    required this.color,
    required this.subtitle,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: _toolAppBar(context, title),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ToolHero(
            icon: icon,
            title: title,
            subtitle: subtitle,
            color: color,
          ),
          const SizedBox(height: 16),
          _ComingSoonBand(message: '$title is coming soon.'),
          const SizedBox(height: 16),
          _SectionTitle('Planned Tools'),
          ...actions.map(
            (action) => _ActionRow(
              icon: action.icon,
              title: action.title,
              subtitle: action.subtitle,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolActionInfo {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ToolActionInfo({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

PreferredSizeWidget _toolAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.textPrimary,
    surfaceTintColor: Colors.white,
    elevation: 0,
    title: Text(
      context.trText(title),
      style: GoogleFonts.lato(
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    ),
  );
}

class _ToolHero extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _ToolHero({
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
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.trText(title),
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  context.trText(subtitle),
                  style: GoogleFonts.lato(
                    fontSize: 12.5,
                    height: 1.4,
                    color: AppColors.textSecondary,
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

class _MiniMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MiniMetric({
    required this.label,
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
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.trText(value),
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  context.trText(label),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    color: AppColors.textSecondary,
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

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 4, 2, 10),
      child: Text(
        context.trText(title),
        style: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _ActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.trText(title),
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.trText(subtitle),
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    color: AppColors.textSecondary,
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

class _ComingSoonBand extends StatelessWidget {
  final String message;

  const _ComingSoonBand({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          const Icon(Icons.schedule_rounded, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.trText(message),
              style: GoogleFonts.lato(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
