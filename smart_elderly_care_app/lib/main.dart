import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_elderly_care_app/models/health_tip_model.dart';
import 'package:smart_elderly_care_app/models/medicine_model.dart';
// import 'package:smart_elderly_care/screens/home_screen.dart';
import 'package:smart_elderly_care_app/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(MedicineReminderAdapter());
  Hive.registerAdapter(HealthTipAdapter());

  await Hive.openBox<MedicineReminder>('remindersBox');
  await Hive.openBox<HealthTip>('tipsBox');

  runApp(const SilverCareApp());
}

class SilverCareApp extends StatelessWidget {
  const SilverCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SilverCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 4, 69, 63),
          foregroundColor: Color.fromARGB(226, 16, 16, 16),
        ),
      ),
      home: const SplashScreen(),
      //home: const HomeScreen(),
    );
  }
}
