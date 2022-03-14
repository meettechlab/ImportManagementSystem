// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stone.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoneAdapter extends TypeAdapter<Stone> {
  @override
  final int typeId = 1;

  @override
  Stone read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Stone(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[9] as String,
      fields[10] as String,
      fields[12] as String,
      fields[7] as String,
      fields[8] as String,
      fields[11] as String,
      fields[13] as String,
      fields[14] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Stone obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.truckCount)
      ..writeByte(2)
      ..write(obj.truckNumber)
      ..writeByte(3)
      ..write(obj.invoice)
      ..writeByte(4)
      ..write(obj.port)
      ..writeByte(5)
      ..write(obj.cft)
      ..writeByte(6)
      ..write(obj.rate)
      ..writeByte(7)
      ..write(obj.buyerName)
      ..writeByte(8)
      ..write(obj.buyerContact)
      ..writeByte(9)
      ..write(obj.paymentType)
      ..writeByte(10)
      ..write(obj.paymentInformation)
      ..writeByte(11)
      ..write(obj.totalSale)
      ..writeByte(12)
      ..write(obj.remarks)
      ..writeByte(13)
      ..write(obj.stock)
      ..writeByte(14)
      ..write(obj.year);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoneAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
