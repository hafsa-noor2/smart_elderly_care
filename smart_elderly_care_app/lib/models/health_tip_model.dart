import 'package:hive/hive.dart';

part 'health_tip_model.g.dart';

@HiveType(typeId: 1) // 👈 Must be unique (not 0)
class HealthTip extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  HealthTip({
    required this.title,
    required this.description,
  });
}
