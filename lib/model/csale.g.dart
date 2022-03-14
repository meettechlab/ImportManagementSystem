// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'csale.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CSaleAdapter extends TypeAdapter<CSale> {
  @override
  final int typeId = 3;

  @override
  CSale read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CSale(
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
      fields[14] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CSale obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.invoice)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.truckCount)
      ..writeByte(3)
      ..write(obj.cft)
      ..writeByte(4)
      ..write(obj.rate)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.threeToFour)
      ..writeByte(7)
      ..write(obj.oneToSix)
      ..writeByte(8)
      ..write(obj.half)
      ..writeByte(9)
      ..write(obj.fiveToTen)
      ..writeByte(10)
      ..write(obj.remarks)
      ..writeByte(11)
      ..write(obj.port)
      ..writeByte(12)
      ..write(obj.buyerName)
      ..writeByte(13)
      ..write(obj.buyerContact)
      ..writeByte(14)
      ..write(obj.year);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CSaleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
