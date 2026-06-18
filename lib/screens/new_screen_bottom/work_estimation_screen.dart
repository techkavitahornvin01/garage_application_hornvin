// // screens/work_estimation_screen.dart
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import '../providers/estimation_provider.dart';

// class WorkEstimationScreen extends StatefulWidget {
//   const WorkEstimationScreen({super.key});

//   @override
//   State<WorkEstimationScreen> createState() => _WorkEstimationScreenState();
// }

// class _WorkEstimationScreenState extends State<WorkEstimationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _customerNameController = TextEditingController();
//   final _vehicleNumberController = TextEditingController();
//   final _vehicleModelController = TextEditingController();

//   List<ServiceItem> services = [];
//   List<PartItem> parts = [];

//   @override
//   Widget build(BuildContext context) {
//     final estimationProvider = Provider.of<EstimationProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(context.trData(//           'Work Estimation'),
//           style: GoogleFonts.lato(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: const Color(0xFF1A237E),
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: () => _shareEstimate(estimationProvider),
//           ),
//           IconButton(
//             icon: const Icon(Icons.picture_as_pdf),
//             onPressed: () => _generatePDF(estimationProvider),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Customer Details Card
//               _buildSectionCard(
//                 title: 'Customer Details',
//                 icon: Icons.person,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       controller: _customerNameController,
//                       decoration: InputDecoration(
//                         labelText: context.trText('Customer Name'),
//                         prefixIcon: Icon(Icons.person_outline),
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (value) => value?.isEmpty == true ? 'Required' : null,
//                     ),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: _vehicleNumberController,
//                       decoration: InputDecoration(
//                         labelText: context.trText('Vehicle Number'),
//                         prefixIcon: Icon(Icons.directions_car),
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (value) => value?.isEmpty == true ? 'Required' : null,
//                     ),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: _vehicleModelController,
//                       decoration: InputDecoration(
//                         labelText: context.trText('Vehicle Model'),
//                         prefixIcon: Icon(Icons.model_training),
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Services Section
//               _buildSectionCard(
//                 title: 'Services',
//                 icon: Icons.build,
//                 action: TextButton.icon(
//                   onPressed: () => _addService(),
//                   icon: const Icon(Icons.add, size: 18),
//                   label: Text(context.trText('Add Service')),
//                   style: TextButton.styleFrom(
//                     foregroundColor: const Color(0xFFFF6B35),
//                   ),
//                 ),
//                 child: services.isEmpty
//                     ? _buildEmptyState('No services added')
//                     : ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: services.length,
//                         itemBuilder: (context, index) {
//                           return _buildServiceItem(services[index], index);
//                         },
//                       ),
//               ),
//               const SizedBox(height: 16),

//               // Parts Section
//               _buildSectionCard(
//                 title: 'Parts',
//                 icon: Icons.inventory,
//                 action: TextButton.icon(
//                   onPressed: () => _addPart(),
//                   icon: const Icon(Icons.add, size: 18),
//                   label: Text(context.trText('Add Part')),
//                   style: TextButton.styleFrom(
//                     foregroundColor: const Color(0xFFFF6B35),
//                   ),
//                 ),
//                 child: parts.isEmpty
//                     ? _buildEmptyState('No parts added')
//                     : ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: parts.length,
//                         itemBuilder: (context, index) {
//                           return _buildPartItem(parts[index], index);
//                         },
//                       ),
//               ),
//               const SizedBox(height: 16),

//               // Summary Card
//               _buildSummaryCard(estimationProvider),
//               const SizedBox(height: 16),

//               // Action Buttons
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () {
//                         _formKey.currentState?.reset();
//                         setState(() {
//                           services.clear();
//                           parts.clear();
//                           _customerNameController.clear();
//                           _vehicleNumberController.clear();
//                           _vehicleModelController.clear();
//                         });
//                       },
//                       icon: const Icon(Icons.clear),
//                       label: Text(context.trText('Reset')),
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () => _saveAndShareEstimate(estimationProvider),
//                       icon: const Icon(Icons.send),
//                       label: Text(context.trText('Share Estimate')),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFFF6B35),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionCard({required String title, required IconData icon, Widget? action, required Widget child}) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(icon, color: const Color(0xFFFF6B35), size: 20),
//                     const SizedBox(width: 8),
//                     Text(context.trData(//                       title),
//                       style: GoogleFonts.lato(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xFF1A237E),
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (action != null) action,
//               ],
//             ),
//             const SizedBox(height: 12),
//             child,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState(String message) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 20),
//         child: Column(
//           children: [
//             Icon(Icons.info_outline, color: Colors.grey[400], size: 40),
//             const SizedBox(height: 8),
//             Text(context.trData(//               message),
//               style: GoogleFonts.lato(color: Colors.grey[500]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildServiceItem(ServiceItem service, int index) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(context.trData(//                   service.name),
//                   style: GoogleFonts.lato(fontWeight: FontWeight.w500),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(context.trData(//                   '₹${service.price}'),
//                   style: GoogleFonts.lato(
//                     color: const Color(0xFFFF6B35),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete_outline, color: Colors.red),
//             onPressed: () => setState(() => services.removeAt(index)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPartItem(PartItem part, int index) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(context.trData(//                   part.name),
//                   style: GoogleFonts.lato(fontWeight: FontWeight.w500),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(context.trData(//                   'Qty: ${part.quantity} x ₹${part.price} = ₹${part.quantity * part.price}'),
//                   style: GoogleFonts.lato(fontSize: 12, color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete_outline, color: Colors.red),
//             onPressed: () => setState(() => parts.removeAt(index)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryCard(EstimationProvider provider) {
//     double subtotal = 0;
//     for (var service in services) {
//       subtotal += service.price;
//     }
//     for (var part in parts) {
//       subtotal += part.price * part.quantity;
//     }
//     double tax = subtotal * 0.18;
//     double total = subtotal + tax;

//     return Card(
//       elevation: 4,
//       color: const Color(0xFF1A237E),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(context.trData(//               'Estimate Summary'),
//               style: GoogleFonts.lato(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 12),
//             _buildSummaryRow('Subtotal', '₹${subtotal.toStringAsFixed(2)}', Colors.white70),
//             _buildSummaryRow('Tax (18%)', '₹${tax.toStringAsFixed(2)}', Colors.white70),
//             const Divider(color: Colors.white24),
//             _buildSummaryRow('Total', '₹${total.toStringAsFixed(2)}', Colors.white, isBold: true),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSummaryRow(String label, String value, Color color, {bool isBold = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(context.trData(//             label),
//             style: GoogleFonts.lato(color: color, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
//           ),
//           Text(context.trData(//             value),
//             style: GoogleFonts.lato(
//               color: color,
//               fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
//               fontSize: isBold ? 18 : 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _addService() {
//     showDialog(
//       context: context,
//       builder: (context) => _AddServiceDialog(
//         onAdd: (service) => setState(() => services.add(service)),
//       ),
//     );
//   }

//   void _addPart() {
//     showDialog(
//       context: context,
//       builder: (context) => _AddPartDialog(
//         onAdd: (part) => setState(() => parts.add(part)),
//       ),
//     );
//   }

//   void _saveAndShareEstimate(EstimationProvider provider) {
//     if (_formKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(context.trText('Estimate shared successfully!'))),
//       );
//     }
//   }

//   void _shareEstimate(EstimationProvider provider) {}

//   void _generatePDF(EstimationProvider provider) {}
// }

// class ServiceItem {
//   final String name;
//   final double price;
//   ServiceItem({required this.name, required this.price});
// }

// class PartItem {
//   final String name;
//   final double price;
//   final int quantity;
//   PartItem({required this.name, required this.price, required this.quantity});
// }

// class _AddServiceDialog extends StatefulWidget {
//   final Function(ServiceItem) onAdd;
//   const _AddServiceDialog({required this.onAdd});

//   @override
//   State<_AddServiceDialog> createState() => _AddServiceDialogState();
// }

// class _AddServiceDialogState extends State<_AddServiceDialog> {
//   final _nameController = TextEditingController();
//   final _priceController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(context.trText('Add Service')),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(
//             controller: _nameController,
//             decoration: InputDecoration(
//               labelText: context.trText('Service Name'),
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 12),
//           TextField(
//             controller: _priceController,
//             decoration: InputDecoration(
//               labelText: context.trText('Price (₹)'),
//               border: OutlineInputBorder(),
//             ),
//             keyboardType: TextInputType.number,
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text(context.trText('Cancel')),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             if (_nameController.text.isNotEmpty && _priceController.text.isNotEmpty) {
//               widget.onAdd(ServiceItem(
//                 name: _nameController.text,
//                 price: double.parse(_priceController.text),
//               ));
//               Navigator.pop(context);
//             }
//           },
//           style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B35)),
//           child: Text(context.trText('Add')),
//         ),
//       ],
//     );
//   }
// }

// class _AddPartDialog extends StatefulWidget {
//   final Function(PartItem) onAdd;
//   const _AddPartDialog({required this.onAdd});

//   @override
//   State<_AddPartDialog> createState() => _AddPartDialogState();
// }

// class _AddPartDialogState extends State<_AddPartDialog> {
//   final _nameController = TextEditingController();
//   final _priceController = TextEditingController();
//   final _quantityController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(context.trText('Add Part')),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(
//             controller: _nameController,
//             decoration: InputDecoration(
//               labelText: context.trText('Part Name'),
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 12),
//           TextField(
//             controller: _priceController,
//             decoration: InputDecoration(
//               labelText: context.trText('Price (₹)'),
//               border: OutlineInputBorder(),
//             ),
//             keyboardType: TextInputType.number,
//           ),
//           const SizedBox(height: 12),
//           TextField(
//             controller: _quantityController,
//             decoration: InputDecoration(
//               labelText: context.trText('Quantity'),
//               border: OutlineInputBorder(),
//             ),
//             keyboardType: TextInputType.number,
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text(context.trText('Cancel')),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             if (_nameController.text.isNotEmpty &&
//                 _priceController.text.isNotEmpty &&
//                 _quantityController.text.isNotEmpty) {
//               widget.onAdd(PartItem(
//                 name: _nameController.text,
//                 price: double.parse(_priceController.text),
//                 quantity: int.parse(_quantityController.text),
//               ));
//               Navigator.pop(context);
//             }
//           },
//           style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B35)),
//           child: Text(context.trText('Add')),
//         ),
//       ],
//     );
//   }
// }
