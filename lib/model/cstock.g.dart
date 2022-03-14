// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cstock.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CStockAdapter extends TypeAdapter<CStock> {
  @override
  final int typeId = 2;

  @override
  CStock read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CStock(
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
      fields[15] as String,
      fields[16] as String,
      fields[17] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CStock obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.invoice)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.truckCount)
      ..writeByte(3)
      ..write(obj.port)
      ..writeByte(4)
      ..write(obj.ton)
      ..writeByte(5)
      ..write(obj.cft)
      ..writeByte(6)
      ..write(obj.threeToFour)
      ..writeByte(7)
      ..write(obj.oneToSix)
      ..writeByte(8)
      ..write(obj.half)
      ..writeByte(9)
      ..write(obj.fiveToTen)
      ..writeByte(10)
      ..write(obj.totalBalance)
      ..writeByte(11)
      ..write(obj.extra)
      ..writeByte(12)
      ..write(obj.remarks)
      ..writeByte(13)
      ..write(obj.supplierName)
      ..writeByte(14)
      ..write(obj.supplierContact)
      ..writeByte(15)
      ..write(obj.year)
      ..writeByte(16)
      ..write(obj.rate)
      ..writeByte(17)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CStockAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
