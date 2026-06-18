import 'package:hornvin/localization/app_localizations.dart';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hornvin/widgets/app_theme.dart.dart';
// import '../widgets/common_widgets.dart';
// import '../controllers/signup_controller.dart';
// import '../services/storage_service.dart';
// import '../utils/validation_helper.dart';
// import '../widgets/custom_dialog.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _fullNameController = TextEditingController();
//   final _garageNameController = TextEditingController();
//   final _phoneNumberController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   bool _isLoading = false;
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   bool _agreeToTerms = false;

//   String? _selectedGarageType;

//   // Garage type options (matching API)
//   final List<String> _garageTypes = SignupController.getGarageTypes();

//   @override
//   void initState() {
//     super.initState();
//     _initializeStorage();
//   }

//   Future<void> _initializeStorage() async {
//     await StorageService.init();
//   }

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _garageNameController.dispose();
//     _phoneNumberController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleSignup() async {
//     // Validate form
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     // Check terms agreement
//     if (!_agreeToTerms) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(context.trData(//             'Please agree to the Terms of Service and Privacy Policy'),
//             style: GoogleFonts.lato(fontSize: 12),
//           ),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     // Show loading dialog
//     CustomDialog.showLoadingDialog(context);

//     try {
//       // Format phone number
//       String formattedPhoneNumber = SignupController.formatPhoneNumber(
//         _phoneNumberController.text.trim(),
//       );

//       // Make API call through controller
//       final response = await SignupController.register(
//         name: _fullNameController.text.trim(),
//         businessName: _garageNameController.text.trim(),
//         phoneNumber: formattedPhoneNumber,
//         garageType: _selectedGarageType!,
//         email: _emailController.text.trim(),
//         password: _passwordController.text,
//         confirmPassword: _confirmPasswordController.text,
//       );

//       // Hide loading dialog
//       if (mounted) {
//         Navigator.pop(context);
//       }

//       if (response['success']) {
//         await StorageService.savePhoneNumber(formattedPhoneNumber);
//         final waitForApproval = _requiresAdminApproval(response);
//         if (waitForApproval) {
//           await StorageService.logout();
//         } else {
//           await _saveSignupSession(response);
//         }

//         if (!mounted) return;
//         CustomDialog.showSuccessDialog(
//           context,
//           waitForApproval
//               ? 'Registration successful. Please wait for admin approval.'
//               : response['message']?.toString() ?? 'Registration successful',
//           () {
//             if (!waitForApproval && _hasAuthToken(response)) {
//               Navigator.pushReplacementNamed(context, '/home');
//             } else {
//               Navigator.pushReplacementNamed(context, '/login');
//             }
//           },
//         );
//       } else {
//         // Show error dialog
//         if (mounted) {
//           CustomDialog.showErrorDialog(context, response['message']);
//         }
//       }
//     } catch (e) {
//       // Hide loading dialog if still showing
//       if (mounted && Navigator.canPop(context)) {
//         Navigator.pop(context);
//       }

//       // Show error dialog
//       if (mounted) {
//         CustomDialog.showErrorDialog(
//           context,
//           'An unexpected error occurred. Please try again.',
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> _saveSignupSession(Map<String, dynamic> response) async {
//     final data = response['data'];
//     if (data is Map<String, dynamic>) {
//       final token = data['token']?.toString();
//       if (token != null && token.isNotEmpty) {
//         await StorageService.saveToken(token);
//         await StorageService.setLoggedIn(true);
//       }

//       final user = data['user'];
//       if (user is Map<String, dynamic>) {
//         await StorageService.saveUserData(user);
//       }
//     }
//   }

//   bool _hasAuthToken(Map<String, dynamic> response) {
//     final data = response['data'];
//     return data is Map<String, dynamic> &&
//         data['token'] != null &&
//         data['token'].toString().isNotEmpty;
//   }

//   bool _requiresAdminApproval(Map<String, dynamic> response) {
//     final message = (response['message'] ?? '').toString().toLowerCase();
//     final data = response['data'];
//     final dataMap = data is Map ? data : const {};
//     final user = dataMap['user'];
//     final userMap = user is Map ? user : const {};
//     final approvalStatus =
//         (userMap['approvalStatus'] ??
//                 userMap['approval_status'] ??
//                 dataMap['approvalStatus'] ??
//                 dataMap['approval_status'] ??
//                 '')
//             .toString()
//             .toLowerCase();
//     final isActive = userMap['isActive'] ?? dataMap['isActive'];

//     return message.contains('admin approval') ||
//         message.contains('please wait for admin') ||
//         message.contains('pending approval') ||
//         approvalStatus.contains('pending') ||
//         isActive == false;
//   }

//   @override
//   Widget build(BuildContext context) {
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
//                       SizedBox(
//                         width: 142,
//                         height: 54,
//                         child: Image.asset(
//                           HornvinLogo.assetPath,
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(context.trData(//                         'Create Account'),
//                         style: GoogleFonts.lato(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // Signup card
//               Expanded(
//                 flex: 4,
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
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(context.trData(//                             'Join Hornvin Today!'),
//                             style: GoogleFonts.lato(
//                               fontSize: 24,
//                               fontWeight: FontWeight.w700,
//                               color: AppColors.textPrimary,
//                             ),
//                           ),
//                           Text(context.trData(//                             'Create your account to get started'),
//                             style: GoogleFonts.lato(
//                               fontSize: 14,
//                               color: AppColors.textSecondary,
//                             ),
//                           ),
//                           const SizedBox(height: 24),

//                           // Full Name field
//                           TextFormField(
//                             controller: _fullNameController,
//                             validator: ValidationHelper.validateFullName,
//                             decoration: InputDecoration(
//                               hintText: context.trText('Full Name'),
//                               prefixIcon: const Icon(
//                                 Icons.person_outline,
//                                 color: AppColors.grey,
//                                 size: 20,
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
//                               errorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(
//                                   color: Colors.red,
//                                   width: 1,
//                                 ),
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 14,
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                             ),
//                             style: GoogleFonts.lato(
//                               fontSize: 14,
//                               color: AppColors.textPrimary,
//                             ),
//                           ),

//                           const SizedBox(height: 16),

//                           // Business/Garage Name field
//                           TextFormField(
//                             controller: _garageNameController,
//                             validator: ValidationHelper.validateGarageName,
//                             decoration: InputDecoration(
//                               hintText: context.trText('Business/Garage Name'),
//                               prefixIcon: const Icon(
//                                 Icons.business_outlined,
//                                 color: AppColors.grey,
//                                 size: 20,
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
//                               errorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(
//                                   color: Colors.red,
//                                   width: 1,
//                                 ),
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 14,
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                             ),
//                             style: GoogleFonts.lato(
//                               fontSize: 14,
//                               color: AppColors.textPrimary,
//                             ),
//                           ),

//                           const SizedBox(height: 16),

//                           // Phone Number field
//                           TextFormField(
//                             controller: _phoneNumberController,
//                             keyboardType: TextInputType.phone,
//                             validator: ValidationHelper.validatePhoneNumber,
//                             decoration: InputDecoration(
//                               hintText: context.trText('Phone Number'),
//                               prefixIcon: const Icon(
//                                 Icons.phone_outlined,
//                                 color: AppColors.grey,
//                                 size: 20,
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
//                               errorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(
//                                   color: Colors.red,
//                                   width: 1,
//                                 ),
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 14,
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                             ),
//                             style: GoogleFonts.lato(
//                               fontSize: 14,
//                               color: AppColors.textPrimary,
//                             ),
//                           ),

//                           const SizedBox(height: 16),

//                           // Garage Type dropdown
//                           DropdownButtonFormField<String>(
//                             value: _selectedGarageType,
//                             hint: Text(context.trData(//                               'Garage Type'),
//                               style: GoogleFonts.lato(
//                                 fontSize: 14,
//                                 color: AppColors.grey,
//                               ),
//                             ),
//                             validator: ValidationHelper.validateBusinessType,
//                             decoration: InputDecoration(
//                               prefixIcon: const Icon(
//                                 Icons.category_outlined,
//                                 color: AppColors.grey,
//                                 size: 20,
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
//                               errorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(
//                                   color: Colors.red,
//                                   width: 1,
//                                 ),
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 14,
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                             ),
//                             icon: const Icon(
//                               Icons.arrow_drop_down,
//                               color: AppColors.grey,
//                             ),
//                             isExpanded: true,
//                             items: _garageTypes.map((String type) {
//                               return DropdownMenuItem<String>(
//                                 value: type,
//                                 child: Text(
//                                   SignupController.getDisplayNameForGarageType(
//                                     type,
//                                   ),
//                                   style: GoogleFonts.lato(
//                                     fontSize: 14,
//                                     color: AppColors.textPrimary,
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                             onChanged: (String? newValue) {
//                               setState(() {
//                                 _selectedGarageType = newValue;
//                               });
//                             },
//                             style: GoogleFonts.lato(
//                               fontSize: 14,
//                               color: AppColors.textPrimary,
//                             ),
//                             dropdownColor: Colors.white,
//                             menuMaxHeight: 300,
//                           ),

//                           const SizedBox(height: 16),

//                           // Email field
//                           TextFormField(
//                             controller: _emailController,
//                             keyboardType: TextInputType.emailAddress,
//                             validator: ValidationHelper.validateEmail,
//                             decoration: InputDecoration(
//                               hintText: context.trText('Email Address'),
//                               prefixIcon: const Icon(
//                                 Icons.email_outlined,
//                                 color: AppColors.grey,
//                                 size: 20,
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
//                               errorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(
//                                   color: Colors.red,
//                                   width: 1,
//                                 ),
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 14,
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                             ),
//                             style: GoogleFonts.lato(
//                               fontSize: 14,
//                               color: AppColors.textPrimary,
//                             ),
//                           ),

//                           const SizedBox(height: 16),

//                           // Password field
//                           TextFormField(
//                             controller: _passwordController,
//                             obscureText: _obscurePassword,
//                             validator: ValidationHelper.validatePassword,
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
//                               errorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(
//                                   color: Colors.red,
//                                   width: 1,
//                                 ),
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 14,
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                             ),
//                             style: GoogleFonts.lato(
//                               fontSize: 14,
//                               color: AppColors.textPrimary,
//                             ),
//                           ),

//                           // Password strength indicator
//                           if (_passwordController.text.isNotEmpty)
//                             Padding(
//                               padding: const EdgeInsets.only(top: 8),
//                               child: _buildPasswordStrengthIndicator(),
//                             ),

//                           const SizedBox(height: 16),

//                           // Confirm Password field
//                           TextFormField(
//                             controller: _confirmPasswordController,
//                             obscureText: _obscureConfirmPassword,
//                             validator: (value) =>
//                                 ValidationHelper.validateConfirmPassword(
//                                   value,
//                                   _passwordController.text,
//                                 ),
//                             decoration: InputDecoration(
//                               hintText: context.trText('Confirm Password'),
//                               prefixIcon: const Icon(
//                                 Icons.lock_outline,
//                                 color: AppColors.grey,
//                                 size: 20,
//                               ),
//                               suffixIcon: IconButton(
//                                 icon: Icon(
//                                   _obscureConfirmPassword
//                                       ? Icons.visibility_off
//                                       : Icons.visibility,
//                                   color: AppColors.grey,
//                                   size: 20,
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//                                     _obscureConfirmPassword =
//                                         !_obscureConfirmPassword;
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
//                               errorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(
//                                   color: Colors.red,
//                                   width: 1,
//                                 ),
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 14,
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                             ),
//                             style: GoogleFonts.lato(
//                               fontSize: 14,
//                               color: AppColors.textPrimary,
//                             ),
//                           ),

//                           const SizedBox(height: 16),

//                           // Terms and conditions
//                           Row(
//                             children: [
//                               SizedBox(
//                                 width: 24,
//                                 height: 24,
//                                 child: Checkbox(
//                                   value: _agreeToTerms,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _agreeToTerms = value ?? false;
//                                     });
//                                   },
//                                   activeColor: AppColors.primary,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: RichText(
//                                   text: TextSpan(
//                                     text: 'I agree to the ',
//                                     style: GoogleFonts.lato(
//                                       fontSize: 12,
//                                       color: AppColors.textSecondary,
//                                     ),
//                                     children: [
//                                       TextSpan(
//                                         text: 'Terms of Service',
//                                         style: GoogleFonts.lato(
//                                           fontSize: 12,
//                                           color: AppColors.primary,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                       TextSpan(
//                                         text: ' and ',
//                                         style: GoogleFonts.lato(
//                                           fontSize: 12,
//                                           color: AppColors.textSecondary,
//                                         ),
//                                       ),
//                                       TextSpan(
//                                         text: 'Privacy Policy',
//                                         style: GoogleFonts.lato(
//                                           fontSize: 12,
//                                           color: AppColors.primary,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),

//                           const SizedBox(height: 24),

//                           PrimaryButton(
//                             label: 'Sign Up',
//                             isLoading: _isLoading,
//                             onPressed: _agreeToTerms ? _handleSignup : null,
//                           ),

//                           const SizedBox(height: 20),

//                           Row(
//                             children: [
//                               const Expanded(child: Divider()),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                 ),
//                                 child: Text(context.trData(//                                   'OR'),
//                                   style: GoogleFonts.lato(
//                                     fontSize: 12,
//                                     color: AppColors.grey,
//                                   ),
//                                 ),
//                               ),
//                               const Expanded(child: Divider()),
//                             ],
//                           ),

//                           const SizedBox(height: 20),

//                           // Social signup
//                           OutlinedButton.icon(
//                             onPressed: () {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(context.trText('Google Sign-up coming soon!')),
//                                 ),
//                               );
//                             },
//                             icon: const Icon(
//                               Icons.g_mobiledata,
//                               size: 24,
//                               color: Colors.red,
//                             ),
//                             label: Text(context.trData(//                               'Sign up with Google'),
//                               style: GoogleFonts.lato(
//                                 fontSize: 14,
//                                 color: AppColors.textPrimary,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             style: OutlinedButton.styleFrom(
//                               minimumSize: const Size(double.infinity, 50),
//                               side: const BorderSide(color: AppColors.divider),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 20),

//                           Center(
//                             child: GestureDetector(
//                               onTap: () => Navigator.pushReplacementNamed(
//                                 context,
//                                 '/login',
//                               ),
//                               child: RichText(
//                                 text: TextSpan(
//                                   text: 'Already have an account? ',
//                                   style: GoogleFonts.lato(
//                                     fontSize: 13,
//                                     color: AppColors.textSecondary,
//                                   ),
//                                   children: [
//                                     TextSpan(
//                                       text: 'Login',
//                                       style: GoogleFonts.lato(
//                                         fontSize: 13,
//                                         color: AppColors.primary,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
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

//   Widget _buildPasswordStrengthIndicator() {
//     final strength = SignupController.checkPasswordStrength(
//       _passwordController.text,
//     );
//     int strengthCount = strength.values.where((v) => v == true).length;

//     Color getColor() {
//       if (strengthCount <= 2) return Colors.red;
//       if (strengthCount <= 3) return Colors.orange;
//       if (strengthCount <= 4) return Colors.green;
//       return Colors.green;
//     }

//     String getMessage() {
//       if (strengthCount <= 2) return 'Weak password';
//       if (strengthCount <= 3) return 'Fair password';
//       if (strengthCount <= 4) return 'Good password';
//       return 'Strong password';
//     }

//     return Column(
//       children: [
//         LinearProgressIndicator(
//           value: strengthCount / 5,
//           backgroundColor: Colors.grey[200],
//           color: getColor(),
//           minHeight: 4,
//           borderRadius: BorderRadius.circular(2),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           getMessage(),
//           style: GoogleFonts.lato(fontSize: 10, color: getColor()),
//         ),
//       ],
//     );
//   }
// }

// // OTP Verification Dialog Widget
// class OtpVerificationDialog extends StatefulWidget {
//   final String phoneNumber;
//   final VoidCallback onVerified;

//   const OtpVerificationDialog({
//     super.key,
//     required this.phoneNumber,
//     required this.onVerified,
//   });

//   @override
//   State<OtpVerificationDialog> createState() => _OtpVerificationDialogState();
// }

// class _OtpVerificationDialogState extends State<OtpVerificationDialog> {
//   final TextEditingController _otpController = TextEditingController();
//   bool _isLoading = false;

//   Future<void> _verifyOtp() async {
//     if (_otpController.text.length != 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(context.trText('Please enter a valid 6-digit OTP'))),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final response = await SignupController.verifyOtp(
//         phoneNumber: widget.phoneNumber,
//         otp: _otpController.text,
//       );

//       if (response['success']) {
//         // Save token if provided
//         if (response['data'] != null && response['data']['token'] != null) {
//           await StorageService.saveToken(response['data']['token']);
//         }
//         await StorageService.setLoggedIn(true);

//         if (mounted) {
//           Navigator.pop(context); // Close dialog
//           widget.onVerified(); // Navigate to home
//         }
//       } else {
//         if (mounted) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(response['message'])));
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(context.trText('OTP verification failed. Please try again.')),
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Container(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.verified_user, size: 64, color: AppColors.primary),
//             const SizedBox(height: 16),
//             Text(context.trData(//               'Verify OTP'),
//               style: GoogleFonts.lato(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(context.trData(//               'We have sent a verification code to'),
//               style: GoogleFonts.lato(
//                 fontSize: 14,
//                 color: AppColors.textSecondary,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             Text(context.trData(//               widget.phoneNumber),
//               style: GoogleFonts.lato(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.primary,
//               ),
//             ),
//             const SizedBox(height: 24),
//             TextFormField(
//               controller: _otpController,
//               keyboardType: TextInputType.number,
//               maxLength: 6,
//               decoration: InputDecoration(
//                 hintText: context.trText('Enter OTP'),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 counterText: '',
//               ),
//               textAlign: TextAlign.center,
//               style: GoogleFonts.lato(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 24),
//             PrimaryButton(
//               label: 'Verify',
//               isLoading: _isLoading,
//               onPressed: _verifyOtp,
//             ),
//             const SizedBox(height: 12),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 // Resend OTP logic can be added here
//               },
//               child: Text(context.trData(//                 'Resend OTP'),
//                 style: GoogleFonts.lato(color: AppColors.primary),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';
import '../widgets/common_widgets.dart';
import '../controllers/signup_controller.dart';
import '../services/storage_service.dart';
import '../utils/validation_helper.dart';
import '../widgets/custom_dialog.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _garageNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  String? _selectedGarageType;

  final List<Map<String, String>> _garageTypes = [
    {'label': '2 Wheeler', 'value': '2W'},
    {'label': '3 Wheeler', 'value': '3W'},
    {'label': '4 Wheeler', 'value': '4W'},
  ];

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
    _fullNameController.dispose();
    _garageNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.trText(
              'Please agree to the Terms of Service and Privacy Policy',
            ),
            style: GoogleFonts.lato(fontSize: 12),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    CustomDialog.showLoadingDialog(context);

    try {
      String formattedPhoneNumber = SignupController.formatPhoneNumber(
        _phoneNumberController.text.trim(),
      );

      final response = await SignupController.register(
        name: _fullNameController.text.trim(),
        businessName: _garageNameController.text.trim(),
        phoneNumber: formattedPhoneNumber,
        garageType: _selectedGarageType!,
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      if (mounted) {
        Navigator.pop(context);
      }

      if (response['success']) {
        await StorageService.savePhoneNumber(formattedPhoneNumber);

        final waitForApproval = _requiresAdminApproval(response);

        if (waitForApproval) {
          await StorageService.logout();
        } else {
          await _saveSignupSession(response);
        }

        if (!mounted) return;

        CustomDialog.showSuccessDialog(
          context,
          waitForApproval
              ? 'Registration successful. Please wait for admin approval.'
              : response['message']?.toString() ?? 'Registration successful',
          () {
            if (!waitForApproval && _hasAuthToken(response)) {
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
        );
      } else {
        if (mounted) {
          CustomDialog.showErrorDialog(
            context,
            response['message']?.toString() ?? 'Registration failed',
          );
        }
      }
    } catch (e) {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (mounted) {
        CustomDialog.showErrorDialog(
          context,
          'An unexpected error occurred. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveSignupSession(Map<String, dynamic> response) async {
    final data = response['data'];

    if (data is Map<String, dynamic>) {
      final token = data['token']?.toString();

      if (token != null && token.isNotEmpty) {
        await StorageService.saveToken(token);
        await StorageService.setLoggedIn(true);
      }

      final user = data['user'];

      if (user is Map<String, dynamic>) {
        await StorageService.saveUserData(user);
      }
    }
  }

  bool _hasAuthToken(Map<String, dynamic> response) {
    final data = response['data'];

    return data is Map<String, dynamic> &&
        data['token'] != null &&
        data['token'].toString().isNotEmpty;
  }

  bool _requiresAdminApproval(Map<String, dynamic> response) {
    final message = (response['message'] ?? '').toString().toLowerCase();
    final data = response['data'];
    final dataMap = data is Map ? data : const {};
    final user = dataMap['user'];
    final userMap = user is Map ? user : const {};

    final approvalStatus =
        (userMap['approvalStatus'] ??
                userMap['approval_status'] ??
                dataMap['approvalStatus'] ??
                dataMap['approval_status'] ??
                '')
            .toString()
            .toLowerCase();

    final isActive = userMap['isActive'] ?? dataMap['isActive'];

    return message.contains('admin approval') ||
        message.contains('please wait for admin') ||
        message.contains('pending approval') ||
        approvalStatus.contains('pending') ||
        isActive == false;
  }

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 142,
                        height: 54,
                        child: Image.asset(
                          HornvinLogo.assetPath,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        context.trText('Create Account'),
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                flex: 4,
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.trText('Join Hornvin Today!'),
                            style: GoogleFonts.lato(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            context.trText(
                              'Create your account to get started',
                            ),
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          TextFormField(
                            controller: _fullNameController,
                            validator: ValidationHelper.validateFullName,
                            decoration: _inputDecoration(
                              hintText: context.trText('Full Name'),
                              icon: Icons.person_outline,
                            ),
                            style: _inputTextStyle(),
                          ),

                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _garageNameController,
                            validator: ValidationHelper.validateGarageName,
                            decoration: _inputDecoration(
                              hintText: context.trText('Business/Garage Name'),
                              icon: Icons.business_outlined,
                            ),
                            style: _inputTextStyle(),
                          ),

                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.phone,
                            validator: ValidationHelper.validatePhoneNumber,
                            decoration: _inputDecoration(
                              hintText: context.trText('Phone Number'),
                              icon: Icons.phone_outlined,
                            ),
                            style: _inputTextStyle(),
                          ),

                          const SizedBox(height: 16),

                          DropdownButtonFormField<String>(
                            value: _selectedGarageType,
                            hint: Text(
                              context.trText('Garage Type'),
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: AppColors.grey,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select garage type';
                              }
                              return null;
                            },
                            decoration: _inputDecoration(
                              hintText: '',
                              icon: Icons.category_outlined,
                            ),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.grey,
                            ),
                            isExpanded: true,
                            items: _garageTypes.map((type) {
                              return DropdownMenuItem<String>(
                                value: type['value'],
                                child: Text(
                                  context.trData(type['label']!),
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedGarageType = newValue;
                              });
                            },
                            style: _inputTextStyle(),
                            dropdownColor: Colors.white,
                            menuMaxHeight: 300,
                          ),

                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: ValidationHelper.validateEmail,
                            decoration: _inputDecoration(
                              hintText: context.trText('Email Address'),
                              icon: Icons.email_outlined,
                            ),
                            style: _inputTextStyle(),
                          ),

                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            validator: ValidationHelper.validatePassword,
                            decoration: _inputDecoration(
                              hintText: context.trText('Password'),
                              icon: Icons.lock_outline,
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
                            ),
                            style: _inputTextStyle(),
                          ),

                          if (_passwordController.text.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: _buildPasswordStrengthIndicator(),
                            ),

                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            validator: (value) =>
                                ValidationHelper.validateConfirmPassword(
                                  value,
                                  _passwordController.text,
                                ),
                            decoration: _inputDecoration(
                              hintText: context.trText('Confirm Password'),
                              icon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.grey,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            style: _inputTextStyle(),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _agreeToTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      _agreeToTerms = value ?? false;
                                    });
                                  },
                                  activeColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'I agree to the ',
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Terms of Service',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' and ',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          PrimaryButton(
                            label: 'Sign Up',
                            isLoading: _isLoading,
                            onPressed: _agreeToTerms ? _handleSignup : null,
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  context.trText('OR'),
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

                          OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    context.trText(
                                      'Google Sign-up coming soon!',
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.g_mobiledata,
                              size: 24,
                              color: Colors.red,
                            ),
                            label: Text(
                              context.trText('Sign up with Google'),
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

                          Center(
                            child: GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(
                                context,
                                '/login',
                              ),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Already have an account? ',
                                  style: GoogleFonts.lato(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Login',
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText.isEmpty ? null : hintText,
      prefixIcon: Icon(icon, color: AppColors.grey, size: 20),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: Colors.white,
    );
  }

  TextStyle _inputTextStyle() {
    return GoogleFonts.lato(fontSize: 14, color: AppColors.textPrimary);
  }

  Widget _buildPasswordStrengthIndicator() {
    final strength = SignupController.checkPasswordStrength(
      _passwordController.text,
    );

    int strengthCount = strength.values.where((v) => v == true).length;

    Color getColor() {
      if (strengthCount <= 2) return Colors.red;
      if (strengthCount <= 3) return Colors.orange;
      if (strengthCount <= 4) return Colors.green;
      return Colors.green;
    }

    String getMessage() {
      if (strengthCount <= 2) return 'Weak password';
      if (strengthCount <= 3) return 'Fair password';
      if (strengthCount <= 4) return 'Good password';
      return 'Strong password';
    }

    return Column(
      children: [
        LinearProgressIndicator(
          value: strengthCount / 5,
          backgroundColor: Colors.grey[200],
          color: getColor(),
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
        ),
        const SizedBox(height: 4),
        Text(
          getMessage(),
          style: GoogleFonts.lato(fontSize: 10, color: getColor()),
        ),
      ],
    );
  }
}

class OtpVerificationDialog extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback onVerified;

  const OtpVerificationDialog({
    super.key,
    required this.phoneNumber,
    required this.onVerified,
  });

  @override
  State<OtpVerificationDialog> createState() => _OtpVerificationDialogState();
}

class _OtpVerificationDialogState extends State<OtpVerificationDialog> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.trText('Please enter a valid 6-digit OTP')),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await SignupController.verifyOtp(
        phoneNumber: widget.phoneNumber,
        otp: _otpController.text,
      );

      if (response['success']) {
        if (response['data'] != null && response['data']['token'] != null) {
          await StorageService.saveToken(response['data']['token']);
        }

        await StorageService.setLoggedIn(true);

        if (mounted) {
          Navigator.pop(context);
          widget.onVerified();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(response['message'])));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.trText('OTP verification failed. Please try again.'),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified_user, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              context.trText('Verify OTP'),
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.trText('We have sent a verification code to'),
              style: GoogleFonts.lato(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              context.trData(widget.phoneNumber),
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                hintText: context.trText('Enter OTP'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                counterText: '',
              ),
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Verify',
              isLoading: _isLoading,
              onPressed: _verifyOtp,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                context.trText('Resend OTP'),
                style: GoogleFonts.lato(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
