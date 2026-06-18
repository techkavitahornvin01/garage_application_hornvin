import 'package:hornvin/localization/app_localizations.dart';

// import 'package:flutter/material.dart';
// import 'package:hornvin/controllers/job_controller.dart';
// import 'package:hornvin/models/job_model/job_model.dart';
// import 'package:hornvin/screens/job_screen/add_editJob_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';

// class JobListScreen extends StatefulWidget {
//   const JobListScreen({Key? key}) : super(key: key);

//   @override
//   State<JobListScreen> createState() => _JobListScreenState();
// }

// class _JobListScreenState extends State<JobListScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   String _selectedStatusFilter = 'All';

//   final List<String> _statusFilters = ['All', 'Pending', 'In Progress', 'Completed', 'Cancelled'];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<JobController>().fetchJobs();
//     });
//     _scrollController.addListener(_onScroll);
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
//       if (context.read<JobController>().currentPage < context.read<JobController>().totalPages) {
//         context.read<JobController>().fetchJobs(page: context.read<JobController>().currentPage + 1);
//       }
//     }
//   }

//   Future<void> _deleteJob(BuildContext context, String id, String customerName) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade50,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 48),
//               ),
//               const SizedBox(height: 20),
//               Text(context.trData(//                 'Delete Job'),
//                 style: GoogleFonts.lato(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.red.shade800,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Text(context.trData(//                 'Are you sure you want to delete job for "$customerName"?'),
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade700),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(context, false),
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                         side: BorderSide(color: Colors.grey.shade400),
//                       ),
//                       child: Text(context.trText('Cancel'), style: GoogleFonts.lato(fontWeight: FontWeight.w600)),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () => Navigator.pop(context, true),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red.shade700,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       ),
//                       child: Text(context.trText('Delete'), style: GoogleFonts.lato(fontWeight: FontWeight.w600)),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );

//     if (confirm == true) {
//       final success = await context.read<JobController>().deleteJob(id);
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(success ? Icons.check_circle : Icons.error, color: Colors.white),
//                 const SizedBox(width: 12),
//                 Expanded(child: Text(success ? 'Job deleted successfully!' : 'Failed to delete job')),
//               ],
//             ),
//             backgroundColor: success ? Colors.green.shade700 : Colors.red.shade700,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             margin: const EdgeInsets.all(16),
//           ),
//         );
//       }
//     }
//   }

//   void _showJobDetails(BuildContext context, Job job) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => DraggableScrollableSheet(
//         initialChildSize: 0.9,
//         minChildSize: 0.5,
//         maxChildSize: 0.95,
//         builder: (_, scrollController) => Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//             boxShadow: [
//               BoxShadow(color: Colors.black26, blurRadius: 20, offset: const Offset(0, -5)),
//             ],
//           ),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color(0xFF1A237E), Color(0xFF283593)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 50,
//                       height: 4,
//                       decoration: BoxDecoration(
//                         color: Colors.white54,
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.white24,
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Text(
//                             job.jobCardId?.substring(job.jobCardId!.length - 6) ?? 'N/A',
//                             style: GoogleFonts.lato(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(context.trData(//                                 job.customerName),
//                                 style: GoogleFonts.lato(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Text(context.trData(//                                 job.vehicleNumber),
//                                 style: GoogleFonts.lato(fontSize: 14, color: Colors.white70),
//                               ),
//                             ],
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.close, color: Colors.white, size: 28),
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   controller: scrollController,
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildDetailCard(
//                         title: 'Customer Information',
//                         icon: Icons.person,
//                         children: [
//                           _buildDetailRow('Customer Name', job.customerName),
//                           _buildDetailRow('Phone Number', job.phoneNumber),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       _buildDetailCard(
//                         title: 'Vehicle Details',
//                         icon: Icons.directions_car,
//                         children: [
//                           _buildDetailRow('Vehicle Number', job.vehicleNumber),
//                           _buildDetailRow('Vehicle Type', job.vehicleType),
//                           _buildDetailRow('Vehicle Model', job.vehicleModel),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       _buildDetailCard(
//                         title: 'Service Information',
//                         icon: Icons.calendar_today,
//                         children: [
//                           _buildDetailRow('Service Date', _formatDate(job.serviceDate)),
//                           _buildDetailRow('Next Service', _formatDate(job.nextServiceDate)),
//                           _buildDetailRow('Description', job.description),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       _buildDetailCard(
//                         title: 'Mechanic Details',
//                         icon: Icons.engineering,
//                         children: [
//                           _buildDetailRow('Mechanic Name', job.mechanicName),
//                           _buildDetailRow('Mechanic Profile', job.mechanicProfile),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       _buildDetailCard(
//                         title: 'Parts Used',
//                         icon: Icons.build,
//                         children: [
//                           ...job.parts.map((part) => Padding(
//                             padding: const EdgeInsets.only(bottom: 8),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(context.trData(part.partName), style: GoogleFonts.lato(fontSize: 14)),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                                   decoration: BoxDecoration(
//                                     color: Color(0xFFE31E24).withOpacity(0.1),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Text(context.trData(//                                     '₹${part.cost}'),
//                                     style: GoogleFonts.lato(
//                                       fontWeight: FontWeight.w600,
//                                       color: Color(0xFFE31E24),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )),
//                           const Divider(height: 24),
//                           _buildDetailRow('Total Cost', '₹${job.totalPartsCost}', isBold: true),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       _buildDetailCard(
//                         title: 'Additional Information',
//                         icon: Icons.info,
//                         children: [
//                           _buildDetailRow('Status', job.status),
//                           _buildDetailRow('Notes', job.notes),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailCard({required String title, required IconData icon, required List<Widget> children}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Color(0xFF1A237E),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Icon(icon, color: Colors.white, size: 20),
//                 const SizedBox(width: 8),
//                 Text(context.trData(//                   title),
//                   style: GoogleFonts.lato(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(children: children),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(context.trData(//               label),
//               style: GoogleFonts.lato(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey.shade700,
//                 fontSize: 13,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(context.trData(//               value),
//               style: GoogleFonts.lato(
//                 fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//                 color: isBold ? Color(0xFFE31E24) : Colors.grey.shade900,
//                 fontSize: 13,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: Text(context.trData(//           'Job Management'),
//           style: GoogleFonts.lato(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: const Color(0xFF1A237E),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () => context.read<JobController>().fetchJobs(),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search & Filter Bar
//           Container(
//             padding: const EdgeInsets.all(16),
//             color: Colors.white,
//             child: Column(
//               children: [
//                 // Search Field
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade100,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: TextField(
//                     controller: _searchController,
//                     onChanged: (value) {
//                       // Implement search if needed
//                     },
//                     decoration: InputDecoration(
//                       hintText: context.trText('Search by customer, vehicle, or job ID...'),
//                       hintStyle: GoogleFonts.lato(color: Colors.grey.shade500),
//                       prefixIcon: Icon(Icons.search, color: const Color(0xFFE31E24)),
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // Status Filters
//                 SizedBox(
//                   height: 45,
//                   child: ListView.separated(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: _statusFilters.length,
//                     separatorBuilder: (_, __) => const SizedBox(width: 10),
//                     itemBuilder: (context, index) {
//                       final filter = _statusFilters[index];
//                       final isSelected = _selectedStatusFilter == filter;
//                       return FilterChip(
//                         label: Text(filter),
//                         selected: isSelected,
//                         onSelected: (selected) {
//                           setState(() {
//                             _selectedStatusFilter = filter;
//                           });
//                           if (filter != 'All') {
//                             // Add status filter logic
//                           } else {
//                             context.read<JobController>().fetchJobs();
//                           }
//                         },
//                         backgroundColor: Colors.white,
//                         selectedColor: const Color(0xFFE31E24).withOpacity(0.1),
//                         labelStyle: GoogleFonts.lato(
//                           color: isSelected ? const Color(0xFFE31E24) : Colors.grey.shade700,
//                           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                         ),
//                         shape: StadiumBorder(
//                           side: BorderSide(
//                             color: isSelected ? const Color(0xFFE31E24) : Colors.grey.shade300,
//                             width: 1,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Job List
//           Expanded(
//             child: Consumer<JobController>(
//               builder: (context, controller, child) {
//                 if (controller.isLoading && controller.jobs.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const CircularProgressIndicator(
//                           valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE31E24)),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(context.trData(//                           'Loading jobs...'),
//                           style: GoogleFonts.lato(color: Colors.grey.shade600),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 if (controller.errorMessage != null) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.error_outline, size: 80, color: Colors.red.shade400),
//                         const SizedBox(height: 16),
//                         Text(context.trData(//                           'Error loading jobs'),
//                           style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(context.trData(//                           controller.errorMessage!),
//                           textAlign: TextAlign.center,
//                           style: GoogleFonts.lato(color: Colors.grey.shade600),
//                         ),
//                         const SizedBox(height: 24),
//                         ElevatedButton(
//                           onPressed: () => controller.fetchJobs(),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFFE31E24),
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                           ),
//                           child: Text(context.trText('Retry'), style: GoogleFonts.lato(fontWeight: FontWeight.w600)),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 if (controller.jobs.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.inbox, size: 100, color: Colors.grey.shade400),
//                         const SizedBox(height: 16),
//                         Text(context.trData(//                           'No jobs found'),
//                           style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(context.trData(//                           'Click the + button to create a new job'),
//                           style: GoogleFonts.lato(color: Colors.grey.shade500),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 return RefreshIndicator(
//                   onRefresh: () => controller.fetchJobs(),
//                   color: const Color(0xFFE31E24),
//                   child: ListView.builder(
//                     controller: _scrollController,
//                     padding: const EdgeInsets.all(12),
//                     itemCount: controller.jobs.length + (controller.currentPage < controller.totalPages ? 1 : 0),
//                     itemBuilder: (context, index) {
//                       if (index == controller.jobs.length) {
//                         return const Padding(
//                           padding: EdgeInsets.all(16),
//                           child: Center(
//                             child: CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE31E24)),
//                             ),
//                           ),
//                         );
//                       }
//                       final job = controller.jobs[index];
//                       return _buildJobCard(job, context);
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//           // Pagination Info
//           Consumer<JobController>(
//             builder: (context, controller, child) {
//               if (controller.totalJobs == 0) return const SizedBox();
//               return Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 color: Colors.white,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(context.trData(//                       'Total: ${controller.totalJobs} jobs'),
//                       style: GoogleFonts.lato(color: Colors.grey.shade600, fontSize: 12),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF1A237E),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(context.trData(//                         'Page ${controller.currentPage} of ${controller.totalPages}'),
//                         style: GoogleFonts.lato(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const AddEditJobScreen()),
//           );
//           if (result == true) {
//             context.read<JobController>().fetchJobs();
//           }
//         },
//         backgroundColor: const Color(0xFFE31E24),
//         elevation: 4,
//         child: const Icon(Icons.add, color: Colors.white, size: 28),
//       ),
//     );
//   }

//   Widget _buildJobCard(Job job, BuildContext context) {
//     final Color statusColor = _getStatusColor(job.status);
//     final IconData statusIcon = _getStatusIcon(job.status);

//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () => _showJobDetails(context, job),
//           borderRadius: BorderRadius.circular(20),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 10,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             width: 55,
//                             height: 55,
//                             decoration: BoxDecoration(
//                               gradient: const LinearGradient(
//                                 colors: [Color(0xFFE31E24), Color(0xFFC0151A)],
//                               ),
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 job.jobCardId?.substring(job.jobCardId!.length - 4) ?? 'N/A',
//                                 style: GoogleFonts.lato(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 14),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(context.trData(//                                   job.customerName),
//                                   style: GoogleFonts.lato(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: const Color(0xFF1A237E),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Row(
//                                   children: [
//                                     Icon(Icons.directions_car, size: 14, color: Colors.grey.shade600),
//                                     const SizedBox(width: 4),
//                                     Text(context.trData(//                                       job.vehicleNumber),
//                                       style: GoogleFonts.lato(
//                                         fontSize: 13,
//                                         color: Colors.grey.shade600,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: statusColor.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(color: statusColor.withOpacity(0.3)),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(statusIcon, size: 16, color: statusColor),
//                                 const SizedBox(width: 4),
//                                 Text(context.trData(//                                   job.status),
//                                   style: GoogleFonts.lato(
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.w600,
//                                     color: statusColor,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 14),
//                       Divider(color: Colors.grey.shade200, height: 1),
//                       const SizedBox(height: 12),
//                       Row(
//                         children: [
//                           _buildInfoChip(Icons.calendar_today, _formatDate(job.serviceDate), Colors.blue),
//                           const SizedBox(width: 8),
//                           _buildInfoChip(Icons.engineering, job.mechanicName, Colors.orange),
//                           const SizedBox(width: 8),
//                           _buildInfoChip(Icons.currency_rupee, '${job.totalPartsCost}', Colors.green),
//                         ],
//                       ),
//                       const SizedBox(height: 14),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           _buildActionButton(
//                             icon: Icons.edit,
//                             label: 'Edit',
//                             color: const Color(0xFF1A237E),
//                             onPressed: () async {
//                               final result = await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => AddEditJobScreen(job: job),
//                                 ),
//                               );
//                               if (result == true) {
//                                 context.read<JobController>().fetchJobs();
//                               }
//                             },
//                           ),
//                           const SizedBox(width: 8),
//                           _buildActionButton(
//                             icon: Icons.delete,
//                             label: 'Delete',
//                             color: Colors.red,
//                             onPressed: () => _deleteJob(context, job.id!, job.customerName),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onPressed,
//   }) {
//     return TextButton.icon(
//       onPressed: onPressed,
//       icon: Icon(icon, size: 18),
//       label: Text(label),
//       style: TextButton.styleFrom(
//         foregroundColor: color,
//         backgroundColor: color.withOpacity(0.1),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       ),
//     );
//   }

//   Widget _buildInfoChip(IconData icon, String label, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: color),
//           const SizedBox(width: 4),
//           Text(context.trData(//             label),
//             style: GoogleFonts.lato(fontSize: 12, color: color, fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'Completed':
//         return Colors.green.shade700;
//       case 'In Progress':
//         return Colors.orange.shade700;
//       case 'Pending':
//         return Colors.blue.shade700;
//       case 'Cancelled':
//         return Colors.red.shade700;
//       default:
//         return Colors.grey.shade700;
//     }
//   }

//   IconData _getStatusIcon(String status) {
//     switch (status) {
//       case 'Completed':
//         return Icons.check_circle;
//       case 'In Progress':
//         return Icons.hourglass_empty;
//       case 'Pending':
//         return Icons.pending;
//       case 'Cancelled':
//         return Icons.cancel;
//       default:
//         return Icons.info;
//     }
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hornvin/controllers/job_controller.dart';
import 'package:hornvin/models/job_model/job_model.dart';
import 'package:hornvin/bottom_navi/job_history_screen.dart';
import 'package:hornvin/repositories/garage_repository.dart';
import 'package:hornvin/repositories/invoice_repository.dart';
import 'package:hornvin/screens/job_screen/add_editJob_screen.dart';
import 'package:hornvin/utils/constants.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _selectedStatusFilter = 'All';

  final List<String> _statusFilters = [
    'All',
    'Pending',
    'Accepted',
    'In Progress',
    'Completed',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<JobController>();
      controller.fetchVehicleTypes();
      controller.fetchJobs();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (context.read<JobController>().currentPage <
          context.read<JobController>().totalPages) {
        final controller = context.read<JobController>();
        controller.fetchJobs(page: controller.currentPage + 1);
      }
    }
  }

  Future<void> _reloadJobs() {
    return context.read<JobController>().fetchJobs(page: 1);
  }

  Future<void> _deleteJob(
    BuildContext context,
    String id,
    String customerName,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red.shade700,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.trText('Delete Job'),
                style: GoogleFonts.lato(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                context.trText(
                  'Are you sure you want to delete job for "$customerName"?',
                ),
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                      child: Text(
                        context.trText('Cancel'),
                        style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        context.trText('Delete'),
                        style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm == true && context.mounted) {
      final controller = context.read<JobController>();
      final success = await controller.deleteJob(id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                success ? Icons.check_circle : Icons.error,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.trText(
                    success
                        ? 'Job deleted successfully!'
                        : 'Failed to delete job',
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: success
              ? Colors.green.shade700
              : Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Widget _buildVehicleTypeDropdown(JobController controller) {
    final selectedValue =
        controller.vehicleTypes.contains(controller.selectedVehicleType)
        ? controller.selectedVehicleType
        : 'All Vehicles';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          initialValue: selectedValue,
          isExpanded: true,
          isDense: true,
          decoration: InputDecoration(
            hintText: context.trText('Select Vehicle Type'),
            prefixIcon: const Icon(Icons.two_wheeler, size: 20),
            suffixIcon: controller.isVehicleTypesLoading
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE31E24)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 11,
            ),
          ),
          items: controller.vehicleTypes
              .map(
                (type) => DropdownMenuItem<String>(
                  value: type,
                  child: Text(
                    context.trText(type),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(fontSize: 14),
                  ),
                ),
              )
              .toList(),
          onChanged: controller.isLoading
              ? null
              : (value) => controller.selectVehicleType(value),
        ),
        if (controller.vehicleTypesErrorMessage != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.orange.shade700),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  context.trText(
                    'Vehicle types could not be refreshed. Showing default options.',
                  ),
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    color: Colors.orange.shade700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => controller.fetchVehicleTypes(force: true),
                child: Text(context.trText('Retry')),
              ),
            ],
          ),
        ],
      ],
    );
  }

  void _showJobDetails(BuildContext context, Job job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A237E), Color(0xFF283593)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            context.trData(_jobCardSuffix(job.jobCardId, 6)),
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.trData(job.customerName),
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                context.trData(job.vehicleNumber),
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailCard(
                        title: 'Customer Information',
                        icon: Icons.person,
                        children: [
                          _buildDetailRow('Customer Name', job.customerName),
                          _buildDetailRow('Phone Number', job.phoneNumber),
                          if (_jobAddress(job).isNotEmpty)
                            _buildDetailRow('Address', _jobAddress(job)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildDetailCard(
                        title: 'Vehicle Details',
                        icon: Icons.directions_car,
                        children: [
                          _buildDetailRow('Vehicle Number', job.vehicleNumber),
                          _buildDetailRow('Vehicle Type', job.vehicleType),
                          _buildDetailRow('Vehicle Model', job.vehicleModel),
                          if (job.registrationNumber != null &&
                              job.registrationNumber!.isNotEmpty)
                            _buildDetailRow(
                              'Registration Number',
                              job.registrationNumber!,
                            ),
                          if (job.vehicleYear != null)
                            _buildDetailRow(
                              'Vehicle Year',
                              job.vehicleYear!.toString(),
                            ),
                          if (job.fuelType != null && job.fuelType!.isNotEmpty)
                            _buildDetailRow('Fuel Type', job.fuelType!),
                          if (job.kmsDriven != null)
                            _buildDetailRow(
                              'KMs Driven',
                              job.kmsDriven!.toString(),
                            ),
                          if (job.vehicleColor != null &&
                              job.vehicleColor!.isNotEmpty)
                            _buildDetailRow('Vehicle Color', job.vehicleColor!),
                          if (job.ownershipDetails != null &&
                              job.ownershipDetails!.isNotEmpty)
                            _buildDetailRow(
                              'Ownership Details',
                              job.ownershipDetails!,
                            ),
                          if (job.tyreCondition != null &&
                              job.tyreCondition!.isNotEmpty)
                            _buildDetailRow(
                              'Tyre Condition',
                              job.tyreCondition!,
                            ),
                        ],
                      ),
                      if (_vehiclePhotoUrls(job).isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildDetailCard(
                          title: 'Vehicle Photos',
                          icon: Icons.photo_library,
                          children: [_buildVehiclePhotoGrid(job)],
                        ),
                      ],
                      if (_damagePhotoItems(job).isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildDetailCard(
                          title: 'Damage Photos',
                          icon: Icons.warning_amber_rounded,
                          children: [_buildDamagePhotoGrid(job)],
                        ),
                      ],
                      const SizedBox(height: 16),
                      _buildDetailCard(
                        title: 'Service Information',
                        icon: Icons.calendar_today,
                        children: [
                          _buildDetailRow(
                            'Service Date',
                            _formatDate(job.serviceDate),
                          ),
                          _buildDetailRow(
                            'Next Service',
                            _formatDate(job.nextServiceDate),
                          ),
                          _buildDetailRow('Description', job.description),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildDetailCard(
                        title: 'Mechanic Details',
                        icon: Icons.engineering,
                        children: [
                          _buildDetailRow('Mechanic Name', job.mechanicName),
                          _buildDetailRow(
                            'Mechanic Profile',
                            job.mechanicProfile ?? 'N/A',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildDetailCard(
                        title: 'Parts Used',
                        icon: Icons.build,
                        children: [
                          ...job.parts.map(
                            (part) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    context.trData(part.partName),
                                    style: GoogleFonts.lato(fontSize: 14),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFE31E24,
                                      ).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '₹${part.cost}',
                                      style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFE31E24),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(height: 24),
                          _buildDetailRow(
                            'Total Cost',
                            '₹${job.totalPartsCost}',
                            isBold: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildDetailCard(
                        title: 'Additional Information',
                        icon: Icons.info,
                        children: [
                          _buildDetailRow('Status', job.status),
                          if (job.notes.isNotEmpty)
                            _buildDetailRow('Notes', job.notes),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1A237E),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  context.trText(title),
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              context.trText(label),
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              context.trText(value),
              style: GoogleFonts.lato(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: isBold ? Color(0xFFE31E24) : Colors.grey.shade900,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehiclePhotoGrid(Job job) {
    final urls = _vehiclePhotoUrls(job);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: urls.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (context, index) {
        final url = urls[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: url.startsWith('http')
              ? Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _brokenImage(),
                )
              : File(url).existsSync()
              ? Image.file(File(url), fit: BoxFit.cover)
              : _brokenImage(),
        );
      },
    );
  }

  Widget _buildDamagePhotoGrid(Job job) {
    final photos = _damagePhotoItems(job);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: photos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (context, index) {
        final photo = photos[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildPhotoImage(photo.path),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  color: Colors.black.withValues(alpha: 0.58),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.trText(photo.title),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (photo.note.trim().isNotEmpty)
                        Text(
                          context.trText(photo.note),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                            color: Colors.white70,
                            fontSize: 9,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhotoImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _brokenImage(),
      );
    }
    final file = File(path);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.cover);
    }
    final candidates = _imageUrlCandidates(path);
    if (candidates.isNotEmpty) {
      return Image.network(
        candidates.first,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _brokenImage(),
      );
    }
    return _brokenImage();
  }

  Widget _brokenImage() {
    return Container(
      color: Colors.grey.shade100,
      child: const Center(child: Icon(Icons.broken_image_outlined)),
    );
  }

  List<String> _vehiclePhotoUrls(Job job) {
    final urls = <String>[];
    for (final photo in job.vehiclePhotos) {
      if (photo is Map) {
        final url =
            (photo['url'] ??
                    photo['secure_url'] ??
                    photo['localPath'] ??
                    photo['path'])
                ?.toString()
                .trim();
        if (url != null && url.isNotEmpty) urls.add(url);
      } else {
        final url = photo?.toString().trim() ?? '';
        if (url.isNotEmpty) urls.add(url);
      }
    }
    return urls;
  }

  Widget _buildJobFiltersHeader(JobController controller) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.divider),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: context.tr('search_job_hint'),
                hintStyle: GoogleFonts.lato(
                  color: AppColors.grey,
                  fontSize: 13,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppColors.primary,
                ),
                suffixIcon: _searchController.text.trim().isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildVehicleTypeDropdown(controller),
          const SizedBox(height: 10),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _statusFilters.length,
              separatorBuilder: (context, separatorIndex) =>
                  const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _statusFilters[index];
                final isSelected = _selectedStatusFilter == filter;
                return FilterChip(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  label: Text(
                    context.tr(filter.toLowerCase().replaceAll(' ', '_')),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedStatusFilter = filter;
                    });
                    if (filter == 'All') _reloadJobs();
                  },
                  backgroundColor: Colors.white,
                  selectedColor: AppColors.primary.withValues(alpha: 0.1),
                  labelStyle: GoogleFonts.lato(
                    fontSize: 12,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.divider,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationInfo(JobController controller) {
    if (controller.totalJobs == 0) return const SizedBox();
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 88),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.trText('Total: ${controller.totalJobs} jobs'),
            style: GoogleFonts.lato(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              context.trText(
                'Page ${controller.currentPage} of ${controller.totalPages}',
              ),
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Job> _visibleJobs(List<Job> jobs) {
    return jobs
        .where((job) => _matchesJobStatus(job) && _matchesJobSearch(job))
        .toList();
  }

  bool _matchesJobStatus(Job job) {
    if (_selectedStatusFilter == 'All') return true;
    return _statusBucket(job.status) ==
        _selectedStatusFilter.toLowerCase().replaceAll(' ', '_');
  }

  bool _matchesJobSearch(Job job) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return true;

    final address = _jobAddress(job);
    final values = [
      job.id,
      job.jobCardId,
      job.customerName,
      job.phoneNumber,
      address,
      job.vehicleNumber,
      job.vehicleType,
      job.vehicleBrand,
      job.vehicleModel,
      job.vehicleVariant,
      job.registrationNumber,
      job.description,
      job.todo,
      job.mechanicName,
      job.mechanicProfile,
      job.status,
      job.notes,
      ...job.parts.map((part) => part.partName),
    ];

    return values.any(
      (value) => (value ?? '').toString().toLowerCase().contains(query),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          context.tr('job_management'),
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actionsIconTheme: const IconThemeData(color: AppColors.textPrimary),
        surfaceTintColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: context.trText('job_history'),
            icon: const Icon(Icons.history_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const JobHistoryScreen()),
            ),
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reloadJobs),
        ],
      ),
      body: Consumer<JobController>(
        builder: (context, controller, child) {
          final visibleJobs = _visibleJobs(controller.jobs);
          return RefreshIndicator(
            onRefresh: _reloadJobs,
            color: AppColors.primary,
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.zero,
              children: [
                _buildJobFiltersHeader(controller),
                if (controller.isLoading && controller.jobs.isEmpty)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          context.tr('loading_jobs'),
                          style: GoogleFonts.lato(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (controller.errorMessage != null)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 80,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.tr('error_loading_jobs'),
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.trData(controller.errorMessage!),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _reloadJobs,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE31E24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            context.tr('retry'),
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else if (controller.jobs.isEmpty)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 100,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.tr('no_jobs_found'),
                          style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.tr('create_new_job_hint'),
                          style: GoogleFonts.lato(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (visibleJobs.isEmpty)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 76,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          context.trText('No matching jobs found'),
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          context.trText('Try a different search or status filter.'),
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                    child: Column(
                      children: visibleJobs
                          .map((job) => _buildJobCard(job, context))
                          .toList(),
                    ),
                  ),
                  if (controller.currentPage < controller.totalPages)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
                _buildPaginationInfo(controller),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditJobScreen()),
          );
          if (result == true) {
            _reloadJobs();
          }
        },
        backgroundColor: const Color(0xFFE31E24),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildJobCard(Job job, BuildContext context) {
    final Color statusColor = _getStatusColor(job.status);
    final IconData statusIcon = _getStatusIcon(job.status);
    final totalCost =
        job.totalPrice ?? (job.totalPartsCost + (job.labourCost ?? 0));
    final vehicleTitle = [
      job.vehicleBrand,
      job.vehicleModel,
      job.vehicleVariant,
    ].where((value) => value != null && value.trim().isNotEmpty).join(' ');

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showJobDetails(context, job),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.divider),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 150,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(8),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.18,
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.receipt_long_rounded,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    context.trData(
                                      _jobCardSuffix(job.jobCardId, 4),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.lato(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.trData(job.customerName),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      _buildInlineMeta(
                                        Icons.directions_car_rounded,
                                        job.vehicleNumber,
                                      ),
                                      if (vehicleTitle.isNotEmpty)
                                        _buildInlineMeta(
                                          Icons.two_wheeler_rounded,
                                          vehicleTitle,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildStatusBadge(
                              job.status,
                              statusColor,
                              statusIcon,
                            ),
                          ],
                        ),
                        if (job.description.trim().isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            context.trData(job.description),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lato(
                              fontSize: 12.5,
                              height: 1.35,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildInfoChip(
                              Icons.calendar_today_rounded,
                              _formatDate(job.serviceDate),
                              Colors.blue,
                            ),
                            _buildInfoChip(
                              Icons.engineering_rounded,
                              job.mechanicName.isEmpty
                                  ? 'Unassigned'
                                  : job.mechanicName,
                              Colors.orange,
                            ),
                            if (job.kmsDriven != null)
                              _buildInfoChip(
                                Icons.speed_rounded,
                                '${job.kmsDriven} km',
                                Colors.teal,
                              ),
                            _buildInfoChip(
                              Icons.currency_rupee_rounded,
                              _numberText(totalCost.toDouble()),
                              Colors.green,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(color: AppColors.divider, height: 1),
                        const SizedBox(height: 10),
                        Wrap(
                          alignment: WrapAlignment.end,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildActionButton(
                              icon: Icons.picture_as_pdf_rounded,
                              label: 'Invoice',
                              color: Colors.deepPurple,
                              onPressed: () => _downloadInvoicePdfForJob(job),
                            ),
                            _buildActionButton(
                              icon: Icons.chat_bubble_rounded,
                              label: 'WhatsApp',
                              color: Colors.green,
                              onPressed: () => _sendJobDocumentsOnWhatsApp(job),
                            ),
                            _buildActionButton(
                              icon: Icons.edit_rounded,
                              label: 'Edit',
                              color: const Color(0xFF1A237E),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddEditJobScreen(job: job),
                                  ),
                                );
                                if (result == true) {
                                  _reloadJobs();
                                }
                              },
                            ),
                            _buildActionButton(
                              icon: Icons.delete_outline_rounded,
                              label: 'Delete',
                              color: Colors.red,
                              onPressed: () =>
                                  _deleteJob(context, job.id, job.customerName),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInlineMeta(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.grey),
        const SizedBox(width: 4),
        Text(
          context.trText(label),
          style: GoogleFonts.lato(fontSize: 12, color: AppColors.grey),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String label, Color color, IconData icon) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 118),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              context.trText(label),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lato(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(context.trText(label)),
      style: TextButton.styleFrom(
        foregroundColor: color,
        backgroundColor: color.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            context.trText(label),
            style: GoogleFonts.lato(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _statusBucket(String status) {
    final value = status.toLowerCase().trim();
    if (value.contains('complete') || value.contains('deliver')) {
      return 'completed';
    }
    if (value.contains('accept')) {
      return 'accepted';
    }
    if (value.contains('progress') ||
        value.contains('working') ||
        value.contains('assign')) {
      return 'in_progress';
    }
    if (value.contains('cancel') || value.contains('reject')) {
      return 'cancelled';
    }
    return 'pending';
  }

  Color _getStatusColor(String status) {
    switch (_statusBucket(status)) {
      case 'completed':
        return Colors.green.shade700;
      case 'accepted':
        return Colors.blue.shade700;
      case 'in_progress':
        return Colors.orange.shade700;
      case 'cancelled':
        return Colors.red.shade700;
      default:
        return Colors.blue.shade700;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (_statusBucket(status)) {
      case 'completed':
        return Icons.check_circle;
      case 'accepted':
        return Icons.verified_rounded;
      case 'in_progress':
        return Icons.hourglass_empty;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.pending;
    }
  }

  Future<Map<String, dynamic>> _invoiceDataForJob(Job job) async {
    final repository = InvoiceRepository();
    final candidates = <String>[
      job.jobCardId,
      job.id,
    ].where((value) => value.trim().isNotEmpty).toSet();

    final invoice = await repository.getInvoiceForJob(
      jobCardIds: candidates.toList(),
      customerName: job.customerName,
      phoneNumber: job.phoneNumber,
      vehicleNumber: job.vehicleNumber,
    );
    if (invoice != null && invoice.isNotEmpty) return invoice;

    throw Exception(
      'Created garage invoice not found for this job card. Please create invoice first.',
    );
  }

  Future<void> _downloadInvoicePdfForJob(Job job) async {
    try {
      _showMessage('Generating invoice PDF...', Colors.blue);
      final invoice = await _invoiceDataForJob(job);
      final file = await _createInvoicePdf(job, invoice);
      await OpenFilex.open(file.path);
      _showMessage('Invoice PDF saved: ${file.path}', Colors.green);
    } catch (e) {
      _showMessage('Invoice PDF failed: $e', Colors.red);
    }
  }

  Future<void> _sendJobDocumentsOnWhatsApp(Job job) async {
    try {
      _showMessage('Generating WhatsApp documents...', Colors.blue);
      final invoice = await _invoiceDataForJob(job);
      final invoiceFile = await _createInvoicePdf(job, invoice);
      final garageName = await _garageNameForJobSheet(invoice);
      final jobSheetFile = await _createJobSheetPdf(
        job,
        garageName: _text(job.garageName, fallback: garageName),
      );

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(invoiceFile.path), XFile(jobSheetFile.path)],
          subject: 'Invoice and Job Sheet',
        ),
      );
      _showMessage('Invoice and job sheet ready for WhatsApp', Colors.green);
    } catch (e) {
      _showMessage('WhatsApp documents failed: $e', Colors.red);
    }
  }

  Future<String> _garageNameForJobSheet(Map<String, dynamic>? invoice) async {
    final company = _mapOf(invoice?['company']);
    final invoiceGarageName = _text(
      company['name'] ??
          invoice?['garageName'] ??
          invoice?['garage_name'] ??
          invoice?['businessName'] ??
          invoice?['business_name'],
    );
    if (invoiceGarageName.isNotEmpty) return invoiceGarageName;

    try {
      final profile = await GarageRepository().getGarageProfile();
      return _text(
        profile.data.businessName.isNotEmpty
            ? profile.data.businessName
            : profile.data.business_name,
      );
    } catch (_) {
      return '';
    }
  }

  Future<File> _createJobSheetPdf(Job job, {String garageName = ''}) async {
    final pdf = pw.Document();
    final logo = await _loadPdfImage('assets/logo.png');
    final resolvedGarageName = _text(
      job.garageName,
      fallback: garageName,
    );
    final todo = _text(job.todo);
    final vehicleName = [
      job.vehicleBrand,
      job.vehicleModel,
      job.vehicleVariant,
    ].where((value) => value != null && value.trim().isNotEmpty).join(' ');
    final vehicleImages = await _jobSheetImages(
      _vehiclePhotoItems(job),
      limit: 8,
    );
    final damageImages = await _jobSheetImages(
      _damagePhotoItems(job),
      limit: 8,
    );

    pdf.addPage(
      pw.MultiPage(
        pageTheme: const pw.PageTheme(
          margin: pw.EdgeInsets.all(28),
          pageFormat: PdfPageFormat.a4,
        ),
        build: (context) => [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              if (logo != null) pw.Image(logo, width: 60, height: 38),
              if (logo != null) pw.SizedBox(width: 14),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (resolvedGarageName.isNotEmpty) ...[
                      pw.Text(
                        resolvedGarageName,
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                    ],
                    pw.Text(
                      'JOB SHEET',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      _pdfLine(
                        'Job Card',
                        job.jobCardId.isEmpty ? job.id : job.jobCardId,
                      ),
                    ),
                    if (todo.isNotEmpty) ...[
                      pw.SizedBox(height: 2),
                      pw.Text(
                        _pdfLine('Todo', todo),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ],
                ),
              ),
              pw.Text(
                _formatDateBlank(job.serviceDate),
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          pw.SizedBox(height: 12),
          _pdfTwoColumnBox(
            leftTitle: 'Customer Details:',
            left: [
              _pdfLine('Customer Name', job.customerName),
              _pdfLine('Phone', job.phoneNumber),
              _pdfLine('Address', _jobAddress(job)),
            ],
            rightTitle: 'Vehicle Details:',
            right: [
              _pdfLine('Vehicle No', job.vehicleNumber),
              _pdfLine('Vehicle', vehicleName),
              _pdfLine('Type', job.vehicleType),
              _pdfLine('Registration', job.registrationNumber),
              _pdfLine('Year', job.vehicleYear),
              _pdfLine('Fuel', job.fuelType),
              _pdfLine('Transmission', job.transmissionType),
              _pdfLine(
                'Odometer',
                job.kmsDriven == null ? '' : '${job.kmsDriven} km',
              ),
              _pdfLine('Color', job.vehicleColor),
            ],
          ),
          pw.SizedBox(height: 8),
          _pdfTwoColumnBox(
            leftTitle: 'Service Details:',
            left: [
              _pdfLine('Garage Name', resolvedGarageName),
              _pdfLine('Status', job.status),
              _pdfLine('Service Date', _formatDateBlank(job.serviceDate)),
              _pdfLine('Next Service', _formatDateBlank(job.nextServiceDate)),
              _pdfLine('Complaint/Work', job.description),
            ],
            rightTitle: 'Mechanic Details:',
            right: [
              _pdfLine('Mechanic', job.mechanicName),
              _pdfLine('Profile', job.mechanicProfile),
              _pdfLine('Notes', job.notes),
            ],
          ),
          pw.SizedBox(height: 8),
          _pdfBorderBox(
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Parts / Service Items',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 8),
                  if (job.parts.isEmpty)
                    pw.Text('No parts added')
                  else
                    pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.blueGrey900),
                      columnWidths: const {
                        0: pw.FixedColumnWidth(28),
                        1: pw.FlexColumnWidth(2.4),
                        2: pw.FixedColumnWidth(70),
                        3: pw.FixedColumnWidth(80),
                      },
                      children: [
                        pw.TableRow(
                          decoration: const pw.BoxDecoration(
                            color: PdfColors.grey200,
                          ),
                          children: [
                            _pdfCell(
                              '#',
                              bold: true,
                              align: pw.TextAlign.center,
                            ),
                            _pdfCell('Part Name', bold: true),
                            _pdfCell(
                              'Qty',
                              bold: true,
                              align: pw.TextAlign.right,
                            ),
                            _pdfCell(
                              'Cost',
                              bold: true,
                              align: pw.TextAlign.right,
                            ),
                          ],
                        ),
                        ...job.parts.asMap().entries.map((entry) {
                          final part = entry.value;
                          return pw.TableRow(
                            children: [
                              _pdfCell(
                                '${entry.key + 1}',
                                align: pw.TextAlign.center,
                              ),
                              _pdfCell(part.partName),
                              _pdfCell(
                                _numberText((part.quantity ?? 1).toDouble()),
                                align: pw.TextAlign.right,
                              ),
                              _pdfCell(
                                _money(part.cost.toDouble()),
                                align: pw.TextAlign.right,
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                ],
              ),
            ),
          ),
          pw.SizedBox(height: 8),
          _pdfSectionBox(
            title: 'Inspection Notes:',
            children: [
              pw.Text(_pdfLine('Tyre Condition', job.tyreCondition)),
              pw.Text(_pdfLine('Ownership', job.ownershipDetails)),
              pw.Text(
                _pdfLine('Vehicle Photos', _vehiclePhotoItems(job).length),
              ),
              pw.Text(_pdfLine('Damage Photos', _damagePhotoItems(job).length)),
            ],
          ),
          pw.SizedBox(height: 8),
          _pdfImageSection('Vehicle Photos', vehicleImages),
          pw.SizedBox(height: 8),
          _pdfImageSection('Damage Photos', damageImages),
          pw.SizedBox(height: 24),
          pw.Row(
            children: [
              pw.Expanded(child: _pdfSignatureBox('Customer Signature')),
              pw.SizedBox(width: 16),
              pw.Expanded(child: _pdfSignatureBox('Service Advisor')),
            ],
          ),
        ],
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final fileName = _safeFileName(
      'job_sheet_${_jobCardSuffix(job.jobCardId.isEmpty ? job.id : job.jobCardId, 6)}.pdf',
    );
    final file = File('${directory.path}${Platform.pathSeparator}$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<File> _createInvoicePdf(Job job, Map<String, dynamic> invoice) async {
    final pdf = pw.Document();
    final billTo = _mapOf(invoice['billTo']);
    final company = _mapOf(invoice['company']);
    final payment = _mapOf(invoice['payment']);
    final customerDetails = _mapOf(invoice['customerDetails']);
    final items = _invoiceItemMaps(invoice);
    final logo = await _loadPdfImage('assets/logo.png');
    final invoiceNumber = _text(
      invoice['invoiceNumber'] ??
          invoice['invoiceNo'] ??
          invoice['invoice_number'] ??
          invoice['_id'] ??
          invoice['id'] ??
          invoice['invoiceId'],
      fallback: job.jobCardId.isEmpty ? 'Invoice' : job.jobCardId,
    );
    final customerName = _text(
      billTo['name'] ??
          customerDetails['name'] ??
          invoice['customerName'] ??
          invoice['customer_name'],
      fallback: job.customerName,
    );
    final phone = _text(
      billTo['phone'] ?? customerDetails['phone'] ?? invoice['phoneNumber'],
      fallback: job.phoneNumber,
    );
    final address = _text(
      billTo['address'] ?? customerDetails['address'],
      fallback: _jobAddress(job),
    );
    final invoiceDate = _text(
      invoice['invoiceDate'] ??
          invoice['invoice_date'] ??
          invoice['createdAt'] ??
          invoice['date'],
      fallback: _dateOnly(DateTime.now()),
    );
    final placeOfSupply = _text(
      invoice['placeOfSupply'] ?? company['state'],
      fallback: '07-Delhi',
    );
    final paymentStatus = _text(payment['paymentStatus'], fallback: 'Pending');
    final subtotal = _invoiceSubtotal(invoice);
    final discount = _num(payment['discount']);
    final tax = _num(payment['tax']);
    final total = _invoiceTotal(invoice, subtotal, discount, tax);
    final received = _num(payment['received']);
    final balance = _num(payment['balance']) > 0
        ? _num(payment['balance'])
        : (total - received).clamp(0, double.infinity).toDouble();
    final terms = _text(
      invoice['termsAndConditions'],
      fallback: 'Thank you for doing business with us.',
    );
    final vehicleNumber = _text(
      customerDetails['vehicleNumber'] ??
          invoice['vehicleNumber'] ??
          invoice['registrationNumber'],
      fallback: job.vehicleNumber,
    );
    final vehicleName = _text(
      customerDetails['vehicleName'] ??
          invoice['vehicleModel'] ??
          invoice['vehicleBrand'],
      fallback: job.vehicleModel,
    );
    final vehicleModel = _text(
      customerDetails['vehicleModel'] ?? invoice['vehicleYear'],
    );
    final odometer = _text(
      customerDetails['odometerReading'] ?? invoice['kmsDriven'],
    );

    pdf.addPage(
      pw.MultiPage(
        pageTheme: const pw.PageTheme(
          margin: pw.EdgeInsets.all(28),
          pageFormat: PdfPageFormat.a4,
        ),
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'Tax Invoice',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 10),
          _pdfBorderBox(
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(12),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (logo != null) pw.Image(logo, width: 58, height: 36),
                  if (logo != null) pw.SizedBox(width: 14),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          _text(
                            company['name'],
                            fallback: 'HORNVIN ENTERPRISES',
                          ),
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(_text(company['address'])),
                        pw.Text('Phone: ${_text(company['phone'])}'),
                        pw.Text('GSTIN: ${_text(company['gstin'])}'),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Email: ${_text(company['email'])}'),
                        pw.Text('State: ${_text(company['state'])}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _pdfTwoColumnBox(
            leftTitle: 'Bill To:',
            left: [
              customerName,
              address,
              'Contact No: $phone',
              if (_text(billTo['email']).isNotEmpty)
                'Email: ${_text(billTo['email'])}',
              if (_text(billTo['gstin']).isNotEmpty)
                'GSTIN: ${_text(billTo['gstin'])}',
              if (vehicleNumber.isNotEmpty) 'Vehicle No: $vehicleNumber',
              if (vehicleName.isNotEmpty) 'Vehicle: $vehicleName',
              if (vehicleModel.isNotEmpty) 'Model: $vehicleModel',
              if (odometer.isNotEmpty) 'Odometer: $odometer',
              if (job.jobCardId.isNotEmpty) 'Job Card: ${job.jobCardId}',
            ],
            rightTitle: 'Invoice Details:',
            right: [
              'No: $invoiceNumber',
              'Date: ${_formatPdfDate(invoiceDate)}',
              'Place of Supply: $placeOfSupply',
              'Payment Mode: ${_text(payment['paymentMode'], fallback: 'Cash')}',
              'Payment Status: $paymentStatus',
            ],
          ),
          pw.SizedBox(height: 8),
          if (items.isEmpty)
            pw.Text('No line items available')
          else
            _pdfItemsTable(items),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(child: pw.SizedBox(height: 92)),
              pw.Container(
                width: 220,
                child: pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.blueGrey900),
                  columnWidths: const {
                    0: pw.FlexColumnWidth(1.2),
                    1: pw.FlexColumnWidth(1),
                  },
                  children: [
                    _pdfSummaryRow('Sub Total', _money(subtotal)),
                    if (discount > 0)
                      _pdfSummaryRow('Discount', _money(discount)),
                    if (tax > 0) _pdfSummaryRow('Tax', _money(tax)),
                    _pdfSummaryRow('Total', _money(total), strong: true),
                    _pdfSummaryRow('Received', _money(received)),
                    _pdfSummaryRow('Balance', _money(balance)),
                  ],
                ),
              ),
            ],
          ),
          _pdfBorderBox(
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Payment Mode:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(_text(payment['paymentMode'], fallback: 'Cash')),
                ],
              ),
            ),
          ),
          pw.SizedBox(height: 6),
          _pdfBorderBox(
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Terms And Conditions:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(terms),
                ],
              ),
            ),
          ),
          pw.Row(
            children: [
              pw.Expanded(child: pw.SizedBox()),
              pw.Container(
                width: 280,
                height: 82,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.blueGrey900),
                ),
                padding: const pw.EdgeInsets.all(6),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'For ${_text(company['name'], fallback: 'HORNVIN ENTERPRISES')}:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Spacer(),
                    pw.Center(child: pw.Text('Authorized Signatory')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final fileName = _safeFileName(
      'invoice_${_jobCardSuffix(invoiceNumber, 6)}.pdf',
    );
    final file = File('${directory.path}${Platform.pathSeparator}$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<pw.MemoryImage?> _loadPdfImage(String assetPath) async {
    try {
      final data = await rootBundle.load(assetPath);
      return pw.MemoryImage(data.buffer.asUint8List());
    } catch (_) {
      return null;
    }
  }

  Future<List<_JobSheetPdfImage>> _jobSheetImages(
    List<_JobSheetImageSource> sources, {
    int limit = 8,
  }) async {
    final images = <_JobSheetPdfImage>[];
    for (final source in sources.take(limit)) {
      final image = await _loadJobSheetImage(source.path);
      if (image == null) continue;
      images.add(
        _JobSheetPdfImage(title: source.title, note: source.note, image: image),
      );
    }
    return images;
  }

  Future<pw.MemoryImage?> _loadJobSheetImage(String path) async {
    final source = path.trim();
    if (source.isEmpty) return null;
    try {
      final file = File(source);
      if (await file.exists()) {
        return pw.MemoryImage(await file.readAsBytes());
      }

      for (final url in _imageUrlCandidates(source)) {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return pw.MemoryImage(response.bodyBytes);
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  List<String> _imageUrlCandidates(String value) {
    final source = value.trim();
    if (source.isEmpty ||
        source.startsWith('http://') ||
        source.startsWith('https://')) {
      return source.isEmpty ? <String>[] : <String>[source];
    }

    final base = ApiConstants.baseUrl.replaceFirst(RegExp(r'/+$'), '');
    final cleanSource = source.replaceFirst(RegExp(r'^/+'), '');
    final candidates = <String>['$base/$cleanSource'];
    if (!cleanSource.startsWith('uploads/')) {
      candidates.add('$base/uploads/$cleanSource');
    }
    return candidates;
  }

  List<_JobSheetImageSource> _vehiclePhotoItems(Job job) {
    return job.vehiclePhotos
        .map(
          (photo) => _JobSheetImageSource(
            title: 'Vehicle Photo',
            path: _imagePathFrom(photo),
          ),
        )
        .where((item) => item.path.isNotEmpty)
        .toList();
  }

  List<_JobSheetImageSource> _damagePhotoItems(Job job) {
    final items = <_JobSheetImageSource>[];
    for (final damage in job.damagePhotosWithNotes) {
      if (damage is Map) {
        final title = _text(damage['title']);
        final note = _text(damage['description'] ?? damage['note']);
        final images = damage['images'];
        if (images is List) {
          for (final image in images) {
            items.add(
              _JobSheetImageSource(
                title: title.isEmpty ? 'Damage Photo' : title,
                note: note,
                path: _imagePathFrom(image),
              ),
            );
          }
        } else {
          final directImage = _text(
            damage['image'] ??
                damage['photo'] ??
                damage['file'] ??
                damage['fileUrl'] ??
                damage['imageUrl'],
          );
          items.add(
            _JobSheetImageSource(
              title: title.isEmpty ? 'Damage Photo' : title,
              note: note,
              path: directImage.isNotEmpty
                  ? directImage
                  : _imagePathFrom(damage),
            ),
          );
        }
      } else {
        items.add(
          _JobSheetImageSource(
            title: 'Damage Photo',
            path: _imagePathFrom(damage),
          ),
        );
      }
    }
    for (final answer in job.inspectionAnswers) {
      if (answer is! Map) continue;
      final selectedValue = _text(answer['selectedValue'] ?? answer['answer']);
      if (selectedValue.toLowerCase() != 'damage') continue;
      final title = _text(answer['checkpoint'] ?? answer['title']);
      final note = _text(answer['description'] ?? answer['note']);
      final images = answer['images'];
      if (images is List) {
        for (final image in images) {
          items.add(
            _JobSheetImageSource(
              title: title.isEmpty ? 'Damage Photo' : title,
              note: note,
              path: _imagePathFrom(image),
            ),
          );
        }
      } else {
        items.add(
          _JobSheetImageSource(
            title: title.isEmpty ? 'Damage Photo' : title,
            note: note,
            path: _imagePathFrom(answer),
          ),
        );
      }
    }
    items.addAll(_popupChecklistDamagePhotoItems(job));
    final seenPaths = <String>{};
    return items.where((item) {
      final key = item.path.trim();
      return key.isNotEmpty && seenPaths.add(key);
    }).toList();
  }

  List<_JobSheetImageSource> _popupChecklistDamagePhotoItems(Job job) {
    final popupData = job.popupData;
    if (popupData == null) return <_JobSheetImageSource>[];

    final inspectionChecklist = _mapOf(popupData['inspectionChecklist']);
    final sections = inspectionChecklist['sections'];
    if (sections is! List) return <_JobSheetImageSource>[];

    final items = <_JobSheetImageSource>[];
    for (final section in sections) {
      if (section is! Map) continue;
      final sectionName = _text(section['sectionName'] ?? section['name']);
      final checkpoints = section['checkpoints'];
      if (checkpoints is! List) continue;

      for (final checkpoint in checkpoints) {
        if (checkpoint is! Map) continue;
        final answer = _text(
          checkpoint['answer'] ?? checkpoint['selectedValue'],
        );
        if (answer.toLowerCase() != 'damage') continue;

        final title = _text(
          checkpoint['checkpoint'] ?? checkpoint['title'],
          fallback: sectionName.isEmpty ? 'Damage Photo' : sectionName,
        );
        final note = _text(checkpoint['description'] ?? checkpoint['note']);
        final images = checkpoint['images'];
        if (images is List) {
          for (final image in images) {
            items.add(
              _JobSheetImageSource(
                title: title,
                note: note,
                path: _imagePathFrom(image),
              ),
            );
          }
        } else {
          items.add(
            _JobSheetImageSource(
              title: title,
              note: note,
              path: _imagePathFrom(checkpoint),
            ),
          );
        }
      }
    }
    return items;
  }

  String _imagePathFrom(dynamic value) {
    if (value is Map) {
      final direct = _text(
        value['url'] ??
            value['secure_url'] ??
            value['localPath'] ??
            value['path'] ??
            value['filePath'] ??
            value['file'] ??
            value['image'] ??
            value['photo'] ??
            value['fileUrl'] ??
            value['imageUrl'] ??
            value['src'],
      );
      if (direct.isNotEmpty) return direct;

      for (final nestedKey in ['data', 'fileData', 'media']) {
        final nested = value[nestedKey];
        final nestedPath = _imagePathFrom(nested);
        if (nestedPath.isNotEmpty) return nestedPath;
      }
    }
    return _text(value);
  }

  pw.Widget _pdfBorderBox({required pw.Widget child}) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blueGrey900),
      ),
      child: child,
    );
  }

  pw.Widget _pdfImageSection(String title, List<_JobSheetPdfImage> images) {
    return _pdfBorderBox(
      child: pw.Padding(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            if (images.isEmpty)
              pw.SizedBox(height: 20)
            else
              pw.Wrap(
                spacing: 8,
                runSpacing: 8,
                children: images
                    .map(
                      (item) => pw.Container(
                        width: 122,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                              width: 122,
                              height: 92,
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(
                                  color: PdfColors.blueGrey900,
                                ),
                              ),
                              child: pw.Image(item.image, fit: pw.BoxFit.cover),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              item.title,
                              maxLines: 1,
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              item.note,
                              maxLines: 2,
                              style: const pw.TextStyle(fontSize: 7),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  pw.Widget _pdfSectionBox({
    required String title,
    required List<pw.Widget> children,
  }) {
    return _pdfBorderBox(
      child: pw.Padding(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 6),
            ...children,
          ],
        ),
      ),
    );
  }

  pw.Widget _pdfSignatureBox(String label) {
    return pw.Container(
      height: 72,
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blueGrey900),
      ),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Divider(color: PdfColors.blueGrey900),
          pw.Text(label, style: const pw.TextStyle(fontSize: 9)),
        ],
      ),
    );
  }

  pw.Widget _pdfTwoColumnBox({
    required String leftTitle,
    required List<String> left,
    required String rightTitle,
    required List<String> right,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.blueGrey900),
      columnWidths: const {0: pw.FlexColumnWidth(1), 1: pw.FlexColumnWidth(1)},
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _pdfCell(leftTitle, bold: true),
            _pdfCell(rightTitle, bold: true),
          ],
        ),
        pw.TableRow(
          children: [
            _pdfCell(left.where((value) => value.trim().isNotEmpty).join('\n')),
            _pdfCell(
              right.where((value) => value.trim().isNotEmpty).join('\n'),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _pdfItemsTable(List<Map<String, dynamic>> items) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.blueGrey900),
      columnWidths: const {
        0: pw.FixedColumnWidth(28),
        1: pw.FlexColumnWidth(2.3),
        2: pw.FixedColumnWidth(50),
        3: pw.FixedColumnWidth(58),
        4: pw.FixedColumnWidth(50),
        5: pw.FixedColumnWidth(72),
        6: pw.FixedColumnWidth(72),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _pdfCell('#', bold: true, align: pw.TextAlign.center),
            _pdfCell('Item Name', bold: true),
            _pdfCell('Count', bold: true, align: pw.TextAlign.right),
            _pdfCell('Quantity', bold: true, align: pw.TextAlign.right),
            _pdfCell('Unit', bold: true, align: pw.TextAlign.right),
            _pdfCell('Price/ Unit', bold: true, align: pw.TextAlign.right),
            _pdfCell('Amount', bold: true, align: pw.TextAlign.right),
          ],
        ),
        ...items.asMap().entries.map((entry) {
          final item = entry.value;
          return pw.TableRow(
            children: [
              _pdfCell('${entry.key + 1}', align: pw.TextAlign.center),
              _pdfCell(_pdfItemName(item)),
              _pdfCell(
                _numberText(_num(item['count'])),
                align: pw.TextAlign.right,
              ),
              _pdfCell(_numberText(_quantity(item)), align: pw.TextAlign.right),
              _pdfCell(_text(item['unit']), align: pw.TextAlign.right),
              _pdfCell(_money(_rate(item)), align: pw.TextAlign.right),
              _pdfCell(_money(_lineTotal(item)), align: pw.TextAlign.right),
            ],
          );
        }),
        pw.TableRow(
          children: [
            _pdfCell(''),
            _pdfCell('Total', bold: true),
            _pdfCell(
              _numberText(
                items.fold<double>(0, (sum, item) => sum + _num(item['count'])),
              ),
              bold: true,
              align: pw.TextAlign.right,
            ),
            _pdfCell(
              _numberText(
                items.fold<double>(0, (sum, item) => sum + _quantity(item)),
              ),
              bold: true,
              align: pw.TextAlign.right,
            ),
            _pdfCell(''),
            _pdfCell(''),
            _pdfCell(
              _money(
                items.fold<double>(0, (sum, item) => sum + _lineTotal(item)),
              ),
              bold: true,
              align: pw.TextAlign.right,
            ),
          ],
        ),
      ],
    );
  }

  pw.TableRow _pdfSummaryRow(
    String label,
    String value, {
    bool strong = false,
  }) {
    final style = pw.TextStyle(
      fontSize: 9,
      fontWeight: strong ? pw.FontWeight.bold : pw.FontWeight.normal,
    );
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(label, style: style),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(value, textAlign: pw.TextAlign.right, style: style),
        ),
      ],
    );
  }

  pw.Widget _pdfCell(
    String value, {
    bool bold = false,
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        value,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: 8.5,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  String _pdfItemName(Map<String, dynamic> item) {
    final name = _text(
      item['itemName'] ??
          item['partName'] ??
          item['serviceName'] ??
          item['name'] ??
          item['title'],
      fallback: 'Item',
    );
    final description = _text(item['description']);
    return description.isEmpty ? name : '$name\n($description)';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateBlank(DateTime? date) {
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _pdfLine(String label, dynamic value) {
    return '$label: ${_text(value)}';
  }

  String _jobCardSuffix(String jobCardId, int length) {
    if (jobCardId.isEmpty) return 'N/A';
    if (jobCardId.length <= length) return jobCardId;
    return jobCardId.substring(jobCardId.length - length);
  }

  List<Map<String, dynamic>> _invoiceItemMaps(Map<String, dynamic> invoice) {
    return [
      ..._listOfMaps(invoice['items']),
      ..._listOfMaps(invoice['invoiceItems']),
    ];
  }

  double _invoiceSubtotal(Map<String, dynamic> invoice) {
    final payment = _mapOf(invoice['payment']);
    final direct = _num(
      invoice['subTotal'] ??
          invoice['subtotal'] ??
          payment['subTotal'] ??
          payment['subtotal'],
    );
    if (direct > 0) return direct;
    return _invoiceItemMaps(
      invoice,
    ).fold<double>(0, (sum, item) => sum + _lineTotal(item));
  }

  double _invoiceTotal(
    Map<String, dynamic> invoice,
    double subtotal,
    double discount,
    double tax,
  ) {
    final direct = _text(
      invoice['totalAmount'] ??
          invoice['total_amount'] ??
          invoice['totalPrice'] ??
          invoice['grandTotal'] ??
          invoice['amount'] ??
          invoice['total'] ??
          _mapOf(invoice['payment'])['total'],
    );
    if (direct.isNotEmpty) return _num(direct);
    return subtotal - discount + tax;
  }

  double _quantity(Map<String, dynamic> item) {
    final quantity = _num(item['quantity'] ?? item['qty']);
    return quantity > 0 ? quantity : 1;
  }

  double _rate(Map<String, dynamic> item) {
    return _num(
      item['pricePerUnit'] ??
          item['rate'] ??
          item['price'] ??
          item['cost'] ??
          item['amount'],
    );
  }

  double _lineTotal(Map<String, dynamic> item) {
    final direct = _num(
      item['amount'] ??
          item['total'] ??
          item['totalAmount'] ??
          item['lineTotal'],
    );
    if (direct > 0) return direct;
    return _quantity(item) * _rate(item);
  }

  String _money(double value) {
    return 'Rs ${_numberText(value)}';
  }

  String _numberText(double value) {
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value.toStringAsFixed(2);
  }

  String _formatPdfDate(String value) {
    final parts = value.split('T').first.split('-');
    if (parts.length == 3 && parts.first.length == 4) {
      return '${parts[2]}-${parts[1]}-${parts[0]}';
    }
    return value;
  }

  String _jobAddress(Job job) {
    final address = job.address ?? <String, dynamic>{};
    return [
          address['fullAddress'],
          address['landmark'],
          address['city'],
          address['state'],
          address['pincode'],
        ]
        .where((value) => value != null && value.toString().trim().isNotEmpty)
        .join(', ');
  }

  List<Map<String, dynamic>> _listOfMaps(dynamic value) {
    if (value is! List) return <Map<String, dynamic>>[];
    return value.whereType<Map>().map(Map<String, dynamic>.from).toList();
  }

  Map<String, dynamic> _mapOf(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return {};
  }

  double _num(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _text(dynamic value, {String fallback = ''}) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  String _safeFileName(String value) {
    return value.replaceAll(RegExp(r'[\\/:*?"<>|]+'), '_');
  }

  String _dateOnly(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  void _showMessage(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}

class _JobSheetImageSource {
  final String title;
  final String note;
  final String path;

  const _JobSheetImageSource({
    required this.title,
    this.note = '',
    required this.path,
  });
}

class _JobSheetPdfImage {
  final String title;
  final String note;
  final pw.MemoryImage image;

  const _JobSheetPdfImage({
    required this.title,
    required this.note,
    required this.image,
  });
}
