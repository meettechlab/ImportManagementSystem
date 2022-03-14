import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/coal_sale_entry_screen.dart';
import 'package:importmanagementsoftware/screens/individual_lc_history_screen.dart';
import 'package:importmanagementsoftware/screens/lc_new_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/screens/new_stone_sale_screen.dart';

import '../model/coal.dart';
import '../model/stone.dart';
import 'individual_lc_entry_screen.dart';

class CoalSaleScreen extends StatefulWidget {
  const CoalSaleScreen({Key? key}) : super(key: key);

  @override
  _CoalSaleScreenState createState() => _CoalSaleScreenState();
}

class _CoalSaleScreenState extends State<CoalSaleScreen> {

  double _totalStock = 0.0;
  double _totalAmount = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final tempCoalBox = Hive.box('coals')
        .values
        .toList();
    for (var i = 0; i < tempCoalBox.length; i++) {
      final _temp = tempCoalBox[i] as Coal;
      setState(() {
        _totalStock = (_totalStock + double.parse(_temp.ton));
        _totalAmount = (_totalAmount+ double.parse(_temp.debit));
      });
    }

    final tempCoalBox2 =Hive.box('coals')
        .values
        .where((c) => c.lc
        .toLowerCase()
        .contains("sale"))
        .toList();
    for (var i = 0; i < tempCoalBox2.length; i++) {
      final _temp = tempCoalBox2[i] as Coal;
      setState(() {
        _totalStock = (_totalStock - double.parse(_temp.ton));
      });
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'Coal Sale List'
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
                  "Available Stock : $_totalStock Ton",
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
              context, MaterialPageRoute(builder: (context) => CoalSaleEntryScreen()));
        },
        child:Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('coals').listenable(),
      builder: (context, coalBox, _) {
        final coalBox = Hive.box('coals')
            .values
            .where((c) => c.lc
            .toLowerCase()
            .contains("sale"))
            .toList();
        return (coalBox == null)
            ? Center(
          child: CircularProgressIndicator(),
        )
            : (coalBox.isEmpty)
            ? Center(
          child: Text('No Entry'),
        )
            : ListView.builder(
          itemBuilder: (context, index) {
            return buildSingleItem(coalBox[index]);
          },
          itemCount: coalBox.length,
        );
      },
    );
  }


  Widget buildSingleItem(Coal coal) => Container(
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
                  coal.date,
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
                  coal.invoice,
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
                  "Truck Count",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  coal.truckCount,
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
                  "Truck Number",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  coal.truckNumber,
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
                  coal.port,
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
                  coal.supplierName,
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),

            SizedBox(
              width: 70,
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Supplier Contact",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  coal.contact,
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "Payment Type",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  coal.paymentType,
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
                  coal.paymentInformation,
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
                  coal.ton,
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
                  coal.rate,
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
                  coal.totalPrice,
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
                  coal.remarks,
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
