import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/api/pdf_stone_sale.dart';
import 'package:importmanagementsoftware/model/invoiceStoneSale.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/individual_lc_history_screen.dart';
import 'package:importmanagementsoftware/screens/lc_new_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/screens/new_stone_sale_screen.dart';
import 'package:importmanagementsoftware/screens/stone_update_screen.dart';

import '../api/pdf_invoice_api_stone_purchase.dart';
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

    final tempLCBox = Hive.box('lcs').values.toList();
    for (var i = 0; i < tempLCBox.length; i++) {
      final _temp = tempLCBox[i] as LC;
      setState(() {
        _totalStock =
            (double.parse(_totalStock.toString()) + double.parse(_temp.cft));
      });
    }
    final tempStoneBox = Hive.box('stones').values.toList();
    for (var i = 0; i < tempStoneBox.length; i++) {
      final _temp = tempStoneBox[i] as Stone;
      setState(() {
        _totalStock =
            (double.parse(_totalStock.toString()) - double.parse(_temp.cft));
        _totalAmount = (double.parse(_totalAmount.toString()) +
            double.parse(_temp.totalSale));
      });
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
                      builder: (context) => NewStoneSaleScreen()));
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
        title: Text('Stone Border Sale List'),
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
      valueListenable: Hive.box('stones').listenable(),
      builder: (context, stoneBox, _) {
        final stoneBox = Hive.box('stones').values.toList();
        final Map stoneMap = Hive.box('stones').toMap();
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
                      return buildSingleItem(stoneBox[index], stoneMap);
                    },
                    itemCount: stoneBox.length,
                  );
      },
    );
  }

  Widget buildSingleItem(Stone stone, Map map) => Container(
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
                SizedBox(
                  width: 70,
                ),
                IconButton(
                  onPressed: () {
                    map.forEach((key, value) {
                      if (value.invoice == stone.invoice) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StoneUpdateScreen(
                                      stoneModel: stone,
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
                      if (value.invoice == stone.invoice) {
                        Hive.box('stones').delete(key);
                      }
                    });
                    Hive.box('companies').toMap().forEach((key, value) {
                      if (value.id == "stonesale" + stone.invoice) {
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
    final _list = <StoneSaleItem>[];
    final stoneBox = Hive.box('stones').values.toList();
    for (int i = 0; i < stoneBox.length; i++) {
      final _temp = stoneBox[i] as Stone;
      _list.add(new StoneSaleItem(
          _temp.date,
          _temp.truckCount,
          _temp.truckNumber,
          _temp.port,
          _temp.buyerName,
          _temp.buyerContact,
          _temp.cft,
          _temp.rate,
          _temp.totalSale,
          _temp.paymentType,
          _temp.paymentInformation,
          _temp.remarks));
    }

    final invoice = InvoiceStoneSale(_list);

    final pdfFile = await PdfStoneSale.generate(invoice);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green, content: Text("Pdf Generated!!")));
  }
}
