import 'package:hornvin/localization/app_localizations.dart';
// import 'package:flutter/material.dart';
// import 'package:hornvin/models/job_model/garage_profile_model.dart';
// import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hornvin/controllers/garage_controller.dart';

// class GarageProfileScreen extends StatefulWidget {
//   const GarageProfileScreen({Key? key}) : super(key: key);

//   @override
//   State<GarageProfileScreen> createState() => _GarageProfileScreenState();
// }

// class _GarageProfileScreenState extends State<GarageProfileScreen> {
//   bool isEditing = false;

//   late TextEditingController garageNameController;
//   late TextEditingController ownerNameController;
//   late TextEditingController emailController;
//   late TextEditingController phoneController;
//   late TextEditingController addressController;
//   late TextEditingController garageTypeController;

//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<GarageController>().fetchGarageProfile();
//     });
//   }

//   void _initializeControllers() {
//     garageNameController = TextEditingController();
//     ownerNameController = TextEditingController();
//     emailController = TextEditingController();
//     phoneController = TextEditingController();
//     addressController = TextEditingController();
//     garageTypeController = TextEditingController();
//   }

//   void _updateControllers(GarageData? data) {
//     if (data != null) {
//       garageNameController.text = data.businessName;
//       ownerNameController.text = data.name;
//       emailController.text = data.email;
//       phoneController.text = data.phoneNumber;
//       addressController.text = data.businessAddress?.country ?? 'India';
//       garageTypeController.text = data.garageType;
//     }
//   }

//   @override
//   void dispose() {
//     garageNameController.dispose();
//     ownerNameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     addressController.dispose();
//     garageTypeController.dispose();
//     super.dispose();
//   }

//   Future<void> _saveChanges() async {
//     // Validate inputs
//     if (garageNameController.text.isEmpty) {
//       _showError('Please enter garage name');
//       return;
//     }
//     if (ownerNameController.text.isEmpty) {
//       _showError('Please enter owner name');
//       return;
//     }
//     if (emailController.text.isEmpty || !emailController.text.contains('@')) {
//       _showError('Please enter valid email');
//       return;
//     }
//     if (phoneController.text.isEmpty) {
//       _showError('Please enter phone number');
//       return;
//     }

//     final success = await context.read<GarageController>().updateGarageProfile(
//       businessName: garageNameController.text,
//       name: ownerNameController.text,
//       email: emailController.text,
//       phoneNumber: phoneController.text,
//       garageType: garageTypeController.text,
//       address: addressController.text,
//     );

//     if (mounted) {
//       if (success) {
//         setState(() {
//           isEditing = false;
//         });
//         _showSuccess('Profile updated successfully!');
//       } else {
//         _showError('Failed to update profile');
//       }
//     }
//   }

//   void _showSuccess(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.check_circle, color: Colors.white),
//             const SizedBox(width: 12),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: Colors.green.shade700,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.error, color: Colors.white),
//             const SizedBox(width: 12),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: Colors.red.shade700,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: Text(context.trData(//           'Garage Profile'),
//           style: GoogleFonts.lato(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: const Color(0xFF1A237E),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           if (!isEditing)
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   isEditing = true;
//                 });
//               },
//               child: Text(context.trData(//                 'Edit'),
//                 style: GoogleFonts.lato(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//         ],
//       ),
//       body: Consumer<GarageController>(
//         builder: (context, controller, child) {
//           if (controller.isLoading) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE31E24)),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(context.trData(//                     'Loading profile...'),
//                     style: GoogleFonts.lato(color: Colors.grey.shade600),
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (controller.errorMessage != null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.error_outline, size: 80, color: Colors.red.shade400),
//                   const SizedBox(height: 16),
//                   Text(context.trData(//                     'Error loading profile'),
//                     style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(context.trData(//                     controller.errorMessage!),
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.lato(color: Colors.grey.shade600),
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton(
//                     onPressed: () => controller.fetchGarageProfile(),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFE31E24),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     ),
//                     child: Text(context.trText('Retry'), style: GoogleFonts.lato()),
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (controller.profileData == null) {
//             return const SizedBox();
//           }

//           _updateControllers(controller.profileData);

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 _buildProfileHeader(controller.profileData!),
//                 const SizedBox(height: 16),
//                 _buildGarageInfo(controller.profileData!),
//                 const SizedBox(height: 16),
//                 _buildBusinessStats(controller.profileData!),
//                 const SizedBox(height: 16),
//                 _buildComplianceStatus(controller.profileData!),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildProfileHeader(GarageData data) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF1A237E), Color(0xFF283593)],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 10,
//                     ),
//                   ],
//                 ),
//                 child: const Center(
//                   child: Icon(
//                     Icons.car_repair,
//                     size: 50,
//                     color: Color(0xFFE31E24),
//                   ),
//                 ),
//               ),
//               if (isEditing)
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: const BoxDecoration(
//                       color: Color(0xFFE31E24),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Text(context.trData(//             data.businessName),
//             style: GoogleFonts.lato(
//               fontSize: 22,
//               fontWeight: FontWeight.w700,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             '${data.garageType} Garage • ${_getApprovalStatusText(data.approvalStatus)}',
//             style: GoogleFonts.lato(fontSize: 12, color: Colors.white70),
//           ),
//           const SizedBox(height: 12),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   data.approvalStatus == 'approved' ? Icons.verified : Icons.pending,
//                   size: 14,
//                   color: data.approvalStatus == 'approved' ? Colors.green : Colors.orange,
//                 ),
//                 const SizedBox(width: 4),
//                 Text(context.trData(//                   data.approvalStatus == 'approved' ? 'Verified Garage' : 'Pending Approval'),
//                   style: GoogleFonts.lato(
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGarageInfo(GarageData data) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(context.trData(//                 'Garage Information'),
//                 style: GoogleFonts.lato(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                   color: const Color(0xFF1A237E),
//                 ),
//               ),
//               if (isEditing)
//                 Consumer<GarageController>(
//                   builder: (context, controller, child) {
//                     return TextButton(
//                       onPressed: controller.isUpdating ? null : _saveChanges,
//                       style: TextButton.styleFrom(
//                         backgroundColor: const Color(0xFFE31E24).withOpacity(0.1),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       ),
//                       child: controller.isUpdating
//                           ? SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: const Color(0xFFE31E24),
//                               ),
//                             )
//                           : Text(context.trData(//                               'Save'),
//                               style: GoogleFonts.lato(
//                                 fontSize: 13,
//                                 color: const Color(0xFFE31E24),
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                     );
//                   },
//                 ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           _buildInfoField(
//             'Garage Name',
//             garageNameController,
//             Icons.business,
//             isEditing,
//           ),
//           _buildInfoField(
//             'Owner Name',
//             ownerNameController,
//             Icons.person,
//             isEditing,
//           ),
//           _buildInfoField(
//             'Email',
//             emailController,
//             Icons.email,
//             isEditing,
//             enabled: !isEditing, // Email might be read-only
//           ),
//           _buildInfoField(
//             'Phone Number',
//             phoneController,
//             Icons.phone,
//             isEditing,
//             enabled: !isEditing, // Phone might be read-only
//           ),
//           _buildInfoField(
//             'Address',
//             addressController,
//             Icons.location_on,
//             isEditing,
//           ),
//           _buildInfoField(
//             'Garage Type',
//             garageTypeController,
//             Icons.category,
//             isEditing,
//           ),
//           const SizedBox(height: 12),
//           _buildInfoRow('Member Since', _formatDate(data.createdAt)),
//           _buildInfoRow('Last Login', _formatDate(data.lastLogin)),
//           _buildInfoRow('Garage ID', data.id.substring(data.id.length - 8)),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoField(
//     String label,
//     TextEditingController controller,
//     IconData icon,
//     bool editing, {
//     bool enabled = true,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(context.trData(//             label),
//             style: GoogleFonts.lato(
//               fontSize: 12,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           const SizedBox(height: 4),
//           if (editing && enabled)
//             TextFormField(
//               controller: controller,
//               decoration: InputDecoration(
//                 prefixIcon: Icon(icon, size: 20, color: const Color(0xFFE31E24)),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide(color: Colors.grey.shade300),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide(color: Colors.grey.shade300),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: const BorderSide(color: Color(0xFFE31E24), width: 2),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//               ),
//               style: GoogleFonts.lato(fontSize: 14),
//             )
//           else
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade50,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.grey.shade200),
//               ),
//               child: Row(
//                 children: [
//                   Icon(icon, size: 20, color: const Color(0xFFE31E24)),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(context.trData(//                       controller.text),
//                       style: GoogleFonts.lato(
//                         fontSize: 14,
//                         color: Colors.grey.shade900,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(context.trData(//             label),
//             style: GoogleFonts.lato(
//               fontSize: 13,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           Text(context.trData(//             value),
//             style: GoogleFonts.lato(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: const Color(0xFF1A237E),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBusinessStats(GarageData data) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(context.trData(//             'Business Information'),
//             style: GoogleFonts.lato(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//               color: const Color(0xFF1A237E),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildStatItem(
//                   'Commission Rate',
//                   '${data.commissionRate}%',
//                   Icons.percent,
//                 ),
//               ),
//               Expanded(
//                 child: _buildStatItem(
//                   'Services Offered',
//                   data.servicesOffered.length.toString(),
//                   Icons.miscellaneous_services,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildStatItem(
//                   'Documents',
//                   data.documents.length.toString(),
//                   Icons.description,
//                 ),
//               ),
//               Expanded(
//                 child: _buildStatItem(
//                   'Status',
//                   data.isActive ? 'Active' : 'Inactive',
//                   data.isActive ? Icons.check_circle : Icons.cancel,
//                   color: data.isActive ? Colors.green : Colors.red,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatItem(String label, String value, IconData icon, {Color? color}) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, size: 24, color: color ?? const Color(0xFFE31E24)),
//           const SizedBox(height: 8),
//           Text(context.trData(//             value),
//             style: GoogleFonts.lato(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: const Color(0xFF1A237E),
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(context.trData(//             label),
//             style: GoogleFonts.lato(
//               fontSize: 11,
//               color: Colors.grey.shade600,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildComplianceStatus(GarageData data) {
//     Color statusColor;
//     IconData statusIcon;
//     String statusText;

//     switch (data.complianceStatus) {
//       case 'approved':
//         statusColor = Colors.green;
//         statusIcon = Icons.check_circle;
//         statusText = 'Approved';
//         break;
//       case 'pending_review':
//         statusColor = Colors.orange;
//         statusIcon = Icons.pending;
//         statusText = 'Pending Review';
//         break;
//       case 'rejected':
//         statusColor = Colors.red;
//         statusIcon = Icons.cancel;
//         statusText = 'Rejected';
//         break;
//       default:
//         statusColor = Colors.grey;
//         statusIcon = Icons.help;
//         statusText = data.complianceStatus;
//     }

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(context.trData(//             'Compliance Status'),
//             style: GoogleFonts.lato(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//               color: const Color(0xFF1A237E),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: statusColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(15),
//               border: Border.all(color: statusColor.withOpacity(0.3)),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.2),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(statusIcon, color: statusColor, size: 28),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(context.trData(//                         statusText),
//                         style: GoogleFonts.lato(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                           color: statusColor,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         data.approvalStatus == 'approved'
//                             ? 'Your garage is verified and approved to operate'
//                             : 'Your garage is under review. We will notify you once approved',
//                         style: GoogleFonts.lato(
//                           fontSize: 12,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (data.approvedAt != null) ...[
//             const SizedBox(height: 12),
//             _buildInfoRow('Approved On', _formatDate(data.approvedAt)),
//           ],
//         ],
//       ),
//     );
//   }

//   String _getApprovalStatusText(String status) {
//     switch (status) {
//       case 'approved':
//         return 'Verified';
//       case 'pending':
//         return 'Pending';
//       case 'rejected':
//         return 'Rejected';
//       default:
//         return status;
//     }
//   }

//   String _formatDate(DateTime? date) {
//     if (date == null) return 'N/A';
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }

// lib/screens/garage_screen/garage_profile_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hornvin/models/job_model/garage_profile_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/controllers/garage_controller.dart';
import 'package:hornvin/utils/constants.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';

class GarageProfileScreen extends StatefulWidget {
  const GarageProfileScreen({Key? key}) : super(key: key);

  @override
  State<GarageProfileScreen> createState() => _GarageProfileScreenState();
}

class _GarageProfileScreenState extends State<GarageProfileScreen> {
  bool isEditing = false;
  bool _isProfilePhotoUploading = false;
  String? _selectedProfilePhotoPath;
  final ImagePicker _imagePicker = ImagePicker();

  late TextEditingController garageNameController;
  late TextEditingController ownerNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController garageTypeController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GarageController>().fetchGarageProfile();
    });
  }

  void _initializeControllers() {
    garageNameController = TextEditingController();
    ownerNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    garageTypeController = TextEditingController();
  }

  void _updateControllers(GarageData? data) {
    if (data != null) {
      garageNameController.text = data.businessName;
      ownerNameController.text = data.name;
      emailController.text = data.email;
      phoneController.text = data.phoneNumber;
      addressController.text = data.businessAddress?.country ?? 'India';
      garageTypeController.text = data.garageType;
    }
  }

  @override
  void dispose() {
    garageNameController.dispose();
    ownerNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    garageTypeController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (garageNameController.text.isEmpty) {
      _showError('Please enter garage name');
      return;
    }
    if (ownerNameController.text.isEmpty) {
      _showError('Please enter owner name');
      return;
    }
    if (emailController.text.isEmpty || !emailController.text.contains('@')) {
      _showError('Please enter valid email');
      return;
    }
    if (phoneController.text.isEmpty) {
      _showError('Please enter phone number');
      return;
    }

    final success = await context.read<GarageController>().updateGarageProfile(
      businessName: garageNameController.text,
      name: ownerNameController.text,
      email: emailController.text,
      phoneNumber: phoneController.text,
      garageType: garageTypeController.text,
      address: addressController.text,
    );

    if (mounted) {
      if (success) {
        setState(() {
          isEditing = false;
        });
        _showSuccess('Profile updated successfully!');
      } else {
        _showError('Failed to update profile');
      }
    }
  }

  Future<void> _showProfilePhotoPicker() async {
    if (_isProfilePhotoUploading) return;

    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: Text(context.trText('Camera')),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndUploadProfilePhoto(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: Text(context.trText('Gallery')),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndUploadProfilePhoto(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickAndUploadProfilePhoto(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(
      source: source,
      imageQuality: 82,
      maxWidth: 1400,
    );
    if (pickedFile == null) return;
    if (!mounted) return;

    setState(() {
      _selectedProfilePhotoPath = pickedFile.path;
      _isProfilePhotoUploading = true;
    });

    final success = await context.read<GarageController>().updateGarageProfile(
      businessName: garageNameController.text,
      name: ownerNameController.text,
      email: emailController.text,
      phoneNumber: phoneController.text,
      garageType: garageTypeController.text,
      address: addressController.text,
      profilePhoto: File(pickedFile.path),
    );

    if (!mounted) return;
    setState(() {
      _isProfilePhotoUploading = false;
      _selectedProfilePhotoPath = null;
    });

    if (success) {
      _showSuccess('Profile photo updated successfully!');
    } else {
      _showError('Failed to update profile photo');
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                context.trData(message),
                style: GoogleFonts.lato(fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                context.trData(message),
                style: GoogleFonts.lato(fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: Consumer<GarageController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.tr('loading_profile'),
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          if (controller.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.shade50,
                      ),
                      child: Icon(
                        Icons.error_outline,
                        size: 50,
                        color: Colors.red.shade400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      context.tr('error_loading_profile'),
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.trData(controller.errorMessage!),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => controller.fetchGarageProfile(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        context.tr('retry'),
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (controller.profileData == null) {
            return const SizedBox();
          }

          if (!isEditing) {
            _updateControllers(controller.profileData);
          }

          return RefreshIndicator(
            onRefresh: () => controller.fetchGarageProfile(),
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).padding.bottom + 20,
              ),
              child: Column(
                children: [
                  _buildProfileHeader(controller.profileData!),
                  const SizedBox(height: 16),
                  _buildGarageInfo(controller.profileData!),
                  const SizedBox(height: 16),
                  _buildBusinessStats(controller.profileData!),
                  const SizedBox(height: 16),
                  _buildComplianceStatus(controller.profileData!),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(GarageData data) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondary, AppColors.secondaryLight],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _showProfilePhotoPicker,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipOval(child: _buildProfilePhoto(data)),
                    ),
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: _isProfilePhotoUploading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.white,
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.trData(data.businessName),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      context.trData(data.name),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.78),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _profilePill('${data.garageType} Garage'),
                        _profilePill(
                          data.approvalStatus == 'approved'
                              ? 'verified_garage'
                              : 'pending_approval',
                          color: data.approvalStatus == 'approved'
                              ? AppColors.success
                              : AppColors.warning,
                          isKey: true,
                        ),
                      ],
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

  Widget _buildProfilePhoto(GarageData data) {
    final localPath = _selectedProfilePhotoPath;
    if (localPath != null && localPath.trim().isNotEmpty) {
      return Image.file(
        File(localPath),
        width: 86,
        height: 86,
        fit: BoxFit.cover,
      );
    }

    final imageUrl = _profilePhotoUrl(data);
    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: 86,
        height: 86,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _profilePhotoPlaceholder(),
      );
    }

    return _profilePhotoPlaceholder();
  }

  Widget _profilePhotoPlaceholder() {
    return Container(
      width: 86,
      height: 86,
      color: Colors.white,
      child: const Icon(Icons.car_repair, size: 44, color: AppColors.primary),
    );
  }

  String _profilePhotoUrl(GarageData data) {
    final value = (data.photo?.url ?? data.avatar ?? '').trim();
    if (value.isEmpty) return '';
    if (value.startsWith('http')) return value;
    if (value.startsWith('/')) return '${ApiConstants.baseUrl}$value';
    return '${ApiConstants.baseUrl}/$value';
  }

  Widget _profilePill(String text, {Color? color, bool isKey = false}) {
    final pillColor = color ?? Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: pillColor.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: pillColor.withValues(alpha: 0.28)),
      ),
      child: Text(
        isKey ? context.tr(text) : context.trData(text),
        style: GoogleFonts.lato(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color == null ? Colors.white : pillColor,
        ),
      ),
    );
  }

  /*
                  ),
                  child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(context.trData(data.businessName),
            style: GoogleFonts.lato(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${data.garageType} Garage',
              style: GoogleFonts.lato(
                fontSize: 12,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: data.approvalStatus == 'approved' 
                  ? Colors.green.withOpacity(0.2) 
                  : Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: data.approvalStatus == 'approved' 
                    ? Colors.green.withOpacity(0.5) 
                    : Colors.orange.withOpacity(0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  data.approvalStatus == 'approved' ? Icons.verified : Icons.pending,
                  size: 14,
                  color: data.approvalStatus == 'approved' ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 6),
                Text(context.trData(data.approvalStatus == 'approved' ? 'Verified Garage' : 'Pending Approval'),
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: data.approvalStatus == 'approved' ? Colors.green.shade100 : Colors.orange.shade100,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  */

  Widget _buildGarageInfo(GarageData data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1A237E).withValues(alpha: 0.05),
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE31E24).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.business,
                          size: 20,
                          color: Color(0xFFE31E24),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        context.tr('garage_information'),
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A237E),
                        ),
                      ),
                    ],
                  ),
                  if (!isEditing)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE31E24).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isEditing = true;
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.edit,
                              size: 14,
                              color: Color(0xFFE31E24),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              context.tr('edit'),
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                color: const Color(0xFFE31E24),
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInfoField(
                    'garage_name',
                    garageNameController,
                    Icons.business,
                    isEditing,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoField(
                    'owner_name',
                    ownerNameController,
                    Icons.person,
                    isEditing,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoField(
                    'email',
                    emailController,
                    Icons.email,
                    isEditing,
                    enabled: false,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoField(
                    'phone_number',
                    phoneController,
                    Icons.phone,
                    isEditing,
                    enabled: false,
                  ),
                  const SizedBox(height: 12),
                  _buildAddressField(
                    'address',
                    addressController,
                    Icons.location_on,
                    isEditing,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoField(
                    'garage_type',
                    garageTypeController,
                    Icons.category,
                    isEditing,
                  ),
                  if (isEditing) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE31E24),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          context.tr('save_changes'),
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Divider(color: Colors.grey.shade200, height: 24),
                  _buildInfoRow('member_since', _formatDate(data.createdAt)),
                  const SizedBox(height: 8),
                  _buildInfoRow('last_login', _formatDate(data.lastLogin)),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'garage_id',
                    data.id.substring(data.id.length - 8).toUpperCase(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressField(
    String labelKey,
    TextEditingController controller,
    IconData icon,
    bool editing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.tr(labelKey),
              style: GoogleFonts.lato(
                fontSize: editing ? 12 : 11,
                fontWeight: editing ? FontWeight.w500 : FontWeight.normal,
                color: editing ? Colors.grey.shade700 : Colors.grey.shade500,
              ),
            ),
            if (editing)
              InkWell(
                onTap: _openLocationPicker,
                child: Text(
                  context.tr('change_location'),
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        if (editing)
          TextFormField(
            controller: controller,
            maxLines: 2,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20, color: const Color(0xFFE31E24)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE31E24),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            style: GoogleFonts.lato(fontSize: 14),
          )
        else
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFE31E24).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: const Color(0xFFE31E24)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.trData(controller.text),
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1A237E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Future<void> _openLocationPicker() async {
    final result = await Navigator.pushNamed(context, '/select-location');
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        addressController.text = result['displayName'] ?? '';
      });
      // Optionally save to storage immediately or wait for profile save
      // await StorageService.saveLocation(
      //   result['displayName'],
      //   result['latitude'],
      //   result['longitude'],
      // );
    }
  }

  Widget _buildInfoField(
    String labelKey,
    TextEditingController controller,
    IconData icon,
    bool editing, {
    bool enabled = true,
  }) {
    if (editing && enabled) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr(labelKey),
            style: GoogleFonts.lato(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20, color: const Color(0xFFE31E24)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE31E24),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            style: GoogleFonts.lato(fontSize: 14),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE31E24).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFFE31E24)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr(labelKey),
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.trData(controller.text),
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1A237E),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildInfoRow(String labelKey, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.tr(labelKey),
          style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade600),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1A237E).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            context.trData(value),
            style: GoogleFonts.lato(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A237E),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessStats(GarageData data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE31E24).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.star,
                  size: 20,
                  color: Color(0xFFE31E24),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                context.tr('business_information'),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A237E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              bool isTablet = constraints.maxWidth > 600;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isTablet ? 4 : 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  _buildStatItem(
                    'commission',
                    '${data.commissionRate}%',
                    Icons.percent,
                    Colors.blue,
                  ),
                  _buildStatItem(
                    'services',
                    data.servicesOffered.length.toString(),
                    Icons.miscellaneous_services,
                    Colors.green,
                  ),
                  _buildStatItem(
                    'documents',
                    data.documents.length.toString(),
                    Icons.description,
                    Colors.orange,
                  ),
                  _buildStatItem(
                    'status',
                    data.isActive ? 'active' : 'inactive',
                    data.isActive ? Icons.check_circle : Icons.cancel,
                    data.isActive ? Colors.green : Colors.red,
                    isKey: true,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String labelKey,
    String value,
    IconData icon,
    Color color, {
    bool isKey = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.05),
            color.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            isKey ? context.tr(value) : context.trData(value),
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.tr(labelKey),
            style: GoogleFonts.lato(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceStatus(GarageData data) {
    Color statusColor;
    IconData statusIcon;
    String statusKey;

    switch (data.complianceStatus) {
      case 'approved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusKey = 'approved';
        break;
      case 'pending_review':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        statusKey = 'pending_review';
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusKey = 'rejected';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusKey = data.complianceStatus;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(statusIcon, size: 20, color: statusColor),
              ),
              const SizedBox(width: 10),
              Text(
                context.tr('compliance_status'),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A237E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  statusColor.withValues(alpha: 0.08),
                  statusColor.withValues(alpha: 0.02),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: statusColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr(statusKey),
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.approvalStatus == 'approved'
                            ? 'Your garage is verified and approved to operate on our platform'
                            : 'Your garage is under review. We will notify you once approved',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          height: 1.4,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (data.approvedAt != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr('approved_on'),
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    _formatDate(data.approvedAt),
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A237E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getApprovalStatusText(String status) {
    switch (status) {
      case 'approved':
        return 'Verified';
      case 'pending':
        return 'Pending';
      case 'rejected':
        return 'Rejected';
      default:
        return status;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
