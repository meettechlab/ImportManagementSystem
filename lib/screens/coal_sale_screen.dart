import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/api/pdf_coal.dart';
import 'package:importmanagementsoftware/model/invoiceCoal.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/coal_sale_entry_screen.dart';
import 'package:importmanagementsoftware/screens/coal_sale_update_screen.dart';
import 'package:importmanagementsoftware/screens/individual_lc_history_screen.dart';
import 'package:importmanagementsoftware/screens/lc_new_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/screens/new_stone_sale_screen.dart';
import 'package:importmanagementsoftware/screens/single_coal_update_screen.dart';

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

    final tempCoalBox = Hive.box('coals').values.toList();
    for (var i = 0; i < tempCoalBox.length; i++) {
      final _temp = tempCoalBox[i] as Coal;
      if (_temp.lc != "sale") {
        setState(() {
          _totalStock = (_totalStock + double.parse(_temp.ton));
        });
      } else {
        setState(() {
          _totalStock = (_totalStock - double.parse(_temp.ton));
          _totalAmount = (_totalAmount + double.parse(_temp.debit));
        });
      }
    }
  }

  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22),
      backgroundColor: Colors.blue,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Colors.blue,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CoalSaleEntryScreen()));
            },
            label: 'Add Data',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.blue),
        // FAB 2
        SpeedDialChild(
            child: Icon(
              Icons.picture_as_pdf_outlined,
              color: Colors.white,
            ),
            backgroundColor: Colors.blue,
            onTap: () {
              setState(() {
                generatePdf();
              });
            },
            label: 'Generated PDF',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.blue)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Coal Sale List'),
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
            child: Divider(),
          ),
          Expanded(child: _buildListView()),
        ],
      ),
      floatingActionButton: _getFAB(),
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('coals').listenable(),
      builder: (context, coalBox, _) {
        final coalBox = Hive.box('coals')
            .values
            .where((c) => c.lc.toLowerCase() == ("sale"))
            .toList();
        final Map coalMap = Hive.box('coals').toMap();
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
                      return buildSingleItem(coalBox[index], coalMap);
                    },
                    itemCount: coalBox.length,
                  );
      },
    );
  }

  Widget buildSingleItem(Coal coal, Map map) => Container(
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
                Column(
                  children: [
                    Text(
                      "Buyer Contact",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      coal.contact,
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
                SizedBox(
                  width: 70,
                ),
                IconButton(
                  onPressed: () {
                    map.forEach((key, value) {
                      if (value.invoice == coal.invoice) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CoalSaleUpdateScreen(
                                      coalModel: coal,
                                      k: key,
                                    )));
                      }
                    });
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.red,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    map.forEach((key, value) {
                      if (value.invoice == coal.invoice) {
                        Hive.box('coals').delete(key);
                      }
                    });
                    Hive.box('companies').toMap().forEach((key, value) {
                      if (value.id == "coalsale" + coal.invoice) {
                        Hive.box('companies').delete(key);
                      }
                    });
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  void generatePdf() async {
    final _list = <CoalItem>[];
    final coalBox = Hive.box('coals')
        .values
        .where((c) => c.lc.toLowerCase() == ("sale"))
        .toList();
    for (int i = 0; i < coalBox.length; i++) {
      final _temp = coalBox[i] as Coal;
      _list.add(new CoalItem(
          _temp.date,
          _temp.truckCount,
          _temp.truckNumber,
          _temp.port,
          _temp.supplierName,
          _temp.ton,
          _temp.rate,
          _temp.totalPrice,
          _temp.paymentType,
          _temp.paymentInformation,
          _temp.remarks));
    }

    final invoice = InvoiceCoal(
        _totalStock.toString(), _totalAmount.toString(), "sale", _list);

    final pdfFile = await PdfCoal.generate(invoice, true);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green, content: Text("Pdf Generated!!")));
  }
}
