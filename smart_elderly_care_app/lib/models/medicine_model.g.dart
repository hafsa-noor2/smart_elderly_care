// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicineReminderAdapter extends TypeAdapter<MedicineReminder> {
  @override
  final int typeId = 0;

  @override
  MedicineReminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicineReminder(
      medicine: fields[0] as String,
      dosage: fields[1] as String,
      notes: fields[2] as String?,
      time: fields[3] as String,
      frequency: fields[4] as String,
      date: fields[5] as String?,
      isActive: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MedicineReminder obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.medicine)
      ..writeByte(1)
      ..write(obj.dosage)
      ..writeByte(2)
      ..write(obj.notes)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.frequency)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
