// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_tip_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthTipAdapter extends TypeAdapter<HealthTip> {
  @override
  final int typeId = 1;

  @override
  HealthTip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthTip(
      title: fields[0] as String,
      description: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HealthTip obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthTipAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
