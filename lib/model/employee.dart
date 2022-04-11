import 'package:hive/hive.dart';

part 'employee.g.dart';

@HiveType(typeId: 4)
class Employee {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String post;

  @HiveField(3)
  final String salary;

  @HiveField(4)
  final String salaryAdvanced;

  @HiveField(5)
  final String balance;

  @HiveField(6)
  final String due;

  @HiveField(7)
  final String remarks;

  @HiveField(8)
  final String invoice;

  @HiveField(9)
  final String contact;

  @HiveField(10)
  final String address;

  @HiveField(13)
  final String year;

  Employee(
      this.date,
      this.name,
      this.post,
      this.salary,
      this.salaryAdvanced,
      this.balance,
      this.due,
      this.remarks,
      this.invoice,
      this.contact,
      this.address,
      this.year
      );
}