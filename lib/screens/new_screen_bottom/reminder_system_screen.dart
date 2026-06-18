import 'package:hornvin/localization/app_localizations.dart';
// screens/reminder_system_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';

class ReminderSystemScreen extends StatefulWidget {
  const ReminderSystemScreen({super.key});

  @override
  State<ReminderSystemScreen> createState() => _ReminderSystemScreenState();
}

class _ReminderSystemScreenState extends State<ReminderSystemScreen> {
  List<Reminder> reminders = [
    Reminder(
      customerName: 'Rajesh Kumar',
      customerPhone: '9876543210',
      vehicleNumber: 'MH01AB1234',
      type: 'Service',
      date: '2026-05-15',
      status: 'Pending',
    ),
    Reminder(
      customerName: 'Priya Singh',
      customerPhone: '9876543211',
      vehicleNumber: 'MH02CD5678',
      type: 'Payment',
      date: '2026-04-25',
      status: 'Pending',
    ),
    Reminder(
      customerName: 'Amit Sharma',
      customerPhone: '9876543212',
      vehicleNumber: 'MH03EF9012',
      type: 'Service',
      date: '2026-04-20',
      status: 'Completed',
    ),
    Reminder(
      customerName: 'Sneha Patil',
      customerPhone: '9876543213',
      vehicleNumber: 'MH04GH3456',
      type: 'Insurance',
      date: '2026-05-10',
      status: 'Pending',
    ),
  ];

  String _selectedFilter = 'All';
  List<String> filters = ['All', 'Service', 'Payment', 'Insurance'];

  @override
  Widget build(BuildContext context) {
    List<Reminder> filteredReminders = reminders.where((r) {
      return _selectedFilter == 'All' || r.type == _selectedFilter;
    }).toList();

    int pendingCount = reminders.where((r) => r.status == 'Pending').length;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: Text(
          context.trText('Reminder System'),
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
      ),
      body: Column(
        children: [
          // Stats Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Reminders',
                    reminders.length.toString(),
                    Icons.notifications,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Pending',
                    pendingCount.toString(),
                    Icons.pending,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Completed',
                    (reminders.length - pendingCount).toString(),
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),

          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filters.map((filter) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: _selectedFilter == filter,
                      onSelected: (selected) {
                        setState(() => _selectedFilter = filter);
                      },
                      selectedColor: const Color(
                        0xFFFF6B35,
                      ).withValues(alpha: 0.2),
                      checkmarkColor: const Color(0xFFFF6B35),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Reminders List
          Expanded(
            child: filteredReminders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.trText('No reminders found'),
                          style: GoogleFonts.lato(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredReminders.length,
                    itemBuilder: (context, index) {
                      final reminder = filteredReminders[index];
                      return _buildReminderCard(reminder);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addReminder(),
        backgroundColor: const Color(0xFFFF6B35),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: color ?? const Color(0xFFFF6B35), size: 24),
          const SizedBox(height: 4),
          Text(
            context.trData(value),
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A237E),
            ),
          ),
          Text(
            context.trData(title),
            style: GoogleFonts.lato(fontSize: 10, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard(Reminder reminder) {
    Color typeColor = reminder.type == 'Service'
        ? Colors.blue
        : reminder.type == 'Payment'
        ? Colors.orange
        : Colors.purple;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    reminder.type == 'Service'
                        ? Icons.build
                        : reminder.type == 'Payment'
                        ? Icons.payment
                        : Icons.security,
                    color: typeColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.trData(reminder.customerName),
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A237E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${reminder.vehicleNumber} • ${reminder.type}',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Due: ${reminder.date}',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: reminder.status == 'Pending'
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: reminder.status == 'Pending'
                            ? Colors.red.shade100
                            : Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        context.trData(reminder.status),
                        style: GoogleFonts.lato(
                          fontSize: 10,
                          color: reminder.status == 'Pending'
                              ? Colors.red.shade700
                              : Colors.green.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.call,
                            size: 20,
                            color: Color(0xFFFF6B35),
                          ),
                          onPressed: () => _makeCall(reminder.customerPhone),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.message,
                            size: 20,
                            color: Color(0xFFFF6B35),
                          ),
                          onPressed: () => _sendMessage(reminder.customerPhone),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (reminder.status == 'Pending')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _sendReminder(reminder),
                      icon: const Icon(Icons.notifications_active, size: 18),
                      label: Text(context.trText('Send Reminder')),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFF6B35)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _markCompleted(reminder),
                      icon: const Icon(Icons.check, size: 18),
                      label: Text(context.trText('Mark Done')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _addReminder() {
    showDialog(
      context: context,
      builder: (context) => _AddReminderDialog(
        onAdd: (reminder) => setState(() => reminders.add(reminder)),
      ),
    );
  }

  void _sendReminder(Reminder reminder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.trText('Send Reminder')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.notifications_active,
              size: 50,
              color: Color(0xFFFF6B35),
            ),
            const SizedBox(height: 16),
            Text('Reminder sent to ${reminder.customerName}'),
            Text(context.trText('via SMS and Notification')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.trText('OK')),
          ),
        ],
      ),
    );
  }

  void _markCompleted(Reminder reminder) {
    setState(() {
      reminder.status = 'Completed';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Reminder marked as completed for ${reminder.customerName}',
        ),
      ),
    );
  }

  void _makeCall(String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.trText('Calling $phone...'))),
    );
  }

  void _sendMessage(String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.trText('Opening chat with $phone...'))),
    );
  }
}

class Reminder {
  String customerName;
  String customerPhone;
  String vehicleNumber;
  String type;
  String date;
  String status;

  Reminder({
    required this.customerName,
    required this.customerPhone,
    required this.vehicleNumber,
    required this.type,
    required this.date,
    required this.status,
  });
}

class _AddReminderDialog extends StatefulWidget {
  final Function(Reminder) onAdd;
  const _AddReminderDialog({required this.onAdd});

  @override
  State<_AddReminderDialog> createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends State<_AddReminderDialog> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _vehicleController = TextEditingController();
  String _selectedType = 'Service';
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.trText('Add Reminder')),
      content: SizedBox(
        width: 300,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: context.trText('Customer Name'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: context.trText('Phone Number'),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _vehicleController,
                decoration: InputDecoration(
                  labelText: context.trText('Vehicle Number'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: InputDecoration(
                  labelText: context.trText('Reminder Type'),
                  border: OutlineInputBorder(),
                ),
                items: ['Service', 'Payment', 'Insurance'].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(context.trText('Due Date')),
                subtitle: Text(_selectedDate.toString().split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2027),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.trText('Cancel')),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty &&
                _phoneController.text.isNotEmpty) {
              widget.onAdd(
                Reminder(
                  customerName: _nameController.text,
                  customerPhone: _phoneController.text,
                  vehicleNumber: _vehicleController.text,
                  type: _selectedType,
                  date: _selectedDate.toString().split(' ')[0],
                  status: 'Pending',
                ),
              );
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B35),
          ),
          child: Text(context.trText('Add')),
        ),
      ],
    );
  }
}
