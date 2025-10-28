import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  final List<Map<String, dynamic>> _emergencyContacts = [
    {'name': 'John (Son)', 'phone': '+92 300 1234567', 'selected': true},
    {'name': 'Sarah (Daughter)', 'phone': '+92 300 7654321', 'selected': true},
    {'name': 'Dr. Ahmed', 'phone': '+92 300 9876543', 'selected': false},
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add Emergency Contact",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Name',
                    hintText: 'e.g., John (Son)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'e.g., +92 300 1234567',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
                          setState(() {
                            _emergencyContacts.add({
                              'name': _nameController.text,
                              'phone': _phoneController.text,
                              'selected': true,
                            });
                          });
                          _nameController.clear();
                          _phoneController.clear();
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      child: const Text("Add Contact", style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleContactSelection(int index) {
    setState(() {
      _emergencyContacts[index]['selected'] = !_emergencyContacts[index]['selected'];
    });
  }

  void _deleteContact(int index) {
    setState(() {
      _emergencyContacts.removeAt(index);
    });
  }

  void _alertSelectedContacts() {
    final selectedContacts = _emergencyContacts.where((contact) => contact['selected']).toList();
    
    if (selectedContacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one contact to alert'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Confirm Emergency Alert"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Are you sure you want to send an emergency alert to:"),
            const SizedBox(height: 12),
            ...selectedContacts.map((contact) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text("• ${contact['name']} (${contact['phone']})"),
              )
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _sendEmergencyAlerts(selectedContacts);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Send Alert", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  void _sendEmergencyAlerts(List<Map<String, dynamic>> contacts) {
    // In a real app, this would send SMS or make calls
    // For demo purposes, we'll show a snackbar for each contact
    
    for (final contact in contacts) {
      // Simulate sending alert
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Emergency alert sent to ${contact['name']}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Optionally, directly call the contact using URL launcher
      _makePhoneCall(contact['phone']);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch phone call'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: const Text(
          'Emergency SOS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("About SOS"),
                  content: const Text(
                    "This feature allows you to quickly alert your emergency contacts in case of an emergency. "
                    "Add your family members, doctors, or caregivers to your contact list.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Got it"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Warning section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Color.fromARGB(255, 255, 255, 255),
                  size: 60,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Emergency Alert',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Alert your emergency contacts quickly in case of an emergency',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color.fromARGB(135, 255, 255, 255)),
                ),
              ],
            ),
          ),
          
          // Emergency contacts section
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Emergency Contacts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _showAddContactDialog,
                        icon: const Icon(Icons.add, color: Colors.teal),
                        label: const Text(
                          'Add Contact',
                          style: TextStyle(color: Colors.teal),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Contacts list
                Expanded(
                  child: _emergencyContacts.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.contacts_outlined,
                                size: 60,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "No emergency contacts added",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Tap 'Add Contact' to get started",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _emergencyContacts.length,
                          itemBuilder: (context, index) {
                            final contact = _emergencyContacts[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: contact['selected'] ? Colors.teal : Colors.grey.shade300,
                                  width: contact['selected'] ? 2 : 1,
                                ),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: contact['selected'] ? Colors.teal.shade100 : Colors.grey.shade200,
                                  child: Icon(
                                    contact['selected'] ? Icons.check_circle : Icons.person,
                                    color: contact['selected'] ? Colors.teal : Colors.grey,
                                  ),
                                ),
                                title: Text(
                                  contact['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: contact['selected'] ? Colors.teal : Colors.black87,
                                  ),
                                ),
                                subtitle: Text(contact['phone']),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'toggle') {
                                      _toggleContactSelection(index);
                                    } else if (value == 'delete') {
                                      _deleteContact(index);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'toggle',
                                      child: Text(contact['selected'] ? 'Deselect' : 'Select'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                                onTap: () => _toggleContactSelection(index),
                              ),
                            );
                          },
                        ),
                ),
                
                const SizedBox(height: 16),
                
                // SOS button
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton.icon(
                    onPressed: _alertSelectedContacts,
                    icon: const Icon(Icons.warning, color: Colors.white),
                    label: const Text(
                      'SEND EMERGENCY ALERT',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}