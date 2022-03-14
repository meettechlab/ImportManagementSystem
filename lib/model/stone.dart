import 'package:hive/hive.dart';

part 'stone.g.dart';

@HiveType(typeId: 1)
class Stone {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final String truckCount;

  @HiveField(2)
  final String truckNumber;

  @HiveField(3)
  final String invoice;

  @HiveField(4)
  final String port;

  @HiveField(5)
  final String cft;

  @HiveField(6)
  final String rate;

  @HiveField(7)
  final String buyerName;

  @HiveField(8)
  final String buyerContact;

  @HiveField(9)
  final String paymentType;

  @HiveField(10)
  final String paymentInformation;

  @HiveField(11)
  final String totalSale;


  @HiveField(12)
  final String remarks;

  @HiveField(13)
  final String stock;

  @HiveField(14)
  final String year;


  Stone(
      this.date,
      this.truckCount,
      this.truckNumber,
      this.invoice,
      this.port,
      this.cft,
      this.rate,
      this.paymentType,
      this.paymentInformation,
      this.remarks,
      this.buyerName,
      this.buyerContact,
      this.totalSale,
      this.stock,
      this.year
      );
}
