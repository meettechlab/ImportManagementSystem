// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyAdapter extends TypeAdapter<Daily> {
  @override
  final int typeId = 7;

  @override
  Daily read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Daily(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
      fields[8] as String,
      fields[9] as String,
      fields[10] as String,
      fields[11] as String,
      fields[12] as String,
      fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Daily obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.invoice)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.transport)
      ..writeByte(3)
      ..write(obj.unload)
      ..writeByte(4)
      ..write(obj.depoRent)
      ..writeByte(5)
      ..write(obj.koipot)
      ..writeByte(6)
      ..write(obj.stoneCrafting)
      ..writeByte(7)
      ..write(obj.disselCost)
      ..writeByte(8)
      ..write(obj.grissCost)
      ..writeByte(9)
      ..write(obj.mobilCost)
      ..writeByte(10)
      ..write(obj.totalBalance)
      ..writeByte(11)
      ..write(obj.extra)
      ..writeByte(12)
      ..write(obj.remarks)
      ..writeByte(13)
      ..write(obj.year);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
