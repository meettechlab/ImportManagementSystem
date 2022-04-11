import 'package:hive/hive.dart';

part 'company.g.dart';

@HiveType(typeId: 6)
class Company {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String contact;

  @HiveField(3)
  final String address;

  @HiveField(4)
  final String credit;

  @HiveField(5)
  final String debit;

  @HiveField(6)
  final String remarks;

  @HiveField(7)
  final String invoice;

  @HiveField(8)
  final String paymentTypes;

  @HiveField(9)
  final String paymentInfo;

  @HiveField(10)
  final String date;

  @HiveField(11)
  final String year;



  Company(
      this.id,
      this.name,
      this.contact,
      this.address,
      this.credit,
      this.debit,
      this.remarks,
      this.invoice,
      this.paymentTypes,
      this.paymentInfo,
      this.date,
      this.year
      );
}
