import 'package:hive/hive.dart';

part 'coal.g.dart';

@HiveType(typeId: 5)
class Coal {
  @HiveField(0)
  final String lc;

  @HiveField(1)
  final String date;

  @HiveField(2)
  final String invoice;

  @HiveField(3)
  final String supplierName;

  @HiveField(4)
  final String port;

  @HiveField(5)
  final String ton;

  @HiveField(6)
  final String rate;

  @HiveField(7)
  final String totalPrice;

  @HiveField(8)
  final String paymentType;

  @HiveField(9)
  final String paymentInformation;

  @HiveField(10)
  final String credit;

  @HiveField(11)
  final String debit;

  @HiveField(12)
  final String remarks;

  @HiveField(13)
  final String year;

  @HiveField(14)
  final String truckCount;

  @HiveField(15)
  final String truckNumber;


  @HiveField(16)
  final String contact;

  Coal(
      this.lc,
      this.date,
      this.invoice,
      this.supplierName,
      this.port,
      this.ton,
      this.rate,
      this.totalPrice,
      this.paymentType,
      this.paymentInformation,
      this.credit,
      this.debit,
      this.remarks,
      this.year,
      this.truckCount,
      this.truckNumber,
      this.contact
      );
}
