// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'noncoal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NonCoalAdapter extends TypeAdapter<NonCoal> {
  @override
  final int typeId = 9;

  @override
  NonCoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NonCoal(
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
    );
  }

  @override
  void write(BinaryWriter writer, NonCoal obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.lc)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.invoice)
      ..writeByte(3)
      ..write(obj.supplierName)
      ..writeByte(4)
      ..write(obj.port)
      ..writeByte(5)
      ..write(obj.ton)
      ..writeByte(6)
      ..write(obj.rate)
      ..writeByte(7)
      ..write(obj.totalPrice)
      ..writeByte(8)
      ..write(obj.paymentType)
      ..writeByte(9)
      ..write(obj.paymentInformation)
      ..writeByte(10)
      ..write(obj.credit)
      ..writeByte(11)
      ..write(obj.debit)
      ..writeByte(12)
      ..write(obj.remarks)
      ..writeByte(13)
      ..write(obj.year)
      ..writeByte(14)
      ..write(obj.truckCount)
      ..writeByte(15)
      ..write(obj.truckNumber)
      ..writeByte(16)
      ..write(obj.contact);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NonCoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
