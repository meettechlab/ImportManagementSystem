import 'package:hive/hive.dart';

part 'daily.g.dart';

@HiveType(typeId: 7)
class Daily {

  @HiveField(0)
  final String invoice;

  @HiveField(1)
  final String date;

  @HiveField(2)
  final String transport;

  @HiveField(3)
  final String unload;

  @HiveField(4)
  final String depoRent;

  @HiveField(5)
  final String koipot;

  @HiveField(6)
  final String stoneCrafting;

  @HiveField(7)
  final String disselCost;

  @HiveField(8)
  final String grissCost;

  @HiveField(9)
  final String mobilCost;

  @HiveField(10)
  final String totalBalance;

  @HiveField(11)
  final String extra;

  @HiveField(12)
  final String remarks;

  @HiveField(13)
  final String year;

  Daily(
      this.invoice,
      this.date,
      this.transport,
      this.unload,
      this.depoRent,
      this.koipot,
      this.stoneCrafting,
      this.disselCost,
      this.grissCost,
      this.mobilCost,
      this.totalBalance,
      this.extra,
      this.remarks,
      this.year
      );
}
