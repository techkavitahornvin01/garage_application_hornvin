import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/localization/app_localizations.dart';
import 'package:hornvin/services/storage_service.dart';
import 'package:hornvin/widgets/common_widgets.dart';

class SplashScreen extends StatefulWidget {
  static const String nextRoute = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeIn),
      ),
    );

    _scaleAnim = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.7, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();

    // Check navigation after splash screen
    _checkAndNavigate();
  }

  Future<void> _checkAndNavigate() async {
    // Wait for splash screen animation
    await Future.delayed(const Duration(milliseconds: 2800));

    if (!mounted) return;

    final hasSelectedLanguage = await StorageService.hasSelectedLanguage();
    if (!mounted) return;

    if (!hasSelectedLanguage) {
      Navigator.pushReplacementNamed(context, '/language');
      return;
    }

    if (!mounted) return;
    await _navigateAfterLanguage();
  }

  Future<void> _navigateAfterLanguage() async {
    // Check if user is logged in
    final isLoggedIn = await StorageService.isLoggedIn();
    final token = await StorageService.getToken();

    if (token != null && token.isNotEmpty) {
      if (!isLoggedIn) {
        await StorageService.setLoggedIn(true);
      }
      if (!mounted) return;

      // User has valid token - go directly to home
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      if (isLoggedIn) {
        await StorageService.logout();
      }
      // User not logged in - check if intro has been shown before
      final hasSeenIntro = await StorageService.hasSeenIntro();

      if (!hasSeenIntro) {
        if (!mounted) return;

        // First time launch - show intro screen
        Navigator.pushReplacementNamed(context, '/intro');
      } else {
        if (!mounted) return;

        // User has seen intro before - go to login
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              top: -90,
              right: -80,
              child: Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE31E24).withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              bottom: -110,
              left: -80,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1A237E).withValues(alpha: 0.07),
                ),
              ),
            ),
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeIn,
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 178,
                            height: 178,
                            padding: const EdgeInsets.all(26),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(
                                  0xFFE31E24,
                                ).withValues(alpha: 0.10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF1A237E,
                                  ).withValues(alpha: 0.10),
                                  blurRadius: 34,
                                  offset: const Offset(0, 18),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              HornvinLogo.assetPath,
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) => const Icon(
                                Icons.car_repair_rounded,
                                color: Color(0xFFE31E24),
                                size: 64,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            context.trText('HORNVIN'),
                            style: GoogleFonts.lato(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF1A237E),
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            context.tr('tagline'),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              color: const Color(0xFF757575),
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeIn,
                child: Column(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color(0xFFE31E24).withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.tr('loading'),
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: const Color(0xFF757575),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
