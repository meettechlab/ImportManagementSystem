import 'package:hive/hive.dart';

part 'csale.g.dart';

@HiveType(typeId: 3)
class CSale {
  @HiveField(0)
  final String invoice;

  @HiveField(1)
  final String date;

  @HiveField(2)
  final String truckCount;

  @HiveField(3)
  final String cft;

  @HiveField(4)
  final String rate;

  @HiveField(5)
  final String price;

  @HiveField(6)
  final String threeToFour;

  @HiveField(7)
  final String oneToSix;

  @HiveField(8)
  final String half;

  @HiveField(9)
  final String fiveToTen;

  @HiveField(10)
  final String remarks;

  @HiveField(11)
  final String port;

  @HiveField(12)
  final String buyerName;

  @HiveField(13)
  final String buyerContact;

  @HiveField(14)
  final String year;

  CSale(
      this.invoice,
      this.date,
      this.truckCount,
      this.cft,
      this.rate,
      this.price,
      this.threeToFour,
      this.oneToSix,
      this.half,
      this.fiveToTen,
      this.remarks,
      this.port,
      this.buyerName,
      this.buyerContact,
      this.year
      );
}