// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hornvin/widgets/app_theme.dart.dart';

// import '../widgets/common_widgets.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailOrPhoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _otpController = TextEditingController();

//   bool _isLoading = false;
//   bool _obscurePassword = true;
//   bool _isOtpSent = false;
//   int _otpTimer = 0;

//   @override
//   void dispose() {
//     _emailOrPhoneController.dispose();
//     _passwordController.dispose();
//     _otpController.dispose();
//     super.dispose();
//   }

//   void _startOtpTimer() {
//     setState(() {
//       _otpTimer = 30;
//     });
//     Future.delayed(const Duration(seconds: 1), () {
//       if (_otpTimer > 0) {
//         setState(() {
//           _otpTimer--;
//         });
//         _startOtpTimer();
//       }
//     });
//   }

//   void _sendOTP() {
//     final phone = _emailOrPhoneController.text.trim();
//     if (phone.length >= 10 && RegExp(r'^[0-9]+$').hasMatch(phone)) {
//       setState(() {
//         _isOtpSent = true;
//         _otpController.clear();
//       });
//       _startOtpTimer();

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(context.trText('OTP sent to $phone')),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(context.trText('Please enter valid 10-digit phone number')),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }

//   void _verifyOTP() {
//     if (_otpController.text.length == 6) {
//       setState(() {
//         _isLoading = true;
//       });

//       Future.delayed(const Duration(milliseconds: 1200), () {
//         if (mounted) {
//           setState(() => _isLoading = false);
//           Navigator.pushReplacementNamed(context, '/home');
//         }
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(context.trText('Please enter valid 6-digit OTP')),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }

//   void _loginWithEmail() {
//     final email = _emailOrPhoneController.text.trim();
//     final password = _passwordController.text.trim();

//     if (email.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(context.trText('Please enter email address')),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       return;
//     }

//     if (password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(context.trText('Please enter password')),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       return;
//     }

//     // Email validation
//     if (!email.contains('@') || !email.contains('.')) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(context.trText('Please enter valid email address')),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);
//     Future.delayed(const Duration(milliseconds: 1200), () {
//       if (mounted) {
//         setState(() => _isLoading = false);
//         Navigator.pushReplacementNamed(context, '/home');
//       }
//     });
//   }

//   void _detectLoginMode() {
//     final input = _emailOrPhoneController.text.trim();

//     if (input.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(context.trText('Please enter email or phone number')),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       return;
//     }

//     // Check if input is email (contains @ and .)
//     final isEmail = input.contains('@') && input.contains('.');

//     if (isEmail) {
//       setState(() {
//         _isOtpSent = false;
//         _otpController.clear();
//       });
//       _loginWithEmail();
//     } else {
//       // Phone number login
//       if (!_isOtpSent) {
//         _sendOTP();
//       } else {
//         _verifyOTP();
//       }
//     }
//   }

//   String _getTitle() {
//     final input = _emailOrPhoneController.text.trim();
//     final isEmail = input.contains('@') && input.contains('.');

//     if (_isOtpSent && !isEmail) {
//       return 'Verify OTP';
//     } else if (isEmail) {
//       return 'Enter Password';
//     } else {
//       return 'Login';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final input = _emailOrPhoneController.text.trim();
//     final isEmail = input.contains('@') && input.contains('.');

//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [AppColors.secondary, Color(0xFF1E3A8A)],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Top logo area
//               Expanded(
//                 flex: 1,
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: 70,
//                         height: 70,
//                         decoration: BoxDecoration(
//                           color: AppColors.primary,
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: AppColors.primary.withValues(alpha: 0.4),
//                               blurRadius: 20,
//                               offset: const Offset(0, 6),
//                             ),
//                           ],
//                         ),
//                         child: const Center(
//                           child: Text(context.trData(//                             'H'),
//                             style: TextStyle(
//                               fontSize: 40,
//                               fontWeight: FontWeight.w900,
//                               color: Colors.white,
//                               height: 1,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 14),
//                       Text(context.trData(//                         'HORNVIN'),
//                         style: GoogleFonts.lato(
//                           fontSize: 26,
//                           fontWeight: FontWeight.w900,
//                           color: Colors.white,
//                           letterSpacing: 4,
//                         ),
//                       ),
//                       Text(context.trData(//                         'Powering Distributors & Garages'),
//                         style: GoogleFonts.lato(
//                           fontSize: 12,
//                           color: Colors.white70,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // Login card
//               Expanded(
//                 flex: 3,
//                 child: Container(
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(28),
//                     ),
//                   ),
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(28),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Dynamic Title based on state
//                         Text(
//                           _getTitle(),
//                           style: GoogleFonts.lato(
//                             fontSize: 24,
//                             fontWeight: FontWeight.w700,
//                             color: AppColors.textPrimary,
//                           ),
//                         ),
//                         Text(
//                           _isOtpSent && !isEmail
//                               ? 'Enter the verification code sent to your phone'
//                               : 'Login to your account',
//                           style: GoogleFonts.lato(
//                             fontSize: 14,
//                             color: AppColors.textSecondary,
//                           ),
//                         ),
//                         const SizedBox(height: 24),

//                         // Single unified field for Email/Phone
//                         TextField(
//                           controller: _emailOrPhoneController,
//                           keyboardType: TextInputType.text,
//                           enabled:
//                               !(_isOtpSent &&
//                                   !isEmail), // Disable when OTP is sent
//                           decoration: InputDecoration(
//                             hintText: context.trText('Email or Phone Number'),
//                             prefixIcon: Icon(
//                               isEmail && _emailOrPhoneController.text.isNotEmpty
//                                   ? Icons.email_outlined
//                                   : Icons.phone_outlined,
//                               color: AppColors.grey,
//                               size: 20,
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: const BorderSide(
//                                 color: AppColors.divider,
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: const BorderSide(
//                                 color: AppColors.primary,
//                                 width: 2,
//                               ),
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 14,
//                             ),
//                             filled: true,
//                             fillColor: _isOtpSent && !isEmail
//                                 ? AppColors.lightGrey
//                                 : Colors.white,
//                           ),
//                           style: GoogleFonts.lato(fontSize: 14),
//                           onChanged: (value) {
//                             setState(() {
//                               if (!value.contains('@') && _isOtpSent) {
//                                 _isOtpSent = false;
//                                 _otpController.clear();
//                                 _passwordController.clear();
//                               }
//                             });
//                           },
//                         ),

//                         const SizedBox(height: 16),

//                         // Password Field (only for email login)
//                         if (isEmail && !_isOtpSent) ...[
//                           TextField(
//                             controller: _passwordController,
//                             obscureText: _obscurePassword,
//                             decoration: InputDecoration(
//                               hintText: context.trText('Password'),
//                               prefixIcon: const Icon(
//                                 Icons.lock_outline,
//                                 color: AppColors.grey,
//                                 size: 20,
//                               ),
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   _obscurePassword
//                                       ? Icons.visibility_off
//                                       : Icons.visibility,
//                                   color: AppColors.grey,
//                                   size: 20,
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//                                     _obscurePassword = !_obscurePassword;
//                                   });
//                                 },
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(
//                                   color: AppColors.divider,
//                                 ),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(
//                                   color: AppColors.primary,
//                                   width: 2,
//                                 ),
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 14,
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                             ),
//                             style: GoogleFonts.lato(fontSize: 14),
//                           ),
//                           const SizedBox(height: 8),
//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: TextButton(
//                               onPressed: () {
//                                 Navigator.pushNamed(
//                                   context,
//                                   '/forgot-password',
//                                 );
//                               },
//                               child: Text(context.trData(//                                 'Forgot Password?'),
//                                 style: GoogleFonts.lato(
//                                   fontSize: 12,
//                                   color: AppColors.primary,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],

//                         // OTP Field (for phone login)
//                         if (_isOtpSent && !isEmail) ...[
//                           TextField(
//                             controller: _otpController,
//                             keyboardType: TextInputType.number,
//                             maxLength: 6,
//                             autofocus: true,
//                             decoration: InputDecoration(
//                               hintText: context.trText('Enter OTP'),
//                               prefixIcon: const Icon(
//                                 Icons.password_outlined,
//                                 color: AppColors.grey,
//                                 size: 20,
//                               ),
//                               suffixIcon: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   if (_otpTimer > 0)
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 8,
//                                         vertical: 4,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: AppColors.lightGrey,
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: Text(
//                                         '00:${_otpTimer.toString().padLeft(2, '0')}',
//                                         style: GoogleFonts.lato(
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w600,
//                                           color: AppColors.primary,
//                                         ),
//                                       ),
//                                     ),
//                                   if (_otpTimer == 0)
//                                     TextButton(
//                                       onPressed: () {
//                                         _sendOTP();
//                                       },
//                                       child: Text(context.trData(//                                         'Resend'),
//                                         style: GoogleFonts.lato(
//                                           fontSize: 12,
//                                           color: AppColors.primary,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                               counterText: '',
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(
//                                   color: AppColors.divider,
//                                 ),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(
//                                   color: AppColors.primary,
//                                   width: 2,
//                                 ),
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 14,
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                             ),
//                             style: GoogleFonts.lato(fontSize: 14),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(context.trData(//                             'We sent a verification code to ${_emailOrPhoneController.text}'),
//                             style: GoogleFonts.lato(
//                               fontSize: 11,
//                               color: AppColors.textSecondary,
//                             ),
//                           ),
//                         ],

//                         const SizedBox(height: 24),

//                         // Dynamic Button
//                         PrimaryButton(
//                           label: _isOtpSent && !isEmail
//                               ? 'Verify & Login'
//                               : 'Continue',
//                           isLoading: _isLoading,
//                           onPressed: _detectLoginMode,
//                         ),

//                         const SizedBox(height: 20),

//                         Row(
//                           children: [
//                             const Expanded(child: Divider()),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                               ),
//                               child: Text(context.trData(//                                 'OR'),
//                                 style: GoogleFonts.lato(
//                                   fontSize: 12,
//                                   color: AppColors.grey,
//                                 ),
//                               ),
//                             ),
//                             const Expanded(child: Divider()),
//                           ],
//                         ),

//                         const SizedBox(height: 20),

//                         // Social login
//                         OutlinedButton.icon(
//                           onPressed: () {},
//                           icon: const Icon(
//                             Icons.g_mobiledata,
//                             size: 24,
//                             color: Colors.red,
//                           ),
//                           label: Text(context.trData(//                             'Continue with Google'),
//                             style: GoogleFonts.lato(
//                               fontSize: 14,
//                               color: AppColors.textPrimary,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           style: OutlinedButton.styleFrom(
//                             minimumSize: const Size(double.infinity, 50),
//                             side: const BorderSide(color: AppColors.divider),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 20),

//                         Center(
//                           child: GestureDetector(
//                             onTap: () =>
//                                 Navigator.pushNamed(context, '/signup'),
//                             child: RichText(
//                               text: TextSpan(
//                                 text: "Don't have an account? ",
//                                 style: GoogleFonts.lato(
//                                   fontSize: 13,
//                                   color: AppColors.textSecondary,
//                                 ),
//                                 children: [
//                                   TextSpan(
//                                     text: 'Sign Up',
//                                     style: GoogleFonts.lato(
//                                       fontSize: 13,
//                                       color: AppColors.primary,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/localization/app_localizations.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';
import '../widgets/common_widgets.dart';
import '../controllers/login_controller.dart';
import '../services/storage_service.dart';
import '../widgets/custom_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController(); // Email or Phone
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _initializeStorage();
  }

  Future<void> _initializeStorage() async {
    await StorageService.init();
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Login with email or phone
  Future<void> _login() async {
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text.trim();

    // Validation
    if (identifier.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('enter_email_or_phone')),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('enter_password')),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Check if identifier is email or phone
    final isEmail = identifier.contains('@') && identifier.contains('.');

    if (isEmail) {
      // Email validation
      if (!_isValidEmail(identifier)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr('enter_valid_email')),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    } else {
      // Phone validation (10 digits)
      final phoneCleaned = identifier.replaceAll(RegExp(r'\D'), '');
      if (phoneCleaned.length != 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr('enter_valid_phone')),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      String email = identifier;

      // Format phone number if it's a phone login
      if (!isEmail) {
        email = LoginController.formatPhoneNumber(identifier);
      }

      // Call API for login
      final response = await LoginController.login(
        email: email,
        password: password,
      );

      if (response['success']) {
        if (LoginController.requiresAdminApproval(response)) {
          await StorageService.logout();
          if (mounted) {
            _showInactiveAccountDialog(
              LoginController.getErrorMessage(response),
            );
          }
          return;
        }

        // Save user session
        await LoginController.saveUserSession(response);
        final savedToken = await StorageService.getToken();
        if (savedToken == null || savedToken.isEmpty) {
          if (mounted) {
            CustomDialog.showErrorDialog(
              context,
              context.tr('login_token_missing'),
            );
          }
          return;
        }

        if (mounted) {
          CustomDialog.showSuccessDialog(
            context,
            context.tr('login_success'),
            () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          );
        }
      } else {
        // Handle error with special message for inactive account
        String errorMessage = LoginController.getErrorMessage(response);

        if (mounted) {
          // Check if it's the inactive account error (403)
          if (response['statusCode'] == 403 ||
              errorMessage.contains('inactive') ||
              errorMessage.contains('admin approval')) {
            _showInactiveAccountDialog(errorMessage);
          } else {
            CustomDialog.showErrorDialog(context, errorMessage);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        CustomDialog.showErrorDialog(
          context,
          LoginController.getExceptionMessage(e),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Show special dialog for inactive account (admin approval pending)
  void _showInactiveAccountDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings,
                    size: 64,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  context.tr('admin_approval_pending'),
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  context.trData(message),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  context.tr('approval_notify'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      context.tr('ok'),
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final identifier = _identifierController.text.trim();
    final isEmail = identifier.contains('@') && identifier.contains('.');
    final isPhone = !isEmail && identifier.isNotEmpty;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.secondary, Color(0xFF1E3A8A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top logo area
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 148,
                        height: 56,
                        child: Image.asset(
                          HornvinLogo.assetPath,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        context.trText('HORNVIN'),
                        style: GoogleFonts.lato(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 4,
                        ),
                      ),
                      Text(
                        context.tr('tagline'),
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Login card
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          context.tr('welcome_back'),
                          style: GoogleFonts.lato(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          context.tr('login_to_account'),
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Email/Phone field
                        TextField(
                          controller: _identifierController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: context.tr('email_or_phone'),
                            prefixIcon: Icon(
                              isEmail
                                  ? Icons.email_outlined
                                  : isPhone
                                  ? Icons.phone_outlined
                                  : Icons.person_outline,
                              color: AppColors.grey,
                              size: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.divider,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          style: GoogleFonts.lato(fontSize: 14),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),

                        const SizedBox(height: 16),

                        // Password Field
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: context.tr('password'),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: AppColors.grey,
                              size: 20,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.grey,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.divider,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          style: GoogleFonts.lato(fontSize: 14),
                        ),

                        const SizedBox(height: 8),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/forgot-password');
                            },
                            child: Text(
                              context.tr('forgot_password'),
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Login Button
                        PrimaryButton(
                          label: context.tr('login'),
                          isLoading: _isLoading,
                          onPressed: _login,
                        ),

                        const SizedBox(height: 20),

                        // OR Divider
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                context.tr('or'),
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  color: AppColors.grey,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Social login
                        OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(context.tr('google_login_soon')),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.g_mobiledata,
                            size: 24,
                            color: Colors.red,
                          ),
                          label: Text(
                            context.tr('continue_google'),
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            side: const BorderSide(color: AppColors.divider),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Sign Up link
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(
                              context,
                              '/signup',
                            ),
                            child: RichText(
                              text: TextSpan(
                                text: context.tr('dont_have_account'),
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                                children: [
                                  TextSpan(
                                    text: context.tr('sign_up'),
                                    style: GoogleFonts.lato(
                                      fontSize: 13,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
