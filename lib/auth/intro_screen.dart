import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/localization/app_localizations.dart';
import 'package:hornvin/services/storage_service.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<_IntroPage> _pages = [
    _IntroPage(
      imagePath: 'assets/intro_image/intro_one.png',
      icon: Icons.local_shipping_rounded,
      titleKey: 'smart_distribution',
      subtitleKey: 'smart_distribution_subtitle',
      eyebrowKey: 'live_inventory',
      bgColor: Color(0xFFFFF4F4),
      accentColor: AppColors.primary,
      chipIcon: Icons.route_rounded,
      chipLabelKey: 'fast_supply_flow',
    ),
    _IntroPage(
      imagePath: 'assets/intro_image/intro_two.png',
      icon: Icons.receipt_long_rounded,
      titleKey: 'instant_invoicing',
      subtitleKey: 'instant_invoicing_subtitle',
      eyebrowKey: 'easy_billing',
      bgColor: Color(0xFFF1F5FF),
      accentColor: AppColors.secondary,
      chipIcon: Icons.bolt_rounded,
      chipLabelKey: 'quick_billing',
    ),
    _IntroPage(
      imagePath: 'assets/intro_image/intro_one.png',
      icon: Icons.storefront_rounded,
      titleKey: 'garage_marketplace',
      subtitleKey: 'garage_marketplace_subtitle',
      eyebrowKey: 'better_network',
      bgColor: Color(0xFFF0FFF7),
      accentColor: Color(0xFF1F8A4C),
      chipIcon: Icons.handshake_rounded,
      chipLabelKey: 'trusted_partners',
    ),
  ];

  Future<void> _finishIntro() async {
    await StorageService.setIntroSeen();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _nextPage() {
    if (_currentPage == _pages.length - 1) {
      _finishIntro();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 720;
            final horizontalPadding = constraints.maxWidth > 420 ? 32.0 : 22.0;

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    compact ? 12 : 18,
                    horizontalPadding,
                    8,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 136,
                        height: 42,
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _finishIntro,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: Text(
                          context.tr('skip'),
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      return _IntroPageView(
                        page: _pages[index],
                        compact: compact,
                        horizontalPadding: horizontalPadding,
                      );
                    },
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    14,
                    horizontalPadding,
                    compact ? 16 : 24,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 24,
                        offset: const Offset(0, -10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          _FeaturePill(page: page),
                          const Spacer(),
                          _PageIndicator(
                            count: _pages.length,
                            currentIndex: _currentPage,
                            activeColor: page.accentColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: page.accentColor,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentPage == _pages.length - 1
                                    ? context.tr('get_started')
                                    : context.tr('continue'),
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      GestureDetector(
                        onTap: _finishIntro,
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text.rich(
                            TextSpan(
                              text: context.tr('already_have_account'),
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                              children: [
                                TextSpan(
                                  text: context.tr('login'),
                                  style: GoogleFonts.lato(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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

class _IntroPageView extends StatelessWidget {
  final _IntroPage page;
  final bool compact;
  final double horizontalPadding;

  const _IntroPageView({
    required this.page,
    required this.compact,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          SizedBox(height: compact ? 10 : 22),
          Expanded(
            child: Center(
              child: _IntroArtwork(page: page, compact: compact),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: page.accentColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              context.tr(page.eyebrowKey),
              style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: page.accentColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.tr(page.titleKey),
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: compact ? 25 : 29,
              height: 1.14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Text(
              context.tr(page.subtitleKey),
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: compact ? 13 : 14,
                height: 1.55,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(height: compact ? 14 : 26),
        ],
      ),
    );
  }
}

class _IntroArtwork extends StatelessWidget {
  final _IntroPage page;
  final bool compact;

  const _IntroArtwork({required this.page, required this.compact});

  @override
  Widget build(BuildContext context) {
    final size = compact ? 250.0 : 304.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    page.bgColor,
                    AppColors.white,
                    page.accentColor.withValues(alpha: 0.12),
                  ],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 18,
            child: _FloatingIcon(
              icon: page.icon,
              color: page.accentColor,
              size: compact ? 44 : 52,
            ),
          ),
          Positioned(
            bottom: 14,
            left: 14,
            child: _FloatingIcon(
              icon: Icons.verified_rounded,
              color: AppColors.success,
              size: compact ? 38 : 46,
            ),
          ),
          Container(
            width: size * 0.78,
            height: size * 0.78,
            padding: EdgeInsets.all(compact ? 14 : 18),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: page.accentColor.withValues(alpha: 0.18),
                  blurRadius: 34,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Image.asset(page.imagePath, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}

class _FloatingIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const _FloatingIcon({
    required this.icon,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: size * 0.52),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final _IntroPage page;

  const _FeaturePill({required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 190),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: page.accentColor.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(page.chipIcon, size: 17, color: page.accentColor),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              context.tr(page.chipLabelKey),
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: page.accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Color activeColor;

  const _PageIndicator({
    required this.count,
    required this.currentIndex,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final active = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          width: active ? 28 : 8,
          height: 8,
          margin: const EdgeInsets.only(left: 6),
          decoration: BoxDecoration(
            color: active
                ? activeColor
                : AppColors.textSecondary.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _IntroPage {
  final String imagePath;
  final IconData icon;
  final String titleKey;
  final String subtitleKey;
  final String eyebrowKey;
  final Color bgColor;
  final Color accentColor;
  final IconData chipIcon;
  final String chipLabelKey;

  const _IntroPage({
    required this.imagePath,
    required this.icon,
    required this.titleKey,
    required this.subtitleKey,
    required this.eyebrowKey,
    required this.bgColor,
    required this.accentColor,
    required this.chipIcon,
    required this.chipLabelKey,
  });
}
