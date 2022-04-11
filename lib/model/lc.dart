import 'package:hive/hive.dart';

part 'lc.g.dart';

@HiveType(typeId: 0)
class LC {
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
  final String stockBalance;

  @HiveField(8)
  final String sellerName;

  @HiveField(9)
  final String sellerContact;

  @HiveField(10)
  final String paymentType;

  @HiveField(11)
  final String paymentInformation;

  @HiveField(12)
  final String purchaseBalance;

  @HiveField(13)
  final String lcOpenPrice;

  @HiveField(14)
  final String dutyCost;

  @HiveField(15)
  final String speedMoney;

  @HiveField(16)
  final String remarks;

  @HiveField(17)
  final String lcNumber;

  @HiveField(18)
  final String totalBalance;

  @HiveField(19)
  final String year;

  LC(
      this.date,
      this.truckCount,
      this.truckNumber,
      this.invoice,
      this.port,
      this.cft,
      this.rate,
      this.stockBalance,
      this.sellerName,
      this.sellerContact,
      this.paymentType,
      this.paymentInformation,
      this.purchaseBalance,
      this.lcOpenPrice,
      this.dutyCost,
      this.speedMoney,
      this.remarks,
      this.lcNumber,
      this.totalBalance,
      this.year);
}
