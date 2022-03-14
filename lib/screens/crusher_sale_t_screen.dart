import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/model/csale.dart';
import 'package:importmanagementsoftware/model/cstock.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/crusher_sale_entry_screen.dart';
import 'package:importmanagementsoftware/screens/crusher_stock_entry.dart';
import 'package:importmanagementsoftware/screens/individual_lc_history_screen.dart';
import 'package:importmanagementsoftware/screens/lc_new_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/screens/new_stone_sale_screen.dart';

import '../model/stone.dart';
import 'individual_lc_entry_screen.dart';

class CrusherSaleTScreen extends StatefulWidget {
  const CrusherSaleTScreen({Key? key}) : super(key: key);

  @override
  _CrusherSaleTScreenState createState() => _CrusherSaleTScreenState();
}

class _CrusherSaleTScreenState extends State<CrusherSaleTScreen> {

  double _totalStock = 0.0;
  double _totalSale = 0.0;
  double _threeToFour = 0.0;
  double _oneToSix = 0.0;
  double _half = 0.0;
  double _fiveToTen = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final tempStockBox =  Hive.box('cStocks').values.where((c) => c.port
        .toLowerCase()
        .contains("tamabil")).toList();;
    for (var i = 0; i < tempStockBox.length; i++) {
      final _temp = tempStockBox[i] as CStock;
      setState(() {
        _totalStock = (double.parse(_totalStock.toString()) + double.parse(_temp.totalBalance));
        _threeToFour = (double.parse(_threeToFour.toString()) + double.parse(_temp.threeToFour));
        _oneToSix = (double.parse(_oneToSix.toString()) + double.parse(_temp.oneToSix));
        _half = (double.parse(_half.toString()) + double.parse(_temp.half));
        _fiveToTen = (double.parse(_fiveToTen.toString()) + double.parse(_temp.fiveToTen));
      });
    }

    final tempSaleBox =  Hive.box('cSales').values.where((c) => c.port
        .toLowerCase()
        .contains("tamabil")).toList();;
    for (var i = 0; i < tempSaleBox.length; i++) {
      final _temp = tempSaleBox[i] as CSale;
      setState(() {
        _totalStock = (double.parse(_totalStock.toString()) - double.parse(_temp.cft));
        _totalSale = (double.parse(_totalSale.toString()) + double.parse(_temp.price));
        _threeToFour = (double.parse(_threeToFour.toString()) - double.parse(_temp.threeToFour));
        _oneToSix = (double.parse(_oneToSix.toString()) - double.parse(_temp.oneToSix));
        _half = (double.parse(_half.toString()) - double.parse(_temp.half));
        _fiveToTen = (double.parse(_fiveToTen.toString()) - double.parse(_temp.fiveToTen));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'Crusher Stock ( Tamabil )'
        ),
      ),


      body: Column(
        children: [
          individualStock(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(

            ),
          ),
          Expanded(child: _buildListView()),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CrusherSaleEntryScreen()));
        },
        child:Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget individualStock() => Container(
    padding: const EdgeInsets.all(15),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  "3/4",
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
                Text(
                  _threeToFour.toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "16 mm",
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
                Text(
                  _oneToSix.toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "1/2",
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
                Text(
                  _half.toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "5/10",
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
                Text(
                  _fiveToTen.toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Total stock",
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
                Text(
                  _totalStock.toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Total Sale",
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
                Text(
                  _totalSale.toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildListView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('cSales').listenable(),
      builder: (context, cSaleBox, _) {
        final cSaleBox =  Hive.box('cSales').values.where((c) => c.port
            .toLowerCase()
            .contains("tamabil")).toList();
        return (cSaleBox == null)
            ? Center(
          child: CircularProgressIndicator(),
        )
            : (cSaleBox.isEmpty)
            ? Center(
          child: Text('No Entry'),
        )
            : ListView.builder(
          itemBuilder: (context, index) {
            return buildSingleItem(cSaleBox[index]);
          },
          itemCount: cSaleBox.length,
        );
      },
    );
  }


  Widget buildSingleItem(CSale cSale) => Container(
    padding: const EdgeInsets.all(15),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Date",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cSale.date,
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Invoice",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cSale.invoice,
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Truck No",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cSale.truckCount,
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "CFT",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cSale.cft,
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Rate",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cSale.rate,
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Price",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cSale.price,
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "3/4",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cSale.threeToFour,
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "16 mm",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cSale.oneToSix,
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "1/2",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cSale.half,
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "5/10",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cSale.fiveToTen,
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Remarks",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cSale.remarks,
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
