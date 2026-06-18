import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/controllers/language_controller.dart';
import 'package:hornvin/localization/app_localizations.dart';
import 'package:hornvin/screens/splash_screen.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';
import 'package:hornvin/widgets/common_widgets.dart';
import 'package:hornvin/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'en';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = context.read<LanguageController>().locale.languageCode;
  }

  Future<void> _continue() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      await context.read<LanguageController>().changeLanguage(
        _selectedLanguage,
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, SplashScreen.nextRoute);
      }
    } catch (e) {
      if (mounted) {
        CustomDialog.showErrorDialog(
          context,
          e.toString().replaceFirst('Exception:', '').trim(),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              Center(
                child: SizedBox(
                  width: 164,
                  height: 62,
                  child: Image.asset(
                    HornvinLogo.assetPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                context.tr('choose_language'),
                style: GoogleFonts.lato(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.tr('choose_language_subtitle'),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),
              _LanguageOption(
                title: context.tr('english'),
                subtitle: 'English',
                code: 'en',
                selectedCode: _selectedLanguage,
                onTap: () => setState(() => _selectedLanguage = 'en'),
              ),
              const SizedBox(height: 14),
              _LanguageOption(
                title: context.tr('hindi'),
                subtitle: 'हिंदी',
                code: 'hi',
                selectedCode: _selectedLanguage,
                onTap: () => setState(() => _selectedLanguage = 'hi'),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: AppColors.white,
                          ),
                        )
                      : Text(
                          context.tr('continue'),
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final String code;
  final String selectedCode;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.title,
    required this.subtitle,
    required this.code,
    required this.selectedCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = code == selectedCode;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                code.toUpperCase(),
                style: GoogleFonts.lato(
                  color: selected ? AppColors.white : AppColors.secondary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.trData(title),
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.trData(subtitle),
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected ? AppColors.primary : AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
