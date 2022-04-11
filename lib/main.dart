import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/model/coal.dart';
import 'package:importmanagementsoftware/model/company.dart';
import 'package:importmanagementsoftware/model/csale.dart';
import 'package:importmanagementsoftware/model/cstock.dart';
import 'package:importmanagementsoftware/model/daily.dart';
import 'package:importmanagementsoftware/model/employee.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/model/noncoal.dart';
import 'package:importmanagementsoftware/model/nonstone.dart';
import 'package:importmanagementsoftware/model/stone.dart';
import 'package:importmanagementsoftware/screens/dashboard.dart';
import 'package:importmanagementsoftware/screens/individual_lc_entry_screen.dart';
import 'package:importmanagementsoftware/screens/individual_lc_history_screen.dart';
import 'package:importmanagementsoftware/screens/lc_list_screen.dart';
import 'package:importmanagementsoftware/screens/login_screen.dart';
import 'package:importmanagementsoftware/splash_screen.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(LCAdapter());
  Hive.registerAdapter(StoneAdapter());
  Hive.registerAdapter(CStockAdapter());
  Hive.registerAdapter(CSaleAdapter());
  Hive.registerAdapter(EmployeeAdapter());
  Hive.registerAdapter(CoalAdapter());
  Hive.registerAdapter(CompanyAdapter());
  Hive.registerAdapter(DailyAdapter());
  Hive.registerAdapter(NonCoalAdapter());
  Hive.registerAdapter(NonStoneAdapter());
  final lcBox = await Hive.openBox('lcs');
  final stoneBox = await Hive.openBox('stones');
  final cStockBox = await Hive.openBox('cStocks');
  final cSaleBox = await Hive.openBox('cSales');
  final employeeBox = await Hive.openBox('employees');
  final coalBox = await Hive.openBox('coals');
  final companyBox = await Hive.openBox('companies');
  final dailyBox = await Hive.openBox('daily');
  final nonCoalBox = await Hive.openBox('noncoal');
  final nonStoneBox = await Hive.openBox('nonstone');
  runApp(const MyApp());

}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
