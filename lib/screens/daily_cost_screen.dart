import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/screens/coal_lc_list_screen.dart';
import 'package:importmanagementsoftware/screens/coal_sale_screen.dart';
import 'package:importmanagementsoftware/screens/crusher_sale_s_screen.dart';
import 'package:importmanagementsoftware/screens/crusher_stock_t_screen.dart';
import 'package:importmanagementsoftware/screens/daily_coal_screen.dart';
import 'package:importmanagementsoftware/screens/daily_crusher_screen.dart';
import 'package:importmanagementsoftware/screens/daily_entry_screen.dart';
import 'package:importmanagementsoftware/screens/daily_stone_screen.dart';
import 'package:importmanagementsoftware/screens/employee_list_screen.dart';
import 'package:importmanagementsoftware/screens/lc_list_screen.dart';
import 'package:importmanagementsoftware/screens/stone_sale_screen.dart';

import '../model/lc.dart';
import '../model/stone.dart';
import 'company_list_screen.dart';
import 'crusher_sale_t_screen.dart';
import 'crusher_stock_s_screen.dart';

class DailyCostScreen extends StatefulWidget {
  const DailyCostScreen({Key? key}) : super(key: key);

  @override
  _DailyCostScreenState createState() => _DailyCostScreenState();
}

class _DailyCostScreenState extends State<DailyCostScreen> {
  double _totalStock = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Daily Cost',
          textAlign: TextAlign.center,
          style: TextStyle(
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Center(
                child: TextButton(
                    onPressed: (){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => DailyCoalScreen()));
                    },
                    child: Text(
                      'Coal',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    )
                ),
              ),
              SizedBox(height: 20,),
              Center(
                child: TextButton(
                    onPressed: (){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => DailyStoneScreen()));
                    },
                    child: Text(
                      'Stone',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    )
                ),
              ),

              SizedBox(height: 20,),
              Center(
                child: TextButton(
                    onPressed: (){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => DailyCrusherScreen()));
                    },
                    child: Text(
                      'Crusher',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => DailyEntryScreen()));
        },
        child:Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
