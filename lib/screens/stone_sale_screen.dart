import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/individual_lc_history_screen.dart';
import 'package:importmanagementsoftware/screens/lc_new_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/screens/new_stone_sale_screen.dart';

import '../model/stone.dart';
import 'individual_lc_entry_screen.dart';

class StoneSaleScreen extends StatefulWidget {
  const StoneSaleScreen({Key? key}) : super(key: key);

  @override
  _StoneSaleScreenState createState() => _StoneSaleScreenState();
}

class _StoneSaleScreenState extends State<StoneSaleScreen> {

  double _totalStock = 0.0;
  double _totalAmount = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final tempLCBox = Hive.box('lcs')
        .values
        .toList();
    for (var i = 0; i < tempLCBox.length; i++) {
      final _temp = tempLCBox[i] as LC;
      setState(() {
        _totalStock = (double.parse(_totalStock.toString()) + double.parse(_temp.cft));

      });
    }
    final tempStoneBox = Hive.box('stones')
        .values
        .toList();
    for (var i = 0; i < tempStoneBox.length; i++) {
      final _temp = tempStoneBox[i] as Stone;
      setState(() {
        _totalStock = (double.parse(_totalStock.toString()) - double.parse(_temp.cft));
        _totalAmount = (double.parse(_totalAmount.toString()) + double.parse(_temp.totalSale));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'Stone Border Sale List'
        ),
      ),


      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Stock : $_totalStock CFT",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                Text(
                  "Total Sale : $_totalAmount TK",
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
              context, MaterialPageRoute(builder: (context) => NewStoneSaleScreen()));
        },
        child:Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('stones').listenable(),
      builder: (context, stoneBox, _) {
        final stoneBox = Hive.box('stones').values.toList();
        return (stoneBox == null)
            ? Center(
          child: CircularProgressIndicator(),
        )
            : (stoneBox.isEmpty)
            ? Center(
          child: Text('No Entry'),
        )
            : ListView.builder(
          itemBuilder: (context, index) {
            return buildSingleItem(stoneBox[index]);
          },
          itemCount: stoneBox.length,
        );
      },
    );
  }


  Widget buildSingleItem(Stone stone) => Container(
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
                  stone.date,
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
                  stone.invoice,
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
                  stone.truckCount,
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
                  "Truck Plate Number",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  stone.truckNumber,
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
                  stone.port,
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
                  "Buyer Name",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  stone.buyerName,
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
                  "Buyer Contact",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  stone.buyerContact,
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
                  "Payment Type",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  stone.paymentType,
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
                  "Payment Info ( If needed )",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  stone.paymentInformation,
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
                  stone.cft,
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
                  stone.rate,
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
                  "Total Amount Sale",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  stone.totalSale,
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
                  stone.remarks,
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
