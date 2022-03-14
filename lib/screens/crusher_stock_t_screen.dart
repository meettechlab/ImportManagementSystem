import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/model/cstock.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/crusher_stock_entry.dart';
import 'package:importmanagementsoftware/screens/individual_lc_history_screen.dart';
import 'package:importmanagementsoftware/screens/lc_new_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/screens/new_stone_sale_screen.dart';

import '../model/csale.dart';
import '../model/stone.dart';
import 'individual_lc_entry_screen.dart';

class CrusherStockTScreen extends StatefulWidget {
  const CrusherStockTScreen({Key? key}) : super(key: key);

  @override
  _CrusherStockTScreenState createState() => _CrusherStockTScreenState();
}

class _CrusherStockTScreenState extends State<CrusherStockTScreen> {

  double _totalStock = 0.0;
  double _totalSale = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final tempStockBox = Hive.box('cStocks').values.where((c) => c.port
        .toLowerCase()
        .contains("tamabil")).toList();
    for (var i = 0; i < tempStockBox.length; i++) {
      final _temp = tempStockBox[i] as CStock;
      setState(() {
        _totalStock = (double.parse(_totalStock.toString()) + double.parse(_temp.totalBalance));
        _totalSale = _totalSale + double.parse(_temp.price);
      });
    }

    final tempSaleBox = Hive.box('cSales').values.where((c) => c.port
        .toLowerCase()
        .contains("tamabil")).toList();
    for (var i = 0; i < tempSaleBox.length; i++) {
      final _temp = tempSaleBox[i] as CSale;
      setState(() {
        _totalStock = (double.parse(_totalStock.toString()) - double.parse(_temp.cft));
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Crusher Stock : $_totalStock CFT",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                Text(
                  "Total Sale : $_totalSale TK",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            ),
          ),
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
              context, MaterialPageRoute(builder: (context) => CrusherStockEntryScreen()));
        },
        child:Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('cStocks').listenable(),
      builder: (context, cStockBox, _) {
        final cStockBox = Hive.box('cStocks').values.where((c) => c.port
            .toLowerCase()
            .contains("tamabil")).toList();
        return (cStockBox == null)
            ? Center(
          child: CircularProgressIndicator(),
        )
            : (cStockBox.isEmpty)
            ? Center(
          child: Text('No Entry'),
        )
            : ListView.builder(
          itemBuilder: (context, index) {
            return buildSingleItem(cStockBox[index]);
          },
          itemCount: cStockBox.length,
        );
      },
    );
  }


  Widget buildSingleItem(CStock cStock) => Container(
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
                  cStock.date,
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
                  cStock.invoice,
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
                  cStock.truckCount,
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
                  "Ton",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cStock.ton,
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
                  cStock.cft,
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Rate",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cStock.rate,
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
                  "Total Price",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cStock.price,
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
                  "Port",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cStock.port,
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
                  cStock.threeToFour,
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
                  cStock.oneToSix,
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
                  cStock.half,
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
                  cStock.fiveToTen,
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
                  "Total Balance",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cStock.totalBalance,
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
                  "Extra",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  cStock.extra,
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
                  cStock.remarks,
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
