import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/api/pdf_crusher_sale.dart';
import 'package:importmanagementsoftware/model/csale.dart';
import 'package:importmanagementsoftware/model/cstock.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/crusher_sale_entry_screen.dart';
import 'package:importmanagementsoftware/screens/crusher_sale_update.dart';
import 'package:importmanagementsoftware/screens/crusher_stock_entry.dart';
import 'package:importmanagementsoftware/screens/individual_lc_history_screen.dart';
import 'package:importmanagementsoftware/screens/lc_new_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/screens/new_stone_sale_screen.dart';

import '../model/invoiceCrusherSale.dart';
import '../model/invoiceCrusherStock.dart';
import '../model/stone.dart';
import 'individual_lc_entry_screen.dart';

class CrusherSaleSScreen extends StatefulWidget {
  const CrusherSaleSScreen({Key? key}) : super(key: key);

  @override
  _CrusherSaleSScreenState createState() => _CrusherSaleSScreenState();
}

class _CrusherSaleSScreenState extends State<CrusherSaleSScreen> {
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

    final tempStockBox = Hive.box('cStocks')
        .values
        .where((c) => c.port.toLowerCase().contains("shutarkandi"))
        .toList();
    for (var i = 0; i < tempStockBox.length; i++) {
      final _temp = tempStockBox[i] as CStock;
      setState(() {
        _totalStock = (double.parse(_totalStock.toString()) +
            double.parse(_temp.totalBalance));
        _threeToFour = (double.parse(_threeToFour.toString()) +
            double.parse(_temp.threeToFour));
        _oneToSix =
            (double.parse(_oneToSix.toString()) + double.parse(_temp.oneToSix));
        _half = (double.parse(_half.toString()) + double.parse(_temp.half));
        _fiveToTen = (double.parse(_fiveToTen.toString()) +
            double.parse(_temp.fiveToTen));
      });
    }

    final tempSaleBox = Hive.box('cSales')
        .values
        .where((c) => c.port.toLowerCase().contains("shutarkandi"))
        .toList();
    for (var i = 0; i < tempSaleBox.length; i++) {
      final _temp = tempSaleBox[i] as CSale;
      setState(() {
        _totalStock =
            (double.parse(_totalStock.toString()) - double.parse(_temp.cft));
        _totalSale =
            (double.parse(_totalSale.toString()) + double.parse(_temp.price));
        _threeToFour = (double.parse(_threeToFour.toString()) -
            double.parse(_temp.threeToFour));
        _oneToSix =
            (double.parse(_oneToSix.toString()) - double.parse(_temp.oneToSix));
        _half = (double.parse(_half.toString()) - double.parse(_temp.half));
        _fiveToTen = (double.parse(_fiveToTen.toString()) -
            double.parse(_temp.fiveToTen));
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
                      builder: (context) => CrusherSaleEntryScreen()));
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
        title: Text('Crusher Sale ( Shutarkandi )'),
      ),
      body: Column(
        children: [
          individualStock(),
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
        final cSaleBox = Hive.box('cSales')
            .values
            .where((c) => c.port.toLowerCase().contains("shutarkandi"))
            .toList();
        final Map cSaleMap = Hive.box('cSales').toMap();
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
                      return buildSingleItem(cSaleBox[index],cSaleMap);
                    },
                    itemCount: cSaleBox.length,
                  );
      },
    );
  }

  Widget buildSingleItem(CSale cSale, Map map) => Container(
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
                      "Truck Plate Number",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      cSale.truckNumber,
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
                      cSale.buyerName,
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
                      cSale.buyerContact,
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

                  SizedBox(
                  width: 70,
                ),
                IconButton(
                  onPressed: () {
                    map.forEach((key, value) {
                      if (value.invoice == cSale.invoice) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CrusherSaleUpdateScreen(
                                      cSale: cSale,
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
                      if (value.invoice == cSale.invoice) {
                        Hive.box('cSales').delete(key);
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
    final _list = <CrusherSaleItem>[];
    final cStockBox = Hive.box('cSales')
        .values
        .where((c) => c.port.toLowerCase().contains("shutarkandi"))
        .toList();
    for (int i = 0; i < cStockBox.length; i++) {
      final _temp = cStockBox[i] as CSale;
      _list.add(new CrusherSaleItem(
          _temp.date,
          _temp.truckCount,
          _temp.port,
          _temp.buyerContact,
          _temp.buyerName,
          _temp.cft,
          _temp.rate,
          _temp.price,
          _temp.threeToFour,
          _temp.oneToSix,
          _temp.half,
          _temp.fiveToTen,
          _temp.remarks));
    }

    final invoice = InvoiceCrusherSale(
        _threeToFour.toString(),
        _oneToSix.toString(),
        _half.toString(),
        _fiveToTen.toString(),
        _totalStock.toString(),
        _totalSale.toString(),
        _list);

    final pdfFile = await PdfCrusherSale.generate(invoice);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green, content: Text("Pdf Generated!!")));
  }
}
