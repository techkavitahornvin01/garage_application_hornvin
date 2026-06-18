import 'package:hornvin/localization/app_localizations.dart';
// import 'package:flutter/material.dart';
// import 'package:hornvin/controllers/job_controller.dart';
// import 'package:hornvin/models/job_model/job_model.dart';
// import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
// class AddEditJobScreen extends StatefulWidget {
//   final Job? job;
//   const AddEditJobScreen({Key? key, this.job}) : super(key: key);

//   @override
//   State<AddEditJobScreen> createState() => _AddEditJobScreenState();
// }

// class _AddEditJobScreenState extends State<AddEditJobScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final List<Part> _partsList = [];

//   late TextEditingController _customerNameController;
//   late TextEditingController _phoneController;
//   late TextEditingController _vehicleNumberController;
//   late TextEditingController _vehicleTypeController;
//   late TextEditingController _vehicleModelController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _mechanicNameController;
//   late TextEditingController _mechanicProfileController;
//   late TextEditingController _notesController;

//   DateTime _serviceDate = DateTime.now();
//   DateTime _nextServiceDate = DateTime.now().add(const Duration(days: 90));
//   String _status = 'Pending';

//   @override
//   void initState() {
//     super.initState();
//     _customerNameController = TextEditingController(text: widget.job?.customerName ?? '');
//     _phoneController = TextEditingController(text: widget.job?.phoneNumber ?? '');
//     _vehicleNumberController = TextEditingController(text: widget.job?.vehicleNumber ?? '');
//     _vehicleTypeController = TextEditingController(text: widget.job?.vehicleType ?? '');
//     _vehicleModelController = TextEditingController(text: widget.job?.vehicleModel ?? '');
//     _descriptionController = TextEditingController(text: widget.job?.description ?? '');
//     _mechanicNameController = TextEditingController(text: widget.job?.mechanicName ?? '');
//     _mechanicProfileController = TextEditingController(text: widget.job?.mechanicProfile ?? '');
//     _notesController = TextEditingController(text: widget.job?.notes ?? '');

//     if (widget.job != null) {
//       _serviceDate = widget.job!.serviceDate;
//       _nextServiceDate = widget.job!.nextServiceDate;
//       _status = widget.job!.status;
//       _partsList.addAll(widget.job!.parts);
//     }
//   }

//   @override
//   void dispose() {
//     _customerNameController.dispose();
//     _phoneController.dispose();
//     _vehicleNumberController.dispose();
//     _vehicleTypeController.dispose();
//     _vehicleModelController.dispose();
//     _descriptionController.dispose();
//     _mechanicNameController.dispose();
//     _mechanicProfileController.dispose();
//     _notesController.dispose();
//     super.dispose();
//   }

//   Future<void> _saveJob() async {
//     if (_formKey.currentState!.validate()) {
//       final totalCost = _partsList.fold(0, (sum, part) => sum + part.cost);

//       final job = Job(
//         id: widget.job?.id,
//         jobCardId: widget.job?.jobCardId ?? 'JOB${DateTime.now().millisecondsSinceEpoch}',
//         customerName: _customerNameController.text,
//         phoneNumber: _phoneController.text,
//         vehicleNumber: _vehicleNumberController.text,
//         vehicleType: _vehicleTypeController.text,
//         vehicleModel: _vehicleModelController.text,
//         serviceDate: _serviceDate,
//         nextServiceDate: _nextServiceDate,
//         description: _descriptionController.text,
//         mechanicName: _mechanicNameController.text,
//         mechanicProfile: _mechanicProfileController.text,
//         vehiclePhotos: [],
//         vehicleVideo: '',
//         parts: _partsList,
//         totalPartsCost: totalCost,
//         status: _status,
//         notes: _notesController.text,
//       );

//       bool success;
//       if (widget.job == null) {
//         success = await context.read<JobController>().createJob(job);
//       } else {
//         success = await context.read<JobController>().updateJob(job.id!, job);
//       }

//       if (context.mounted) {
//         if (success) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Row(
//                 children: [
//                   Icon(Icons.check_circle, color: Colors.white),
//                   const SizedBox(width: 12),
//                   Expanded(child: Text(widget.job == null ? 'Job created successfully!' : 'Job updated successfully!')),
//                 ],
//               ),
//               backgroundColor: Colors.green.shade700,
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//           );
//           Navigator.pop(context, true);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Row(
//                 children: [
//                   Icon(Icons.error, color: Colors.white),
//                   const SizedBox(width: 12),
//                   Expanded(child: Text(widget.job == null ? 'Failed to create job' : 'Failed to update job')),
//                 ],
//               ),
//               backgroundColor: Colors.red.shade700,
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//           );
//         }
//       }
//     }
//   }

//   Future<void> _addPart() async {
//     final partNameController = TextEditingController();
//     final costController = TextEditingController();

//     await showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(context.trData(//                 'Add Part'),
//                 style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF1A237E)),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: partNameController,
//                 decoration: InputDecoration(
//                   labelText: context.trText('Part Name'),
//                   prefixIcon: Icon(Icons.build, color: const Color(0xFFE31E24)),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: costController,
//                 decoration: InputDecoration(
//                   labelText: context.trText('Cost (₹)'),
//                   prefixIcon: Icon(Icons.currency_rupee, color: const Color(0xFFE31E24)),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(context),
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       ),
//                       child: Text(context.trText('Cancel'), style: GoogleFonts.lato()),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (partNameController.text.isNotEmpty && costController.text.isNotEmpty) {
//                           setState(() {
//                             _partsList.add(Part(
//                               partName: partNameController.text,
//                               cost: int.parse(costController.text),
//                             ));
//                           });
//                           Navigator.pop(context);
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFE31E24),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       ),
//                       child: Text(context.trText('Add'), style: GoogleFonts.lato(fontWeight: FontWeight.w600)),
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: Text(context.trData(//           widget.job == null ? 'Create New Job' : 'Edit Job'),
//           style: GoogleFonts.lato(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: const Color(0xFF1A237E),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           TextButton(
//             onPressed: _saveJob,
//             child: Text(context.trData(//               'Save'),
//               style: GoogleFonts.lato(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               _buildSection('Customer Information', Icons.person, [
//                 _buildTextField(_customerNameController, 'Customer Name', Icons.person, true),
//                 _buildTextField(_phoneController, 'Phone Number', Icons.phone, true),
//               ]),
//               const SizedBox(height: 16),
//               _buildSection('Vehicle Details', Icons.directions_car, [
//                 _buildTextField(_vehicleNumberController, 'Vehicle Number', Icons.directions_car, true),
//                 _buildTextField(_vehicleTypeController, 'Vehicle Type', Icons.category, true),
//                 _buildTextField(_vehicleModelController, 'Vehicle Model', Icons.model_training, true),
//               ]),
//               const SizedBox(height: 16),
//               _buildSection('Service Information', Icons.calendar_today, [
//                 _buildDatePicker('Service Date', _serviceDate, (date) {
//                   setState(() => _serviceDate = date);
//                 }),
//                 _buildDatePicker('Next Service Date', _nextServiceDate, (date) {
//                   setState(() => _nextServiceDate = date);
//                 }),
//                 _buildTextField(_descriptionController, 'Description', Icons.description, true, maxLines: 3),
//               ]),
//               const SizedBox(height: 16),
//               _buildSection('Mechanic Details', Icons.engineering, [
//                 _buildTextField(_mechanicNameController, 'Mechanic Name', Icons.engineering, true),
//                 _buildTextField(_mechanicProfileController, 'Mechanic Profile', Icons.badge, true),
//               ]),
//               const SizedBox(height: 16),
//               _buildSection('Parts Used', Icons.build, [
//                 ..._partsList.asMap().entries.map((entry) => Container(
//                   margin: const EdgeInsets.only(bottom: 8),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade50,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.grey.shade200),
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(context.trData(//                               entry.value.partName),
//                               style: GoogleFonts.lato(fontWeight: FontWeight.w500),
//                             ),
//                             Text(context.trData(//                               '₹${entry.value.cost}'),
//                               style: GoogleFonts.lato(
//                                 color: const Color(0xFFE31E24),
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                         onPressed: () {
//                           setState(() {
//                             _partsList.removeAt(entry.key);
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 )),
//                 const SizedBox(height: 8),
//                 ElevatedButton.icon(
//                   onPressed: _addPart,
//                   icon: const Icon(Icons.add),
//                   label: Text(context.trText('Add Part')),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF1A237E),
//                     foregroundColor: Colors.white,
//                     minimumSize: const Size(double.infinity, 45),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFE31E24).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(context.trData(//                         'Total Cost:'),
//                         style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 16),
//                       ),
//                       Text(context.trData(//                         '₹${_partsList.fold(0), (sum, part) => sum + part.cost)}',
//                         style: GoogleFonts.lato(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                           color: const Color(0xFFE31E24),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ]),
//               const SizedBox(height: 16),
//               _buildSection('Additional Information', Icons.info, [
//                 _buildDropdown(),
//                 _buildTextField(_notesController, 'Notes', Icons.note, false, maxLines: 3),
//               ]),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSection(String title, IconData icon, List<Widget> children) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: const Color(0xFF1A237E),
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

//   Widget _buildTextField(TextEditingController controller, String label, IconData icon, bool required,
//       {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, color: const Color(0xFFE31E24)),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: Color(0xFFE31E24), width: 2),
//           ),
//         ),
//         validator: required
//             ? (value) => value!.isEmpty ? 'Please enter $label' : null
//             : null,
//       ),
//     );
//   }

//   Widget _buildDatePicker(String label, DateTime date, Function(DateTime) onDateSelected) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: InkWell(
//         onTap: () async {
//           final picked = await showDatePicker(
//             context: context,
//             initialDate: date,
//             firstDate: DateTime(2000),
//             lastDate: DateTime(2030),
//             builder: (context, child) {
//               return Theme(
//                 data: ThemeData.light().copyWith(
//                   colorScheme: const ColorScheme.light(primary: Color(0xFFE31E24)),
//                 ),
//                 child: child!,
//               );
//             },
//           );
//           if (picked != null) {
//             onDateSelected(picked);
//           }
//         },
//         child: InputDecorator(
//           decoration: InputDecoration(
//             labelText: label,
//             prefixIcon: Icon(Icons.calendar_today, color: const Color(0xFFE31E24)),
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//           child: Text(context.trData(//             '${date.day}/${date.month}/${date.year}'),
//             style: GoogleFonts.lato(),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdown() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: DropdownButtonFormField<String>(
//         value: _status,
//         decoration: InputDecoration(
//           labelText: context.trText('Status'),
//           prefixIcon: Icon(Icons.timeline, color: const Color(0xFFE31E24)),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//         items: ['Pending', 'In Progress', 'Completed', 'Cancelled'].map((status) {
//           return DropdownMenuItem(value: status, child: Text(status));
//         }).toList(),
//         onChanged: (value) {
//           setState(() => _status = value!);
//         },
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hornvin/controllers/job_controller.dart';
import 'package:hornvin/models/job_model/job_model.dart';
import 'package:hornvin/repositories/garage_repository.dart';
import 'package:hornvin/repositories/invoice_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:hornvin/widgets/app_theme.dart.dart';

class AddEditJobScreen extends StatefulWidget {
  final Job? job;
  const AddEditJobScreen({super.key, this.job});

  @override
  State<AddEditJobScreen> createState() => _AddEditJobScreenState();
}

class _InspectionPhoto {
  final String path;
  final String? url;
  final List<_InspectionMark> marks;

  _InspectionPhoto({required this.path, this.url, List<_InspectionMark>? marks})
    : marks = marks ?? [];

  bool get isLocal => path.isNotEmpty;

  factory _InspectionPhoto.fromValue(dynamic value) {
    if (value is Map) {
      final marks = value['marks'] is List
          ? (value['marks'] as List)
                .map(_InspectionMark.fromValue)
                .whereType<_InspectionMark>()
                .toList()
          : <_InspectionMark>[];

      return _InspectionPhoto(
        path: (value['localPath'] ?? value['path'] ?? '').toString(),
        url: (value['url'] ?? value['secure_url'])?.toString(),
        marks: marks,
      );
    }

    return _InspectionPhoto(path: value?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      if (path.isNotEmpty) 'localPath': path,
      if (url != null && url!.isNotEmpty) 'url': url,
      'marks': marks.map((mark) => mark.toJson()).toList(),
    };
  }
}

class _InspectionMark {
  final String type;
  final double x;
  final double y;
  final String note;

  const _InspectionMark({
    required this.type,
    required this.x,
    required this.y,
    this.note = '',
  });

  static _InspectionMark? fromValue(dynamic value) {
    if (value is! Map) return null;
    return _InspectionMark(
      type: (value['type'] ?? 'Damage').toString(),
      x: _readDouble(value['x']),
      y: _readDouble(value['y']),
      note: (value['note'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'x': x, 'y': y, if (note.isNotEmpty) 'note': note};
  }
}

double _readDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

class _InspectionChecklistSection {
  final int id;
  final String name;
  final List<_InspectionCheckpoint> checkpoints;

  const _InspectionChecklistSection({
    required this.id,
    required this.name,
    required this.checkpoints,
  });

  factory _InspectionChecklistSection.fromJson(Map<String, dynamic> json) {
    final checkpoints = json['checkpoints'] is List
        ? json['checkpoints'] as List
        : <dynamic>[];
    return _InspectionChecklistSection(
      id: _readInt(json['sectionId']),
      name: json['sectionName']?.toString() ?? 'Inspection Section',
      checkpoints: checkpoints
          .whereType<Map>()
          .map(
            (item) =>
                _InspectionCheckpoint.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
    );
  }
}

class _InspectionCheckpoint {
  final int id;
  final String title;
  final String inputType;
  final List<String> options;
  final bool required;

  const _InspectionCheckpoint({
    required this.id,
    required this.title,
    required this.inputType,
    required this.options,
    required this.required,
  });

  factory _InspectionCheckpoint.fromJson(Map<String, dynamic> json) {
    final options = json['options'] is List
        ? (json['options'] as List)
              .map((option) => option.toString())
              .where((option) => option.trim().isNotEmpty)
              .toList()
        : <String>['Damage', 'OK'];
    return _InspectionCheckpoint(
      id: _readInt(json['checkpointId']),
      title: json['checkpoint']?.toString() ?? 'Inspection checkpoint',
      inputType: json['inputType']?.toString() ?? 'radio',
      options: options.isEmpty ? const ['Damage', 'OK'] : options,
      required: json['required'] as bool? ?? false,
    );
  }
}

class _InspectionChecklistPhotoPreview {
  final String path;
  final String title;
  final String sectionName;
  final int checkpointId;

  const _InspectionChecklistPhotoPreview({
    required this.path,
    required this.title,
    required this.sectionName,
    required this.checkpointId,
  });
}

int _readInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

class _AddEditJobScreenState extends State<AddEditJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<Part> _partsList = [];
  final List<_InspectionPhoto> _inspectionPhotos = [];
  final Map<int, String> _inspectionAnswers = {};
  final Map<int, TextEditingController> _inspectionTextControllers = {};
  final Map<int, TextEditingController> _inspectionImageUrlControllers = {};
  final Map<int, TextEditingController> _inspectionDamageDescControllers = {};
  final Map<int, TextEditingController> _inspectionDamageImageControllers = {};
  List<_InspectionChecklistSection> _inspectionChecklistSections = [];
  int _inspectionTotalPoints = 0;
  bool _isInspectionChecklistLoading = false;
  String? _inspectionChecklistError;
  String? _loadedInspectionVehicleType;
  final ImagePicker _imagePicker = ImagePicker();
  final stt.SpeechToText _speech = stt.SpeechToText();
  TextEditingController? _listeningController;
  String _listeningBaseText = '';
  bool _isSpeechAvailable = false;
  bool _isListening = false;
  final List<String> _tyrePositions = const [
    'Front Left',
    'Front Right',
    'Rear Left',
    'Rear Right',
    'Spare Tyre',
  ];
  final List<String> _tyreConditions = const [
    'Good',
    'Average',
    'Worn',
    'Cracked',
    'Punctured',
    'Bad',
    'Needs Replacement',
  ];
  final List<String> _tyreBrands = const [
    'MRF',
    'CEAT',
    'Apollo',
    'JK Tyre',
    'Bridgestone',
    'Michelin',
    'Goodyear',
  ];
  final List<String> _tyreSizes = const [
    '145/80 R12',
    '155/80 R13',
    '165/80 R14',
    '175/65 R14',
    '185/65 R15',
    '195/55 R16',
    '205/55 R16',
  ];

  late TextEditingController _customerNameController;
  late TextEditingController _phoneController;
  late TextEditingController _fullAddressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pincodeController;
  late TextEditingController _landmarkController;
  late TextEditingController _vehicleNumberController;
  late TextEditingController _vehicleTypeController;
  late TextEditingController _vehicleBrandController;
  late TextEditingController _vehicleModelController;
  late TextEditingController _vehicleVariantController;
  late TextEditingController _descriptionController;
  late TextEditingController _todoController;
  late TextEditingController _mechanicNameController;
  late TextEditingController _mechanicProfileController;
  late TextEditingController _notesController;
  late TextEditingController _labourCostController;
  late TextEditingController _totalPriceController;

  // New controllers for additional fields
  late TextEditingController _registrationNumberController;
  late TextEditingController _vehicleYearController;
  late TextEditingController _fuelTypeController;
  late TextEditingController _transmissionTypeController;
  late TextEditingController _kmsDrivenController;
  late TextEditingController _kmImageUrlController;
  late TextEditingController _kmImagePublicIdController;
  late TextEditingController _vehicleColorController;
  late TextEditingController _ownershipDetailsController;
  late TextEditingController _tyreConditionController;
  late TextEditingController _tyrePositionController;
  late TextEditingController _tyreBrandController;
  late TextEditingController _tyreSizeController;
  late TextEditingController _tyreNotesController;
  late TextEditingController _damageTitleController;
  late TextEditingController _damageDescriptionController;
  late TextEditingController _damageImageUrlController;
  late TextEditingController _damagePublicIdController;

  DateTime _serviceDate = DateTime.now();
  DateTime _nextServiceDate = DateTime.now().add(const Duration(days: 90));
  String _status = 'Pending';
  String? _tyrePhotoPath;

  @override
  void initState() {
    super.initState();
    _customerNameController = TextEditingController(
      text: widget.job?.customerName ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.job?.phoneNumber ?? '',
    );
    _fullAddressController = TextEditingController(
      text: widget.job?.address?['fullAddress']?.toString() ?? '',
    );
    _cityController = TextEditingController(
      text: widget.job?.address?['city']?.toString() ?? '',
    );
    _stateController = TextEditingController(
      text: widget.job?.address?['state']?.toString() ?? '',
    );
    _pincodeController = TextEditingController(
      text: widget.job?.address?['pincode']?.toString() ?? '',
    );
    _landmarkController = TextEditingController(
      text: widget.job?.address?['landmark']?.toString() ?? '',
    );
    _vehicleNumberController = TextEditingController(
      text: widget.job?.vehicleNumber ?? '',
    );
    _vehicleTypeController = TextEditingController(
      text: widget.job?.vehicleType ?? '',
    );
    _vehicleBrandController = TextEditingController(
      text: widget.job?.vehicleBrand ?? '',
    );
    _vehicleModelController = TextEditingController(
      text: widget.job?.vehicleModel ?? '',
    );
    _vehicleVariantController = TextEditingController(
      text: widget.job?.vehicleVariant ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.job?.description ?? '',
    );
    _todoController = TextEditingController(text: widget.job?.todo ?? '');
    _mechanicNameController = TextEditingController(
      text: widget.job?.mechanicName ?? '',
    );
    _mechanicProfileController = TextEditingController(
      text: widget.job?.mechanicProfile ?? '',
    );
    _notesController = TextEditingController(text: widget.job?.notes ?? '');
    _labourCostController = TextEditingController(
      text: widget.job?.labourCost?.toString() ?? '',
    );
    _totalPriceController = TextEditingController(
      text: widget.job?.totalPrice?.toString() ?? '',
    );

    // Initialize new controllers
    _registrationNumberController = TextEditingController(
      text: widget.job?.registrationNumber ?? '',
    );
    _vehicleYearController = TextEditingController(
      text: widget.job?.vehicleYear?.toString() ?? '',
    );
    _fuelTypeController = TextEditingController(
      text: widget.job?.fuelType ?? '',
    );
    _transmissionTypeController = TextEditingController(
      text: widget.job?.transmissionType ?? '',
    );
    _kmsDrivenController = TextEditingController(
      text: widget.job?.kmsDriven?.toString() ?? '',
    );
    _kmImageUrlController = TextEditingController(
      text: widget.job?.kmImage?['url']?.toString() ?? '',
    );
    _kmImagePublicIdController = TextEditingController(
      text: widget.job?.kmImage?['public_id']?.toString() ?? '',
    );
    _vehicleColorController = TextEditingController(
      text: widget.job?.vehicleColor ?? '',
    );
    _ownershipDetailsController = TextEditingController(
      text: widget.job?.ownershipDetails ?? '',
    );
    _tyreConditionController = TextEditingController(
      text: widget.job?.tyreCondition ?? '',
    );
    final tyreDetail =
        widget.job?.tyreConditionDetails.isNotEmpty == true &&
            widget.job!.tyreConditionDetails.first is Map
        ? Map<String, dynamic>.from(
            widget.job!.tyreConditionDetails.first as Map,
          )
        : <String, dynamic>{};
    _tyrePositionController = TextEditingController(
      text: tyreDetail['position']?.toString() ?? 'Front Left',
    );
    _tyreBrandController = TextEditingController(
      text: tyreDetail['brand']?.toString() ?? '',
    );
    _tyreSizeController = TextEditingController(
      text: tyreDetail['size']?.toString() ?? '',
    );
    _tyreNotesController = TextEditingController(
      text: tyreDetail['notes']?.toString() ?? '',
    );
    _damageTitleController = TextEditingController();
    _damageDescriptionController = TextEditingController();
    _damageImageUrlController = TextEditingController();
    _damagePublicIdController = TextEditingController();

    if (widget.job != null) {
      _serviceDate = widget.job!.serviceDate;
      _nextServiceDate =
          widget.job!.nextServiceDate ??
          DateTime.now().add(const Duration(days: 90));
      _status = widget.job!.status;
      _partsList.addAll(widget.job!.parts);
      _inspectionPhotos.addAll(
        widget.job!.vehiclePhotos.map(_InspectionPhoto.fromValue),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JobController>().fetchVehicleTypes();
      final vehicleType = _vehicleTypeController.text.trim();
      if (vehicleType.isNotEmpty) {
        _loadInspectionChecklist(vehicleType);
      }
    });
  }

  @override
  void dispose() {
    _speech.cancel();
    _customerNameController.dispose();
    _phoneController.dispose();
    _fullAddressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _landmarkController.dispose();
    _vehicleNumberController.dispose();
    _vehicleTypeController.dispose();
    _vehicleBrandController.dispose();
    _vehicleModelController.dispose();
    _vehicleVariantController.dispose();
    _descriptionController.dispose();
    _todoController.dispose();
    _mechanicNameController.dispose();
    _mechanicProfileController.dispose();
    _notesController.dispose();
    _labourCostController.dispose();
    _totalPriceController.dispose();
    _registrationNumberController.dispose();
    _vehicleYearController.dispose();
    _fuelTypeController.dispose();
    _transmissionTypeController.dispose();
    _kmsDrivenController.dispose();
    _kmImageUrlController.dispose();
    _kmImagePublicIdController.dispose();
    _vehicleColorController.dispose();
    _ownershipDetailsController.dispose();
    _tyreConditionController.dispose();
    _tyrePositionController.dispose();
    _tyreBrandController.dispose();
    _tyreSizeController.dispose();
    _tyreNotesController.dispose();
    _damageTitleController.dispose();
    _damageDescriptionController.dispose();
    _damageImageUrlController.dispose();
    _damagePublicIdController.dispose();

    for (final controller in _inspectionTextControllers.values) {
      controller.dispose();
    }
    for (final controller in _inspectionImageUrlControllers.values) {
      controller.dispose();
    }
    for (final controller in _inspectionDamageDescControllers.values) {
      controller.dispose();
    }
    for (final controller in _inspectionDamageImageControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<bool> _ensureSpeechReady() async {
    if (_isSpeechAvailable) return true;

    final available = await _speech.initialize(
      onStatus: (status) {
        if (!mounted) return;
        if (status == 'done' || status == 'notListening') {
          setState(() {
            _isListening = false;
            _listeningController = null;
          });
        }
      },
      onError: (error) {
        if (!mounted) return;
        setState(() {
          _isListening = false;
          _listeningController = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.trText(
                'Microphone is not available. Please check permission.',
              ),
            ),
          ),
        );
      },
    );

    if (!mounted) return false;
    setState(() => _isSpeechAvailable = available);

    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.trText('Speech typing is not available on this device.'),
          ),
        ),
      );
    }

    return available;
  }

  Future<void> _toggleVoiceTyping(TextEditingController controller) async {
    if (_isListening && identical(_listeningController, controller)) {
      await _speech.stop();
      if (!mounted) return;
      setState(() {
        _isListening = false;
        _listeningController = null;
      });
      return;
    }

    if (_isListening) {
      await _speech.stop();
    }

    final ready = await _ensureSpeechReady();
    if (!ready || !mounted) return;

    _listeningBaseText = controller.text.trimRight();
    setState(() {
      _isListening = true;
      _listeningController = controller;
    });

    await _speech.listen(
      listenOptions: stt.SpeechListenOptions(
        localeId: 'hi_IN',
        partialResults: true,
        listenFor: const Duration(seconds: 45),
        pauseFor: const Duration(seconds: 4),
      ),
      onResult: (result) {
        if (!mounted || !identical(_listeningController, controller)) return;

        final spokenText = result.recognizedWords.trim();
        final separator = _listeningBaseText.isNotEmpty && spokenText.isNotEmpty
            ? ' '
            : '';
        final updatedText = '$_listeningBaseText$separator$spokenText';
        controller.value = controller.value.copyWith(
          text: updatedText,
          selection: TextSelection.collapsed(offset: updatedText.length),
          composing: TextRange.empty,
        );
        setState(() {});
      },
    );
  }

  Widget _buildVoiceInputButton(TextEditingController controller) {
    final isActive =
        _isListening && identical(_listeningController, controller);

    return IconButton(
      tooltip: context.trText(isActive ? 'Stop voice typing' : 'Voice typing'),
      icon: Icon(
        isActive ? Icons.mic : Icons.mic_none_rounded,
        color: isActive ? const Color(0xFFE31E24) : Colors.grey.shade600,
      ),
      onPressed: () => _toggleVoiceTyping(controller),
    );
  }

  Future<void> _captureInspectionPhoto() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1600,
    );

    if (pickedFile == null) return;

    setState(() {
      _inspectionPhotos.add(_InspectionPhoto(path: pickedFile.path));
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.trText('Photo added. Tap on scratch/damage area to mark it.'),
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickVehiclePhotosFromGallery() async {
    final pickedFiles = await _imagePicker.pickMultiImage(
      imageQuality: 80,
      maxWidth: 1600,
    );

    if (pickedFiles.isEmpty) return;

    setState(() {
      _inspectionPhotos.addAll(
        pickedFiles.map((file) => _InspectionPhoto(path: file.path)),
      );
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.trText('${pickedFiles.length} vehicle photos added.'),
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _addInspectionMark(
    _InspectionPhoto photo,
    Offset position,
    Size imageSize,
  ) async {
    final noteController = TextEditingController();
    String selectedType = 'Damage';
    final x = (position.dx / imageSize.width).clamp(0.0, 1.0);
    final y = (position.dy / imageSize.height).clamp(0.0, 1.0);

    final mark = await showModalBottomSheet<_InspectionMark>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.trText('Mark Vehicle Issue'),
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'Damage',
                        label: Text(context.trText('Damage')),
                        icon: Icon(Icons.warning_amber_rounded),
                      ),
                      ButtonSegment(
                        value: 'Scratch',
                        label: Text(context.trText('Scratch')),
                        icon: Icon(Icons.edit),
                      ),
                    ],
                    selected: {selectedType},
                    onSelectionChanged: (value) {
                      setSheetState(() => selectedType = value.first);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: noteController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: context.trText('Note / location'),
                      hintText: context.trText(
                        'Example: front bumper, left door',
                      ),
                      prefixIcon: const Icon(Icons.note_alt_outlined),
                      suffixIcon: _buildVoiceInputButton(noteController),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(context.trText('Cancel')),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(
                              _InspectionMark(
                                type: selectedType,
                                x: x,
                                y: y,
                                note: noteController.text.trim(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE31E24),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(context.trText('Add')),
                        ),
                      ),
                    ],
                  ),
                ],
                ),
              ),
            );
          },
        );
      },
    );

    noteController.dispose();

    if (mark == null) return;
    if (!mounted || !_inspectionPhotos.contains(photo)) return;
    setState(() => photo.marks.add(mark));
  }

  void _removeInspectionPhoto(int index) {
    setState(() => _inspectionPhotos.removeAt(index));
  }

  void _removeInspectionMark(_InspectionPhoto photo, int markIndex) {
    setState(() => photo.marks.removeAt(markIndex));
  }

  Future<void> _loadInspectionChecklist(String vehicleType) async {
    final normalizedVehicleType = vehicleType.trim();
    if (normalizedVehicleType.isEmpty ||
        _sameVehicleType(
          _loadedInspectionVehicleType ?? '',
          normalizedVehicleType,
        )) {
      return;
    }

    setState(() {
      _isInspectionChecklistLoading = true;
      _inspectionChecklistError = null;
      _inspectionChecklistSections = [];
      _inspectionTotalPoints = 0;
      _inspectionAnswers.clear();
      for (final controller in _inspectionTextControllers.values) {
        controller.dispose();
      }
      for (final controller in _inspectionImageUrlControllers.values) {
        controller.dispose();
      }
      for (final controller in _inspectionDamageDescControllers.values) {
        controller.dispose();
      }
      for (final controller in _inspectionDamageImageControllers.values) {
        controller.dispose();
      }
      _inspectionTextControllers.clear();
      _inspectionImageUrlControllers.clear();
      _inspectionDamageDescControllers.clear();
      _inspectionDamageImageControllers.clear();
      _loadedInspectionVehicleType = normalizedVehicleType;
    });

    try {
      final response = await context
          .read<JobController>()
          .getInspectionChecklist(normalizedVehicleType);
      if (!mounted) return;
      final sections = _parseInspectionSections(response);
      setState(() {
        _inspectionChecklistSections = sections;
        _inspectionTotalPoints = _parseInspectionTotalPoints(response);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _inspectionChecklistError = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isInspectionChecklistLoading = false;
        });
      }
    }
  }

  List<_InspectionChecklistSection> _parseInspectionSections(
    Map<String, dynamic>? response,
  ) {
    final data = response?['data'] is Map
        ? Map<String, dynamic>.from(response!['data'] as Map)
        : response ?? <String, dynamic>{};
    final sections = data['sections'] is List
        ? data['sections'] as List
        : <dynamic>[];

    return sections
        .whereType<Map>()
        .map(
          (section) => _InspectionChecklistSection.fromJson(
            Map<String, dynamic>.from(section),
          ),
        )
        .where((section) => section.checkpoints.isNotEmpty)
        .toList();
  }

  int _parseInspectionTotalPoints(Map<String, dynamic>? response) {
    final data = response?['data'] is Map
        ? Map<String, dynamic>.from(response!['data'] as Map)
        : response ?? <String, dynamic>{};
    return _readInt(
      data['totalPoints'] ?? data['totalpoints'] ?? data['points'],
    );
  }

  bool _validateInspectionChecklist() {
    final missingRequired = _inspectionChecklistSections
        .expand((section) => section.checkpoints)
        .where((checkpoint) => checkpoint.required)
        .where((checkpoint) {
          final inputType = checkpoint.inputType.trim().toLowerCase();
          if (inputType == 'textarea' || inputType == 'text') {
            final value = _inspectionTextControllers[checkpoint.id]?.text
                .trim();
            return value == null || value.isEmpty;
          }
          if (inputType == 'image') {
            final value = _inspectionImageUrlControllers[checkpoint.id]?.text
                .trim();
            return value == null || value.isEmpty;
          }
          return false;
        })
        .toList();

    if (missingRequired.isEmpty) return true;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.trText('Please complete required inspection checklist'),
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
    return false;
  }

  List<Map<String, dynamic>> _buildInspectionAnswersPayload() {
    final payload = <Map<String, dynamic>>[];

    for (final entry in _inspectionAnswers.entries) {
      final value = entry.value.trim();
      if (value.isEmpty) continue;
      final checkpointId = entry.key;
      final map = <String, dynamic>{
        'checkpointId': checkpointId,
        'selectedValue': value,
      };

      final isDamage = value.trim().toLowerCase() == 'damage';
      if (isDamage) {
        final desc =
            _inspectionDamageDescControllers[checkpointId]?.text.trim() ?? '';
        if (desc.isNotEmpty) map['description'] = desc;
        final images = _inspectionImages(checkpointId, value);
        if (images.isNotEmpty) map['images'] = images;
      }

      payload.add(map);
    }

    for (final entry in _inspectionTextControllers.entries) {
      final value = entry.value.text.trim();
      if (value.isEmpty) continue;
      payload.add({'checkpointId': entry.key, 'selectedValue': value});
    }

    for (final entry in _inspectionImageUrlControllers.entries) {
      final value = entry.value.text.trim();
      if (value.isEmpty) continue;
      payload.add({'checkpointId': entry.key, 'selectedValue': value});
    }

    return payload;
  }

  String _vehicleTypeApiValue(String value) {
    final normalized = value
        .trim()
        .toLowerCase()
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\s+'), ' ');

    switch (normalized) {
      case 'car':
      case 'four wheeler':
        return 'four_wheeler';
      case 'bike':
      case 'motorcycle':
      case 'scooter':
      case 'two wheeler':
        return 'two_wheeler';
      case 'auto':
      case 'rickshaw':
      case 'three wheeler':
        return 'three_wheeler';
      case 'truck':
      case 'bus':
      case 'heavy vehicle':
        return 'heavy_vehicle';
      default:
        return normalized.replaceAll(' ', '_');
    }
  }

  Map<String, dynamic> _buildInspectionChecklistPayload() {
    final normalizedVehicleType = _vehicleTypeApiValue(
      _vehicleTypeController.text,
    );

    return {
      'vehicleType': normalizedVehicleType,
      'totalPoints': _inspectionTotalPoints,
      'sections': _inspectionChecklistSections
          .map((section) => _inspectionSectionPayload(section))
          .toList(),
    };
  }

  Map<String, dynamic> _inspectionSectionPayload(
    _InspectionChecklistSection section,
  ) {
    return {
      'sectionId': section.id,
      'sectionName': section.name,
      'checkpoints': section.checkpoints
          .map(_inspectionCheckpointPayload)
          .toList(),
    };
  }

  Map<String, dynamic> _inspectionCheckpointPayload(
    _InspectionCheckpoint checkpoint,
  ) {
    final answer = _inspectionAnswerValue(checkpoint);
    return {
      'checkpointId': checkpoint.id,
      'checkpoint': checkpoint.title,
      'answer': answer,
      'description': _inspectionDescription(checkpoint.id, answer),
      'images': <Map<String, dynamic>>[],
    };
  }

  List<Map<String, dynamic>> _buildDetailedInspectionAnswersPayload() {
    final answers = <Map<String, dynamic>>[];
    for (final section in _inspectionChecklistSections) {
      for (final checkpoint in section.checkpoints) {
        final selectedValue = _inspectionAnswerValue(checkpoint);
        if (selectedValue.trim().isEmpty) continue;
        answers.add({
          'sectionId': section.id,
          'sectionName': section.name,
          'checkpointId': checkpoint.id,
          'checkpoint': checkpoint.title,
          'selectedValue': selectedValue,
          'description': _inspectionDescription(checkpoint.id, selectedValue),
          'images': _inspectionImages(checkpoint.id, selectedValue),
        });
      }
    }
    return answers;
  }

  String _inspectionAnswerValue(_InspectionCheckpoint checkpoint) {
    final inputType = checkpoint.inputType.trim().toLowerCase();
    if (inputType == 'textarea' || inputType == 'text') {
      return _inspectionTextControllers[checkpoint.id]?.text.trim() ?? '';
    }
    if (inputType == 'image') {
      return (_inspectionImageUrlControllers[checkpoint.id]?.text.trim() ?? '')
              .isEmpty
          ? ''
          : 'Image';
    }
    final answer = _inspectionAnswers[checkpoint.id]?.trim() ?? '';
    if (answer.isNotEmpty) return answer;
    return checkpoint.options.firstWhere(
      (option) => option.trim().toLowerCase() == 'ok',
      orElse: () => '',
    );
  }

  String _inspectionDescription(int checkpointId, String answer) {
    if (answer.trim().toLowerCase() != 'damage') return '';
    return _inspectionDamageDescControllers[checkpointId]?.text.trim() ?? '';
  }

  List<Map<String, dynamic>> _inspectionImages(
    int checkpointId,
    String answer,
  ) {
    if (answer.trim().toLowerCase() != 'damage') {
      return <Map<String, dynamic>>[];
    }

    final paths = <String>[
      _inspectionDamageImageControllers[checkpointId]?.text.trim() ?? '',
    ]..removeWhere((value) => value.isEmpty);

    return paths
        .asMap()
        .entries
        .map(
          (entry) => {
            'url': entry.value,
            'public_id':
                'inspection_${checkpointId}_${DateTime.now().microsecondsSinceEpoch}_${entry.key}',
          },
        )
        .toList();
  }

  List<String> _inspectionImagePaths(int checkpointId) {
    return <String>[
      _inspectionImageUrlControllers[checkpointId]?.text.trim() ?? '',
      _inspectionDamageImageControllers[checkpointId]?.text.trim() ?? '',
    ]..removeWhere((value) => value.isEmpty);
  }

  List<_InspectionChecklistPhotoPreview> _inspectionChecklistPhotoPreviews() {
    final previews = <_InspectionChecklistPhotoPreview>[];
    for (final section in _inspectionChecklistSections) {
      for (final checkpoint in section.checkpoints) {
        for (final path in _inspectionImagePaths(checkpoint.id)) {
          previews.add(
            _InspectionChecklistPhotoPreview(
              path: path,
              title: checkpoint.title,
              sectionName: section.name,
              checkpointId: checkpoint.id,
            ),
          );
        }
      }
    }
    return previews;
  }

  Future<void> _openTyreConditionPicker({bool capturePhoto = false}) async {
    if (capturePhoto) {
      final pickedTyrePhoto = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1200,
      );
      if (pickedTyrePhoto == null) {
        return;
      }

      setState(() => _tyrePhotoPath = pickedTyrePhoto.path);
    }

    if (!mounted) return;

    String selectedPosition = _tyrePositionController.text.isEmpty
        ? _tyrePositions.first
        : _tyrePositionController.text;
    String selectedCondition = _tyreConditionController.text.isEmpty
        ? _tyreConditions.first
        : _tyreConditionController.text;
    String selectedBrand = _tyreBrandController.text.isEmpty
        ? _tyreBrands.first
        : _tyreBrandController.text;
    String selectedSize = _tyreSizeController.text.isEmpty
        ? _tyreSizes[2]
        : _tyreSizeController.text;
    final notesController = TextEditingController(
      text: _tyreNotesController.text,
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.trText('Tyre Condition'),
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (_tyrePhotoPath != null &&
                        _tyrePhotoPath!.isNotEmpty &&
                        File(_tyrePhotoPath!).existsSync())
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.file(
                              File(_tyrePhotoPath!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    _buildChoiceGroup(
                      title: 'Position',
                      values: _tyrePositions,
                      selectedValue: selectedPosition,
                      onSelected: (value) {
                        setSheetState(() => selectedPosition = value);
                      },
                    ),
                    _buildChoiceGroup(
                      title: 'Condition',
                      values: _tyreConditions,
                      selectedValue: selectedCondition,
                      onSelected: (value) {
                        setSheetState(() => selectedCondition = value);
                      },
                    ),
                    _buildChoiceGroup(
                      title: 'Brand',
                      values: _tyreBrands,
                      selectedValue: selectedBrand,
                      onSelected: (value) {
                        setSheetState(() => selectedBrand = value);
                      },
                    ),
                    _buildChoiceGroup(
                      title: 'Size',
                      values: _tyreSizes,
                      selectedValue: selectedSize,
                      onSelected: (value) {
                        setSheetState(() => selectedSize = value);
                      },
                    ),
                    TextField(
                      controller: notesController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: context.trText('Notes'),
                        hintText: context.trText('Tread looks fine'),
                        prefixIcon: const Icon(Icons.note_alt),
                        suffixIcon: _buildVoiceInputButton(notesController),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(context.trText('Cancel')),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _tyrePositionController.text = selectedPosition;
                                _tyreConditionController.text =
                                    selectedCondition;
                                _tyreBrandController.text = selectedBrand;
                                _tyreSizeController.text = selectedSize;
                                _tyreNotesController.text = notesController.text
                                    .trim();
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE31E24),
                              foregroundColor: Colors.white,
                            ),
                            child: Text(context.trText('Select')),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    notesController.dispose();
  }

  Widget _buildChoiceGroup({
    required String title,
    required List<String> values,
    required String selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.trData(title),
            style: GoogleFonts.lato(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: values.map((value) {
              final selected = value == selectedValue;
              return ChoiceChip(
                label: Text(context.trText(value)),
                selected: selected,
                onSelected: (_) => onSelected(value),
                selectedColor: const Color(0xFFE31E24).withValues(alpha: 0.16),
                labelStyle: GoogleFonts.lato(
                  color: selected ? const Color(0xFFE31E24) : Colors.black87,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTyrePhotoPreview() {
    final photoPath = _tyrePhotoPath;
    if (photoPath == null ||
        photoPath.isEmpty ||
        !File(photoPath).existsSync()) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.file(File(photoPath), fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${_tyrePositionController.text} tyre photo',
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Remove tyre photo',
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => setState(() => _tyrePhotoPath = null),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic>? _buildAddressPayload() {
    final address = <String, dynamic>{
      'fullAddress': _fullAddressController.text.trim(),
      'city': _cityController.text.trim(),
      'state': _stateController.text.trim(),
      'pincode': _pincodeController.text.trim(),
      'landmark': _landmarkController.text.trim(),
    }..removeWhere((key, value) => value == null || value.toString().isEmpty);

    return address.isEmpty ? null : address;
  }

  Map<String, dynamic>? _buildKmImagePayload() {
    if (_kmImageUrlController.text.trim().isEmpty) return null;
    return {
      'url': _kmImageUrlController.text.trim(),
      'public_id': _kmImagePublicIdController.text.trim().isEmpty
          ? 'km_image_${DateTime.now().millisecondsSinceEpoch}'
          : _kmImagePublicIdController.text.trim(),
    };
  }

  List<Map<String, dynamic>> _buildTyreConditionPayload() {
    final condition = _tyreConditionController.text.trim();
    final position = _tyrePositionController.text.trim();
    final brand = _tyreBrandController.text.trim();
    final size = _tyreSizeController.text.trim();
    final notes = _tyreNotesController.text.trim();

    if (condition.isEmpty &&
        position.isEmpty &&
        brand.isEmpty &&
        size.isEmpty &&
        notes.isEmpty) {
      return [];
    }

    return [
      {
        'position': position.isEmpty ? 'General' : position,
        'condition': condition,
        'brand': brand,
        'size': size,
        'notes': notes,
      }..removeWhere((key, value) => value == null || value.toString().isEmpty),
    ];
  }

  List<Map<String, dynamic>> _buildDamagePhotosPayload() {
    final payload = <Map<String, dynamic>>[];

    if (_damageImageUrlController.text.trim().isNotEmpty) {
      payload.add(
        {
          'title': _damageTitleController.text.trim().isEmpty
              ? 'Vehicle Damage'
              : _damageTitleController.text.trim(),
          'description': _damageDescriptionController.text.trim(),
          'images': [
            {
              'url': _damageImageUrlController.text.trim(),
              'public_id': _damagePublicIdController.text.trim().isEmpty
                  ? 'damage_${DateTime.now().millisecondsSinceEpoch}'
                  : _damagePublicIdController.text.trim(),
            },
          ],
        }..removeWhere(
          (key, value) => value == null || value.toString().isEmpty,
        ),
      );
    }

    for (final photo in _inspectionPhotos) {
      if (photo.marks.isEmpty) continue;
      final imageValue = photo.url ?? photo.path;
      if (imageValue.trim().isEmpty) continue;

      for (final mark in photo.marks) {
        payload.add({
          'title': mark.type,
          'description': mark.note.isEmpty
              ? 'Marked on vehicle photo'
              : mark.note,
          'images': [
            {
              if (imageValue.startsWith('http'))
                'url': imageValue
              else
                'localPath': imageValue,
              'public_id':
                  'damage_${DateTime.now().millisecondsSinceEpoch}_${payload.length}',
            },
          ],
          'mark': mark.toJson(),
        });
      }
    }

    return payload;
  }

  List<Map<String, dynamic>> _buildVehiclePhotosPayload() {
    final photos = _inspectionPhotos.asMap().entries.map((entry) {
      final photo = entry.value.toJson();
      photo['type'] = 'vehicle_photo';
      photo['public_id'] =
          'vehicle_photo_${DateTime.now().microsecondsSinceEpoch}_${entry.key}';
      return photo;
    }).toList();
    final tyrePhotoPath = _tyrePhotoPath?.trim() ?? '';
    if (tyrePhotoPath.isNotEmpty) {
      photos.add({
        'localPath': tyrePhotoPath,
        'type': 'tyre_photo',
        'public_id': 'tyre_photo_${DateTime.now().microsecondsSinceEpoch}',
        'marks': <Map<String, dynamic>>[],
      });
    }
    return photos;
  }

  Future<String?> _resolveGarageName() async {
    final existingName = widget.job?.garageName?.trim();
    if (existingName != null && existingName.isNotEmpty) return existingName;

    try {
      final profile = await GarageRepository().getGarageProfile();
      final businessName = profile.data.businessName.trim();
      if (businessName.isNotEmpty) return businessName;
      final businessNameAlt = (profile.data.business_name ?? '').trim();
      if (businessNameAlt.isNotEmpty) return businessNameAlt;
    } catch (_) {
      // Garage name is optional for saving the job card.
    }

    return null;
  }

  Future<void> _saveJob() async {
    if (_formKey.currentState!.validate()) {
      if (!_validateInspectionChecklist()) return;

      final totalCost = _partsList.fold(0, (sum, part) => sum + part.cost);
      final isEditMode = widget.job != null;
      final jobId = widget.job?.id ?? '';
      final garageName = await _resolveGarageName();

      final job = Job(
        id: jobId,
        jobCardId:
            widget.job?.jobCardId ??
            'JOB${DateTime.now().millisecondsSinceEpoch}',
        customerName: _customerNameController.text,
        phoneNumber: _phoneController.text,
        garageName: garageName,
        todo: _todoController.text.trim().isEmpty
            ? null
            : _todoController.text.trim(),
        address: _buildAddressPayload(),
        vehicleNumber: _vehicleNumberController.text,
        vehicleType: _vehicleTypeController.text.trim(),
        vehicleBrand: _vehicleBrandController.text.isNotEmpty
            ? _vehicleBrandController.text
            : null,
        vehicleModel: _vehicleModelController.text,
        vehicleVariant: _vehicleVariantController.text.isNotEmpty
            ? _vehicleVariantController.text
            : null,
        registrationNumber: _registrationNumberController.text.isNotEmpty
            ? _registrationNumberController.text
            : null,
        vehicleYear: _vehicleYearController.text.isNotEmpty
            ? int.tryParse(_vehicleYearController.text)
            : null,
        fuelType: _fuelTypeController.text.isNotEmpty
            ? _fuelTypeController.text
            : null,
        transmissionType: _transmissionTypeController.text.isNotEmpty
            ? _transmissionTypeController.text
            : null,
        kmsDriven: _kmsDrivenController.text.isNotEmpty
            ? int.tryParse(_kmsDrivenController.text)
            : null,
        kmImage: _buildKmImagePayload(),
        vehicleColor: _vehicleColorController.text.isNotEmpty
            ? _vehicleColorController.text
            : null,
        ownershipDetails: _ownershipDetailsController.text.isNotEmpty
            ? _ownershipDetailsController.text
            : null,
        tyreCondition: _tyreConditionController.text.isNotEmpty
            ? _tyreConditionController.text
            : null,
        tyreConditionDetails: _buildTyreConditionPayload(),
        damagePhotosWithNotes: _buildDamagePhotosPayload(),
        serviceDate: _serviceDate,
        nextServiceDate: _nextServiceDate,
        description: _descriptionController.text,
        mechanicName: _mechanicNameController.text,
        mechanicProfile: _mechanicProfileController.text,
        vehiclePhotos: _buildVehiclePhotosPayload(),
        vehicleVideo: widget.job?.vehicleVideo ?? '',
        parts: _partsList,
        totalPartsCost: totalCost,
        totalPrice: _totalPriceController.text.isNotEmpty
            ? int.tryParse(_totalPriceController.text)
            : totalCost,
        labourCost: _labourCostController.text.isNotEmpty
            ? int.tryParse(_labourCostController.text)
            : null,
        status: _status,
        notes: _notesController.text,
        createdBy: widget.job?.createdBy ?? '',
        createdAt: widget.job?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        v: widget.job?.v ?? 0,
      );

      final jobController = context.read<JobController>();
      final inspectionChecklistPayload = _buildInspectionChecklistPayload();
      final detailedInspectionAnswers =
          _buildDetailedInspectionAnswersPayload();
      if (!isEditMode) {
        print('CREATE JOB CHECKLIST PAYLOAD:');
        print(
          const JsonEncoder.withIndent('  ').convert({
            'inspectionChecklist': inspectionChecklistPayload,
            'inspectionAnswers': detailedInspectionAnswers,
          }),
        );
      }
      bool success;
      if (!isEditMode) {
        success = await jobController.createJob(
          job,
          inspectionChecklist: inspectionChecklistPayload,
          inspectionAnswers: detailedInspectionAnswers,
        );
      } else {
        success = await jobController.updateJob(jobId, job);
      }

      if (!mounted) return;
      if (success) {
        final inspectionAnswers = _buildInspectionAnswersPayload();
        final savedJobCardId = isEditMode
            ? job.jobCardId
            : jobController.lastCreatedJobCardId ?? job.jobCardId;
        if (!isEditMode && savedJobCardId.isNotEmpty) {
          await _createInvoiceForJob(job, savedJobCardId);
        }
        if (isEditMode &&
            inspectionAnswers.isNotEmpty &&
            savedJobCardId.isNotEmpty) {
          try {
            await jobController.saveInspectionResult(
              jobCardId: savedJobCardId,
              vehicleType: job.vehicleType,
              inspectionAnswers: inspectionAnswers,
            );
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.trData(e.toString())),
                  backgroundColor: Colors.orange.shade700,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.trText(
                      widget.job == null
                          ? 'Job created successfully!'
                          : 'Job updated successfully!',
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.trData(
                      jobController.errorMessage ??
                          (widget.job == null
                              ? 'Failed to create job'
                              : 'Failed to update job'),
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Future<void> _createInvoiceForJob(Job job, String jobCardId) async {
    try {
      final payload = _buildInvoicePayload(job, jobCardId);
      print('AUTO CREATE INVOICE PAYLOAD:');
      print(const JsonEncoder.withIndent('  ').convert(payload));
      final response = await InvoiceRepository().createInvoicePayload(payload);
      print('AUTO CREATE INVOICE RESPONSE:');
      print(const JsonEncoder.withIndent('  ').convert(response));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.trData('Invoice create failed: $e')),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Map<String, dynamic> _buildInvoicePayload(Job job, String jobCardId) {
    final address = job.address ?? <String, dynamic>{};
    final fullAddress =
        [
              address['fullAddress'],
              address['city'],
              address['state'],
              address['pincode'],
            ]
            .where(
              (value) => value != null && value.toString().trim().isNotEmpty,
            )
            .join(', ');
    final items = job.parts.isEmpty
        ? [
            {
              'itemName': job.description.trim().isEmpty
                  ? 'Garage Service'
                  : job.description.trim(),
              'description': job.description.trim(),
              'count': 1,
              'quantity': 1,
              'unit': 'Job',
              'pricePerUnit': job.totalPrice ?? job.totalPartsCost,
            },
          ]
        : job.parts
              .map(
                (part) => {
                  'itemName': part.partName,
                  'description': part.partName,
                  'count': part.quantity ?? 1,
                  'quantity': part.quantity ?? 1,
                  'unit': 'Pcs',
                  'pricePerUnit': part.cost,
                },
              )
              .toList();
    final total = items.fold<num>(
      0,
      (sum, item) =>
          sum +
          (_invoiceNum(item['quantity']) * _invoiceNum(item['pricePerUnit'])),
    );

    return {
      'customerId': null,
      'jobCardId': jobCardId,
      'invoiceDate': _dateOnly(DateTime.now()),
      'placeOfSupply': '07-Delhi',
      'customerDetails': {
        'customerType': 'Manual',
        'name': job.customerName,
        'phone': job.phoneNumber,
        'email': '',
        'address': fullAddress,
        'gstin': '',
        'vehicleNumber': job.vehicleNumber,
        'vehicleName': job.vehicleModel,
        'vehicleModel': job.vehicleYear?.toString() ?? job.vehicleModel,
        'chassisNumber': '',
        'engineNumber': '',
        'odometerReading': job.kmsDriven?.toString() ?? '',
        'notes': job.notes,
      },
      'billTo': {
        'name': job.customerName,
        'address': fullAddress,
        'phone': job.phoneNumber,
        'email': '',
        'gstin': '',
      },
      'company': {
        'name': 'HORNVIN ENTERPRISES',
        'address': 'Amar Colony, Lajpat Nagar IV New Delhi',
        'phone': '9625910869',
        'email': 'support.hornvin@gmail.com',
        'gstin': '07BHQPJ1731F1ZF',
        'state': '07-Delhi',
      },
      'items': items,
      'payment': {
        'paymentMode': 'Cash',
        'discount': 0,
        'tax': 0,
        'received': 0,
        'paymentStatus': total > 0 ? 'Pending' : 'Paid',
      },
      'termsAndConditions': 'Thank you for doing business with us.',
    };
  }

  String _dateOnly(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  num _invoiceNum(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '') ?? 0;
  }

  Future<void> _addPart() async {
    final partNameController = TextEditingController();
    final quantityController = TextEditingController();
    final costController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.trText('Add Part'),
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: partNameController,
                decoration: InputDecoration(
                  labelText: context.trText('Part Name'),
                  prefixIcon: Icon(Icons.build, color: const Color(0xFFE31E24)),
                  suffixIcon: _buildVoiceInputButton(partNameController),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: costController,
                decoration: InputDecoration(
                  labelText: context.trText('Cost (₹)'),
                  prefixIcon: Icon(
                    Icons.currency_rupee,
                    color: const Color(0xFFE31E24),
                  ),
                  suffixIcon: _buildVoiceInputButton(costController),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(
                  labelText: context.trText('Quantity'),
                  prefixIcon: Icon(
                    Icons.numbers,
                    color: const Color(0xFFE31E24),
                  ),
                  suffixIcon: _buildVoiceInputButton(quantityController),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        context.trText('Cancel'),
                        style: GoogleFonts.lato(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (partNameController.text.isNotEmpty &&
                            costController.text.isNotEmpty) {
                          setState(() {
                            _partsList.add(
                              Part(
                                partName: partNameController.text,
                                quantity: quantityController.text.isEmpty
                                    ? null
                                    : double.tryParse(quantityController.text),
                                cost: int.parse(costController.text),
                              ),
                            );
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE31E24),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        context.trText('Add'),
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
  }

  @override
  Widget build(BuildContext context) {
    final jobController = context.watch<JobController>();
    final isSaving = jobController.isLoading;
    final partsTotal = _partsList.fold(0, (sum, part) => sum + part.cost);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.trText(
                context.trData(
                  widget.job == null ? 'Create Job Card' : 'Edit Job Card',
                ),
              ),
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
              ),
            ),
            Text(
              context.trText(
                widget.job == null
                    ? 'Add customer, vehicle and service details'
                    : 'Update service details',
              ),
              style: GoogleFonts.lato(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
        iconTheme: const IconThemeData(color: Color(0xFF111827)),
        actionsIconTheme: const IconThemeData(color: Color(0xFF111827)),
        surfaceTintColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: _buildSaveBar(isSaving),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
          child: Column(
            children: [
              _buildJobSummaryCard(partsTotal),
              const SizedBox(height: 16),
              _buildSection('Todo', Icons.task_alt, [
                _buildTextField(
                  _todoController,
                  'Todo',
                  Icons.task_alt,
                  false,
                  maxLines: 2,
                ),
              ]),
              const SizedBox(height: 16),
              _buildSection('Customer Information', Icons.person, [
                _buildTextField(
                  _customerNameController,
                  'Customer Name',
                  Icons.person,
                  true,
                ),
                _buildTextField(
                  _phoneController,
                  'Phone Number',
                  Icons.phone,
                  true,
                ),
              ]),
              const SizedBox(height: 16),
              _buildSection('Customer Address', Icons.location_on, [
                _buildTextField(
                  _fullAddressController,
                  'Address',
                  Icons.home,
                  false,
                  maxLines: 2,
                ),
                _buildTextField(
                  _cityController,
                  'City',
                  Icons.location_city,
                  false,
                ),
                _buildTextField(
                  _pincodeController,
                  'Pincode',
                  Icons.pin_drop,
                  false,
                  keyboardType: TextInputType.number,
                ),
              ]),
              const SizedBox(height: 16),
              _buildSection('Vehicle Details', Icons.directions_car, [
                _buildTextField(
                  _vehicleNumberController,
                  'Vehicle Number',
                  Icons.directions_car,
                  true,
                ),
                _buildVehicleTypeDropdown(),
                _buildTextField(
                  _vehicleBrandController,
                  'Vehicle Brand',
                  Icons.business,
                  false,
                ),
                _buildTextField(
                  _vehicleModelController,
                  'Vehicle Model',
                  Icons.model_training,
                  true,
                ),
                _buildTextField(
                  _vehicleVariantController,
                  'Vehicle Variant',
                  Icons.tune,
                  false,
                ),
                _buildTextField(
                  _vehicleYearController,
                  'Vehicle Year',
                  Icons.date_range,
                  false,
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  _fuelTypeController,
                  'Fuel Type',
                  Icons.local_gas_station,
                  false,
                ),
                _buildTextField(
                  _transmissionTypeController,
                  'Transmission Type',
                  Icons.settings,
                  false,
                ),
                _buildTextField(
                  _kmsDrivenController,
                  'KMs Driven',
                  Icons.speed,
                  false,
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  _vehicleColorController,
                  'Vehicle Color',
                  Icons.color_lens,
                  false,
                ),
                _buildTextField(
                  _ownershipDetailsController,
                  'Ownership Details',
                  Icons.description,
                  false,
                ),
                ElevatedButton.icon(
                  onPressed: () => _openTyreConditionPicker(capturePhoto: true),
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: Text(
                    context.trText('Click Tyre Photo / Select Condition'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  _tyrePositionController,
                  'Tyre Position',
                  Icons.adjust,
                  false,
                ),
                _buildTextField(
                  _tyreConditionController,
                  'Tyre Condition',
                  Icons.circle,
                  false,
                ),
                _buildTextField(
                  _tyreBrandController,
                  'Tyre Brand',
                  Icons.branding_watermark,
                  false,
                ),
                _buildTextField(
                  _tyreSizeController,
                  'Tyre Size',
                  Icons.straighten,
                  false,
                ),
                _buildTextField(
                  _tyreNotesController,
                  'Tyre Notes',
                  Icons.note_alt,
                  false,
                  maxLines: 2,
                ),
              ]),
              const SizedBox(height: 16),
              _buildSection('Inspection Checklist', Icons.fact_check, [
                _buildInspectionChecklistSection(),
              ]),
              const SizedBox(height: 16),
              _buildSection('Service Information', Icons.calendar_today, [
                _buildDatePicker('Service Date', _serviceDate, (date) {
                  setState(() => _serviceDate = date);
                }),
                _buildDatePicker('Next Service Date', _nextServiceDate, (date) {
                  setState(() => _nextServiceDate = date);
                }),
                _buildTextField(
                  _descriptionController,
                  'Description',
                  Icons.description,
                  true,
                  maxLines: 3,
                ),
                _buildTextField(
                  _totalPriceController,
                  'Total Price',
                  Icons.payments,
                  false,
                  keyboardType: TextInputType.number,
                ),
              ]),
              const SizedBox(height: 16),
              _buildSection('Mechanic Details', Icons.engineering, [
                _buildTextField(
                  _mechanicNameController,
                  'Mechanic Name',
                  Icons.engineering,
                  true,
                ),
                _buildTextField(
                  _mechanicProfileController,
                  'Mechanic Profile',
                  Icons.badge,
                  false,
                ),
              ]),
              const SizedBox(height: 16),
              _buildSection('Parts Used', Icons.build, [
                ..._partsList.asMap().entries.map(
                  (entry) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.trData(entry.value.partName),
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (entry.value.quantity != null)
                                Text(
                                  '${context.trText('Qty')}: ${entry.value.quantity}',
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              Text(
                                '₹${entry.value.cost}',
                                style: GoogleFonts.lato(
                                  color: const Color(0xFFE31E24),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _partsList.removeAt(entry.key);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _addPart,
                  icon: const Icon(Icons.add),
                  label: Text(context.trText('Add Part')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE31E24).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.trText('Total Cost:'),
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '₹${_partsList.fold(0, (sum, part) => sum + part.cost)}',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: const Color(0xFFE31E24),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              _buildSection('Additional Information', Icons.info, [
                _buildDropdown(),
                _buildTextField(
                  _notesController,
                  'Notes',
                  Icons.note,
                  false,
                  maxLines: 3,
                ),
              ]),
              const SizedBox(height: 16),
              _buildSection('Vehicle Photos', Icons.photo_camera, [
                _buildTyrePhotoPreview(),
                _buildInspectionChecklistPhotosSection(),
                _buildInspectionPhotosSection(),
                _buildTextField(
                  _damageDescriptionController,
                  'Damage Description',
                  Icons.description,
                  false,
                  maxLines: 2,
                ),
              ]),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveBar(bool isSaving) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isSaving ? null : () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF374151),
                side: BorderSide(color: Colors.grey.shade300),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                context.trText('Cancel'),
                style: GoogleFonts.lato(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: isSaving ? null : _saveJob,
              icon: isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_circle_outline, size: 20),
              label: Text(
                context.trText(isSaving ? 'Saving...' : 'Save Job Card'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE31E24),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(
                  0xFFE31E24,
                ).withValues(alpha: 0.65),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: GoogleFonts.lato(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobSummaryCard(int partsTotal) {
    final vehicle = _vehicleNumberController.text.trim().isEmpty
        ? context.trText('New vehicle')
        : _vehicleNumberController.text.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF111827), Color(0xFF1A237E)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withValues(alpha: 0.22),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.assignment_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.trData(vehicle),
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      context.trText(_status),
                      style: GoogleFonts.lato(
                        color: Colors.white.withValues(alpha: 0.74),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSummaryMetric('Parts', _partsList.length.toString()),
              const SizedBox(width: 10),
              _buildSummaryMetric('Parts Total', 'Rs $partsTotal'),
              const SizedBox(width: 10),
              _buildSummaryMetric(
                'Service',
                '${_serviceDate.day}/${_serviceDate.month}/${_serviceDate.year}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryMetric(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.trText(label),
              style: GoogleFonts.lato(
                color: Colors.white.withValues(alpha: 0.68),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              context.trData(value),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInspectionChecklistSection() {
    final vehicleType = _vehicleTypeController.text.trim();

    if (vehicleType.isEmpty) {
      return _buildChecklistMessage(
        icon: Icons.directions_car_outlined,
        message: 'Select vehicle type to load inspection checklist',
      );
    }

    if (_isInspectionChecklistLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE31E24)),
            ),
            const SizedBox(height: 12),
            Text(
              context.trText('Loading inspection checklist...'),
              style: GoogleFonts.lato(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    if (_inspectionChecklistError != null) {
      return Column(
        children: [
          _buildChecklistMessage(
            icon: Icons.error_outline,
            message: 'Unable to load inspection checklist',
            color: Colors.red,
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => _loadInspectionChecklist(vehicleType),
            icon: const Icon(Icons.refresh),
            label: Text(context.trText('Retry')),
          ),
        ],
      );
    }

    if (_inspectionChecklistSections.isEmpty) {
      return _buildChecklistMessage(
        icon: Icons.fact_check_outlined,
        message: 'No inspection checklist available for this vehicle type',
      );
    }

    return Column(
      children: _inspectionChecklistSections
          .map(_buildInspectionChecklistSectionCard)
          .toList(),
    );
  }

  Widget _buildChecklistMessage({
    required IconData icon,
    required String message,
    Color color = Colors.grey,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.trText(message),
              style: GoogleFonts.lato(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInspectionChecklistSectionCard(
    _InspectionChecklistSection section,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ExpansionTile(
        initiallyExpanded: section.id == 1,
        tilePadding: const EdgeInsets.symmetric(horizontal: 14),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        title: Text(
          context.trText(section.name),
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A237E),
          ),
        ),
        subtitle: Text(
          '${section.checkpoints.length} ${context.trText('checkpoints')}',
          style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade600),
        ),
        children: section.checkpoints.map(_buildInspectionCheckpoint).toList(),
      ),
    );
  }

  Widget _buildInspectionCheckpoint(_InspectionCheckpoint checkpoint) {
    final inputType = checkpoint.inputType.trim().toLowerCase();
    final selectedValue = _inspectionAnswers[checkpoint.id];
    final isDamageSelected =
        (selectedValue ?? '').trim().toLowerCase() == 'damage';
    final TextEditingController? textController =
        (inputType == 'textarea' || inputType == 'text')
        ? _inspectionTextControllers.putIfAbsent(
            checkpoint.id,
            () => TextEditingController(),
          )
        : null;
    final TextEditingController? imageUrlController = inputType == 'image'
        ? _inspectionImageUrlControllers.putIfAbsent(
            checkpoint.id,
            () => TextEditingController(),
          )
        : null;
    final TextEditingController? damageDescController =
        (inputType != 'textarea' && inputType != 'text' && inputType != 'image')
        ? _inspectionDamageDescControllers.putIfAbsent(
            checkpoint.id,
            () => TextEditingController(),
          )
        : null;
    final TextEditingController? damageImageController =
        (inputType != 'textarea' && inputType != 'text' && inputType != 'image')
        ? _inspectionDamageImageControllers.putIfAbsent(
            checkpoint.id,
            () => TextEditingController(),
          )
        : null;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:
              checkpoint.required &&
                  ((inputType == 'textarea' || inputType == 'text')
                      ? (textController?.text.trim().isEmpty ?? true)
                      : inputType == 'image'
                      ? (imageUrlController?.text.trim().isEmpty ?? true)
                      : (selectedValue == null || selectedValue.trim().isEmpty))
              ? Colors.orange.shade200
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  context.trText(checkpoint.title),
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (checkpoint.required)
                Text(
                  context.trText('Required'),
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    color: const Color(0xFFE31E24),
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (inputType == 'textarea' || inputType == 'text')
            TextFormField(
              controller: textController,
              maxLines: inputType == 'textarea' ? 3 : 1,
              decoration: InputDecoration(
                hintText: context.trText('Enter details'),
                suffixIcon: textController == null
                    ? null
                    : _buildVoiceInputButton(textController),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              onChanged: (_) => setState(() {}),
            )
          else if (inputType == 'image')
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final picked = await _imagePicker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                      maxWidth: 1600,
                    );
                    if (picked == null) return;
                    setState(() {
                      imageUrlController?.text = picked.path;
                    });
                  },
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: Text(context.trText('Capture Image')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 42),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if ((imageUrlController?.text.trim().isNotEmpty ?? false)) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Builder(
                        builder: (context) {
                          final value = imageUrlController?.text.trim() ?? '';
                          if (value.startsWith('http')) {
                            return Image.network(value, fit: BoxFit.cover);
                          }
                          final file = File(value);
                          if (file.existsSync()) {
                            return Image.file(file, fit: BoxFit.cover);
                          }
                          return Container(
                            color: Colors.grey.shade100,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 36,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: checkpoint.options.map((option) {
                    final isSelected = selectedValue == option;
                    return ChoiceChip(
                      label: Text(context.trText(option)),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _inspectionAnswers[checkpoint.id] = option;
                        });
                      },
                      selectedColor: const Color(
                        0xFFE31E24,
                      ).withValues(alpha: 0.16),
                      labelStyle: GoogleFonts.lato(
                        color: isSelected
                            ? const Color(0xFFE31E24)
                            : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    );
                  }).toList(),
                ),
                if (isDamageSelected) ...[
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: damageDescController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: context.trText('Damage Description'),
                      suffixIcon: damageDescController == null
                          ? null
                          : _buildVoiceInputButton(damageDescController),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final picked = await _imagePicker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 80,
                        maxWidth: 1600,
                      );
                      if (picked == null) return;
                      setState(() {
                        damageImageController?.text = picked.path;
                      });
                    },
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: Text(context.trText('Capture Damage Image')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if ((damageImageController?.text.trim().isNotEmpty ??
                      false)) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Builder(
                          builder: (context) {
                            final value =
                                damageImageController?.text.trim() ?? '';
                            if (value.startsWith('http')) {
                              return Image.network(value, fit: BoxFit.cover);
                            }
                            final file = File(value);
                            if (file.existsSync()) {
                              return Image.file(file, fit: BoxFit.cover);
                            }
                            return Container(
                              color: Colors.grey.shade100,
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  size: 36,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInspectionChecklistPhotosSection() {
    final previews = _inspectionChecklistPhotoPreviews();
    if (previews.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.trText('Inspection Checklist Photos'),
          style: GoogleFonts.lato(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A237E),
          ),
        ),
        const SizedBox(height: 10),
        ...previews.map(_buildInspectionChecklistPhotoCard),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildInspectionChecklistPhotoCard(
    _InspectionChecklistPhotoPreview preview,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _buildPreviewImage(preview.path),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.trText(preview.title),
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  context.trText(preview.sectionName),
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(path, fit: BoxFit.cover);
    }
    final file = File(path);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.cover);
    }
    return Container(
      color: Colors.grey.shade100,
      child: const Center(child: Icon(Icons.broken_image_outlined, size: 42)),
    );
  }

  Widget _buildInspectionPhotosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _captureInspectionPhoto,
                icon: const Icon(Icons.photo_camera_outlined),
                label: Text(context.trText('Camera')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickVehiclePhotosFromGallery,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(context.trText('Gallery')),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                  side: BorderSide(color: AppColors.secondary),
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          context.trText(
            'Multiple vehicle photos add karein. Photo par scratch ya damage wali jagah tap karke mark bhi kar sakte hain.',
          ),
          style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade700),
        ),
        if (_inspectionPhotos.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            context.trText('${_inspectionPhotos.length} vehicle photos added'),
            style: GoogleFonts.lato(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
          ),
        ],
        const SizedBox(height: 12),
        if (_inspectionPhotos.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.add_a_photo_outlined,
                  color: Colors.grey.shade500,
                  size: 36,
                ),
                const SizedBox(height: 8),
                Text(
                  context.trText('No vehicle photo added'),
                  style: GoogleFonts.lato(color: Colors.grey.shade600),
                ),
              ],
            ),
          )
        else
          ..._inspectionPhotos.asMap().entries.map((entry) {
            return _buildInspectionPhotoCard(entry.key, entry.value);
          }),
      ],
    );
  }

  Widget _buildInspectionPhotoCard(int index, _InspectionPhoto photo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final imageSize = Size(
                  constraints.maxWidth,
                  constraints.maxWidth * 0.62,
                );

                return GestureDetector(
                  onTapUp: (details) {
                    _addInspectionMark(photo, details.localPosition, imageSize);
                  },
                  child: SizedBox(
                    width: imageSize.width,
                    height: imageSize.height,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildInspectionImage(photo),
                        ...photo.marks.map(
                          (mark) => Positioned(
                            left: (mark.x * imageSize.width) - 14,
                            top: (mark.y * imageSize.height) - 14,
                            child: _buildInspectionMarker(mark),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Material(
                            color: Colors.black54,
                            shape: const CircleBorder(),
                            child: IconButton(
                              tooltip: context.trText('Remove photo'),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: () => _removeInspectionPhoto(index),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (photo.marks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: photo.marks.asMap().entries.map((entry) {
                  final mark = entry.value;
                  return InputChip(
                    avatar: Icon(
                      mark.type == 'Scratch'
                          ? Icons.edit
                          : Icons.warning_amber_rounded,
                      size: 18,
                      color: mark.type == 'Scratch'
                          ? Colors.orange.shade700
                          : Colors.red.shade700,
                    ),
                    label: Text(
                      mark.note.isEmpty
                          ? context.trText(mark.type)
                          : '${context.trText(mark.type)}: ${mark.note}',
                      style: GoogleFonts.lato(fontSize: 12),
                    ),
                    onDeleted: () => _removeInspectionMark(photo, entry.key),
                  );
                }).toList(),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                context.trText('Tap image to mark damage or scratch'),
                style: GoogleFonts.lato(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInspectionImage(_InspectionPhoto photo) {
    if (photo.isLocal && File(photo.path).existsSync()) {
      return Image.file(File(photo.path), fit: BoxFit.cover);
    }

    final imageUrl = photo.url ?? photo.path;
    if (imageUrl.startsWith('http')) {
      return Image.network(imageUrl, fit: BoxFit.cover);
    }

    return Container(
      color: Colors.grey.shade200,
      child: const Center(child: Icon(Icons.broken_image_outlined, size: 42)),
    );
  }

  Widget _buildInspectionMarker(_InspectionMark mark) {
    final color = mark.type == 'Scratch'
        ? Colors.orange.shade700
        : Colors.red.shade700;

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        mark.type == 'Scratch' ? Icons.edit : Icons.warning_amber_rounded,
        color: Colors.white,
        size: 16,
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE31E24).withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: const Color(0xFFE31E24), size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  context.trText(title),
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    bool required, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: context.trText(label),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          prefixIcon: Icon(icon, color: const Color(0xFFE31E24), size: 20),
          suffixIcon: _buildVoiceInputButton(controller),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE31E24), width: 1.4),
          ),
          labelStyle: GoogleFonts.lato(color: Colors.grey.shade700),
        ),
        validator: required
            ? (value) => value!.isEmpty
                  ? '${context.trText('Please enter')} ${context.trText(label)}'
                  : null
            : null,
      ),
    );
  }

  Widget _buildVehicleTypeDropdown() {
    return Consumer<JobController>(
      builder: (context, controller, child) {
        final options = _vehicleTypeOptions(controller.vehicleTypes);
        final currentValue = _vehicleTypeController.text.trim();
        final selectedValue =
            options.any((option) => _sameVehicleType(option, currentValue))
            ? options.firstWhere(
                (option) => _sameVehicleType(option, currentValue),
              )
            : null;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DropdownButtonFormField<String>(
            initialValue: selectedValue,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: context.trText('Vehicle Type'),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              prefixIcon: const Icon(
                Icons.category,
                color: Color(0xFFE31E24),
                size: 20,
              ),
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
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFE31E24),
                  width: 1.4,
                ),
              ),
              labelStyle: GoogleFonts.lato(color: Colors.grey.shade700),
            ),
            hint: Text(
              context.trText('Select Vehicle Type'),
              style: GoogleFonts.lato(color: Colors.grey.shade500),
            ),
            items: options
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
            onChanged: (value) {
              final selected = value ?? '';
              _vehicleTypeController.text = selected;
              _loadInspectionChecklist(selected);
            },
            validator: (value) {
              final selected = value?.trim().isNotEmpty == true
                  ? value!.trim()
                  : _vehicleTypeController.text.trim();
              return selected.isEmpty
                  ? context.trText('Please select vehicle type')
                  : null;
            },
          ),
        );
      },
    );
  }

  List<String> _vehicleTypeOptions(List<String> controllerTypes) {
    final values = <String>[
      'Two Wheeler',
      'Three Wheeler',
      'Four Wheeler',
      'Heavy Vehicle',
      'Other',
      ...controllerTypes.where(
        (type) => type.trim().toLowerCase() != 'all vehicles',
      ),
    ];
    final seen = <String>{};
    return values.where((type) {
      final text = type.trim();
      if (text.isEmpty || text.toLowerCase() == 'null') return false;
      final key = _vehicleTypeKey(text);
      if (seen.contains(key)) return false;
      seen.add(key);
      return true;
    }).toList();
  }

  bool _sameVehicleType(String first, String second) {
    return _vehicleTypeKey(first) == _vehicleTypeKey(second);
  }

  String _vehicleTypeKey(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  Widget _buildDatePicker(
    String label,
    DateTime date,
    Function(DateTime) onDateSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2000),
            lastDate: DateTime(2030),
            builder: (context, child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xFFE31E24),
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) {
            onDateSelected(picked);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: context.trText(label),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            prefixIcon: Icon(
              Icons.calendar_today,
              color: const Color(0xFFE31E24),
              size: 20,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE31E24),
                width: 1.4,
              ),
            ),
          ),
          child: Text(
            '${date.day}/${date.month}/${date.year}',
            style: GoogleFonts.lato(),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: _status,
        decoration: InputDecoration(
          labelText: context.trText('Status'),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          prefixIcon: Icon(Icons.timeline, color: const Color(0xFFE31E24)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE31E24), width: 1.4),
          ),
        ),
        items: ['Pending', 'In Progress', 'Completed', 'Cancelled'].map((
          status,
        ) {
          return DropdownMenuItem(
            value: status,
            child: Text(context.trText(status)),
          );
        }).toList(),
        onChanged: (value) {
          setState(() => _status = value!);
        },
      ),
    );
  }
}
