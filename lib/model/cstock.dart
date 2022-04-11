import 'package:hive/hive.dart';

part 'cstock.g.dart';

@HiveType(typeId: 2)
class CStock {
  @HiveField(0)
  final String invoice;

  @HiveField(1)
  final String date;

  @HiveField(2)
  final String truckCount;

  @HiveField(3)
  final String port;

  @HiveField(4)
  final String ton;

  @HiveField(5)
  final String cft;

  @HiveField(6)
  final String threeToFour;

  @HiveField(7)
  final String oneToSix;

  @HiveField(8)
  final String half;

  @HiveField(9)
  final String fiveToTen;

  @HiveField(10)
  final String totalBalance;

  @HiveField(11)
  final String extra;

  @HiveField(12)
  final String remarks;

  @HiveField(13)
  final String supplierName;

  @HiveField(14)
  final String supplierContact;

  @HiveField(15)
  final String year;

  @HiveField(16)
  final String rate;

  @HiveField(17)
  final String price;

  @HiveField(18)
  final String truckNumber;

  CStock(
      this.invoice,
      this.date,
      this.truckCount,
      this.port,
      this.ton,
      this.cft,
      this.threeToFour,
      this.oneToSix,
      this.half,
      this.fiveToTen,
      this.totalBalance,
      this.extra,
      this.remarks,
      this.supplierName,
      this.supplierContact,
      this.year,
      this.rate,
      this.price,
      this.truckNumber);
}
