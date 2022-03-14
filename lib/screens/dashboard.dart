import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/screens/coal_lc_list_screen.dart';
import 'package:importmanagementsoftware/screens/coal_sale_screen.dart';
import 'package:importmanagementsoftware/screens/crusher_sale_s_screen.dart';
import 'package:importmanagementsoftware/screens/crusher_stock_t_screen.dart';
import 'package:importmanagementsoftware/screens/employee_list_screen.dart';
import 'package:importmanagementsoftware/screens/lc_list_screen.dart';
import 'package:importmanagementsoftware/screens/non_lc_screen.dart';
import 'package:importmanagementsoftware/screens/profit_loss_screen.dart';
import 'package:importmanagementsoftware/screens/stone_sale_screen.dart';

import '../model/lc.dart';
import '../model/stone.dart';
import 'company_list_screen.dart';
import 'crusher_sale_t_screen.dart';
import 'crusher_stock_s_screen.dart';
import 'daily_cost_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
          'Dashboard',
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
                            context, MaterialPageRoute(builder: (context) => LCListScreen()));
                      },
                      child: Text(
                        'Letter of Credit ( LC )',
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
                            context, MaterialPageRoute(builder: (context) => StoneSaleScreen()));
                      },
                      child: Text(
                        'Stone Border Sale',
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
                            context, MaterialPageRoute(builder: (context) => CrusherStockSScreen()));
                      },
                      child: Text(
                        'Crusher Stock ( Shutarkandi )',
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
                            context, MaterialPageRoute(builder: (context) => CrusherStockTScreen()));
                      },
                      child: Text(
                        'Crusher Stock ( Tamabil )',
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
                            context, MaterialPageRoute(builder: (context) => CrusherSaleSScreen()));
                      },
                      child: Text(
                        'Crusher Sale ( Shutarkandi )',
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
                            context, MaterialPageRoute(builder: (context) => CrusherSaleTScreen()));
                      },
                      child: Text(
                        'Crusher Sale ( Tamabil )',
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
                            context, MaterialPageRoute(builder: (context) => EmployeeListScreen()));
                      },
                      child: Text(
                        'Employees',
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
                            context, MaterialPageRoute(builder: (context) => CoalLCListScreen()));
                      },
                      child: Text(
                        'Coal Purchase',
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
                            context, MaterialPageRoute(builder: (context) => CoalSaleScreen()));
                      },
                      child: Text(
                        'Coal Sale',
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
                            context, MaterialPageRoute(builder: (context) => CompanyListScreen()));
                      },
                      child: Text(
                        'Clients/Suppliers',
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
                            context, MaterialPageRoute(builder: (context) => DailyCostScreen()));
                      },
                      child: Text(
                        'Daily Cost',
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
                            context, MaterialPageRoute(builder: (context) => NonLCScreen()));
                      },
                      child: Text(
                        'NON-LC Transaction',
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
                            context, MaterialPageRoute(builder: (context) => ProfitLossScreen()));
                      },
                      child: Text(
                        'Profit / Loss',
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
    );
  }
}
