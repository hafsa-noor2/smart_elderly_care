import 'package:flutter/material.dart';

class HealthTips extends StatelessWidget {
  const HealthTips({super.key});

  final List<Map<String, String>> _healthTips = const [
    {
      'title': 'Stay Hydrated',
      'description': 'Drink at least 8 glasses of water daily. Proper hydration helps maintain body temperature, lubricate joints, and prevent infections.',
      'icon': '💧'
    },
    {
      'title': 'Regular Exercise',
      'description': 'Engage in light exercises like walking for 30 minutes daily. Regular activity helps maintain mobility and independence.',
      'icon': '🚶'
    },
    {
      'title': 'Healthy Diet',
      'description': 'Eat a balanced diet rich in fruits, vegetables, and whole grains. Limit processed foods and salt intake.',
      'icon': '🍎'
    },
    {
      'title': 'Adequate Sleep',
      'description': 'Aim for 7-8 hours of sleep each night. Good sleep improves memory, mood, and overall health.',
      'icon': '😴'
    },
    {
      'title': 'Regular Check-ups',
      'description': 'Visit your doctor regularly for health screenings and check-ups. Prevention is better than cure.',
      'icon': '🩺'
    },
    {
      'title': 'Medication Management',
      'description': 'Take medications as prescribed. Use pill organizers and set reminders to avoid missing doses.',
      'icon': '💊'
    },
    {
      'title': 'Mental Health',
      'description': 'Stay socially connected and engaged. Mental health is as important as physical health for overall well-being.',
      'icon': '❤️'
    },
    {
      'title': 'Fall Prevention',
      'description': 'Remove tripping hazards at home. Use assistive devices if needed and wear proper footwear.',
      'icon': '🛡️'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Health Tips',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header section
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
                  Icons.health_and_safety,
                  color: Colors.white,
                  size: 50,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Healthy Living Tips",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${_healthTips.length} tips for better health",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Tips list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _healthTips.length,
              itemBuilder: (context, index) {
                final tip = _healthTips[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              tip['icon']!,
                              style: const TextStyle(fontSize: 30),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                tip['title']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          tip['description']!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                        ),
                      ],
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
}