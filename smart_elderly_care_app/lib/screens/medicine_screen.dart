import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_elderly_care_app/models/medicine_model.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  final _medicineCtrl = TextEditingController();
  final _dosageCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _frequencies = ['Daily', 'Weekly', 'One Time'];

  late Box<MedicineReminder> _reminderBox;

  @override
  void initState() {
    super.initState();
    _reminderBox = Hive.box<MedicineReminder>('remindersBox');
  }

  TimeOfDay? _time;
  DateTime? _date;
  String _frequency = 'Daily';

  void _addReminder() {
    if (_medicineCtrl.text.isEmpty || _time == null) {
      _snack('Please enter medicine name and select time');
      return;
    }

    final reminder = MedicineReminder(
      medicine: _medicineCtrl.text,
      dosage: _dosageCtrl.text,
      notes: _notesCtrl.text,
      time: _time!.format(context),
      frequency: _frequency,
      date: _date != null ? DateFormat.yMd().format(_date!) : null,
      isActive: true,
    );

    _reminderBox.add(reminder);
    _scheduleReminder({
      'medicine': reminder.medicine,
      'date': reminder.date,
      'time': reminder.time,
    });

    _clearFields();
    Navigator.pop(context);
  }

  void _scheduleReminder(Map<String, dynamic> reminder) {
    final now = DateTime.now();
    DateTime time = DateTime(
      reminder['date'] != null
          ? DateFormat.yMd().parse(reminder['date']).year
          : now.year,
      reminder['date'] != null
          ? DateFormat.yMd().parse(reminder['date']).month
          : now.month,
      reminder['date'] != null
          ? DateFormat.yMd().parse(reminder['date']).day
          : now.day,
      _time!.hour,
      _time!.minute,
    );
    if (time.isBefore(now)) time = time.add(const Duration(days: 1));

    Timer(
      time.difference(now),
      () => _showReminderDialog(reminder['medicine']),
    );
    _snack("Reminder set for ${DateFormat.jm().format(time)}");
  }

  void _showReminderDialog(String medicine) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Column(
          children: [
            Icon(Icons.medication, color: Colors.teal, size: 40),
            SizedBox(height: 10),
            Text(
              "Medicine Reminder 💊",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Time to take your medicine: $medicine"),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _dialogBtn("Snooze", Colors.grey.shade200, Colors.black),
                _dialogBtn("Taken", Colors.teal, Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton _dialogBtn(String text, Color bg, Color fg) => ElevatedButton(
    onPressed: () => Navigator.pop(context),
    style: ElevatedButton.styleFrom(backgroundColor: bg, foregroundColor: fg),
    child: Text(text),
  );

  void _showAddDialog() {
    final width = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (_, setState) => Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width * 0.9),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add New Reminder",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _input(_medicineCtrl, 'Medicine Name *', Icons.medication),
                    _input(_dosageCtrl, 'Dosage', Icons.scale),
                    _input(_notesCtrl, 'Notes (Optional)', Icons.note),
                    const SizedBox(height: 16),
                    const Text(
                      "Frequency",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: _frequencies.map((f) {
                        return Expanded(
                          child: RadioListTile<String>(
                            dense: true,
                            title: Text(
                              f,
                              style: const TextStyle(fontSize: 14),
                            ),
                            value: f,
                            groupValue: _frequency,
                            onChanged: (v) => setState(() => _frequency = v!),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    _pickerRow(
                      label: _time == null
                          ? 'No time selected *'
                          : 'Time: ${_time!.format(context)}',
                      icon: Icons.access_time,
                      text: 'Select Time',
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) setState(() => _time = picked);
                      },
                    ),
                    if (_frequency == 'One Time') ...[
                      const SizedBox(height: 16),
                      _pickerRow(
                        label: _date == null
                            ? 'No date selected *'
                            : 'Date: ${DateFormat.yMd().format(_date!)}',
                        icon: Icons.calendar_today,
                        text: 'Select Date',
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => _date = picked);
                        },
                      ),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: _addReminder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            "Add Reminder",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController c, String label, IconData icon) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: c,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            prefixIcon: Icon(icon),
          ),
        ),
      );

  Widget _pickerRow({
    required String label,
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 18, color: Colors.white),
          label: Text(text, style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
        ),
      ],
    ),
  );

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
  );

  void _clearFields() {
    _medicineCtrl.clear();
    _dosageCtrl.clear();
    _notesCtrl.clear();
    _time = null;
    _date = null;
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = _reminderBox.values
        .cast<MedicineReminder>()
        .where((r) => r.isActive)
        .length;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Medicine Reminders',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const AlertDialog(
                title: Text("About Medicine Reminders"),
                content: Text(
                  "Set reminders for daily, weekly, or one-time medicines. "
                  "You'll be notified when it's time to take them.",
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.medication, color: Colors.white, size: 50),
                const SizedBox(height: 10),
                const Text(
                  "Never Miss Your Medicine",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "You have $activeCount active reminders",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _reminderBox.listenable(),
              builder: (context, Box<MedicineReminder> box, _) {
                if (box.values.isEmpty) {
                  return const Center(child: Text("No Medicine Reminders"));
                }

                final reminders = box.values.cast<MedicineReminder>().toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: reminders.length,
                  itemBuilder: (context, i) {
                    final r = reminders[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: r.isActive
                              ? Colors.teal.shade100
                              : Colors.grey.shade200,
                          child: Icon(
                            Icons.medication,
                            color: r.isActive ? Colors.teal : Colors.grey,
                          ),
                        ),
                        title: Text(
                          r.medicine,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: r.isActive
                                ? null
                                : TextDecoration.lineThrough,
                          ),
                        ),
                        subtitle: Text(
                          "${r.dosage} ${r.time} • ${r.frequency}",
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (v) {
                            if (v == 'toggle') {
                              r.isActive = !r.isActive;
                              r.save();
                            } else if (v == 'delete') {
                              r.delete();
                            }
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: 'toggle',
                              child: Text(r.isActive ? 'Disable' : 'Enable'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
