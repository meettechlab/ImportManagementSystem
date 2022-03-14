// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nonstone.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NonStoneAdapter extends TypeAdapter<NonStone> {
  @override
  final int typeId = 8;

  @override
  NonStone read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NonStone(
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
      fields[18] as String,
      fields[19] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NonStone obj) {
    writer
      ..writeByte(20)
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
      ..write(obj.stockBalance)
      ..writeByte(8)
      ..write(obj.sellerName)
      ..writeByte(9)
      ..write(obj.sellerContact)
      ..writeByte(10)
      ..write(obj.paymentType)
      ..writeByte(11)
      ..write(obj.paymentInformation)
      ..writeByte(12)
      ..write(obj.purchaseBalance)
      ..writeByte(13)
      ..write(obj.lcOpenPrice)
      ..writeByte(14)
      ..write(obj.dutyCost)
      ..writeByte(15)
      ..write(obj.speedMoney)
      ..writeByte(16)
      ..write(obj.remarks)
      ..writeByte(17)
      ..write(obj.lcNumber)
      ..writeByte(18)
      ..write(obj.totalBalance)
      ..writeByte(19)
      ..write(obj.year);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NonStoneAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
