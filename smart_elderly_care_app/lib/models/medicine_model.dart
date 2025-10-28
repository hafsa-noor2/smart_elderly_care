import 'package:hive/hive.dart';

part 'medicine_model.g.dart';

@HiveType(typeId: 0)
class MedicineReminder extends HiveObject {
  @HiveField(0)
  String medicine;

  @HiveField(1)
  String dosage;

  @HiveField(2)
  String? notes;

  @HiveField(3)
  String time;

  @HiveField(4)
  String frequency;

  @HiveField(5)
  String? date;

  @HiveField(6)
  bool isActive;

  MedicineReminder({
    required this.medicine,
    required this.dosage,
    this.notes,
    required this.time,
    required this.frequency,
    this.date,
    this.isActive = true,
  });
}
