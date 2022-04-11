import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/model/cstock.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/crusher_stock_entry.dart';
import 'package:importmanagementsoftware/screens/crusher_stock_update.dart';
import 'package:importmanagementsoftware/screens/individual_lc_history_screen.dart';
import 'package:importmanagementsoftware/screens/lc_new_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/screens/new_stone_sale_screen.dart';

import '../api/pdf_crusher_stock.dart';
import '../model/csale.dart';
import '../model/invoiceCrusherStock.dart';
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
            child: Icon(Icons.add, color: Colors.white,),
            backgroundColor: Colors.blue,
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context) => CrusherStockEntryScreen()));
            },
            label: 'Add Data',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.blue),
        // FAB 2
        SpeedDialChild(
            child: Icon(Icons.picture_as_pdf_outlined,color: Colors.white,),
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

      floatingActionButton: _getFAB(),
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('cStocks').listenable(),
      builder: (context, cStockBox, _) {
        final cStockBox = Hive.box('cStocks').values.where((c) => c.port
            .toLowerCase()
            .contains("tamabil")).toList();
        final Map cStockMap = Hive.box('cStocks').toMap();
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
            return buildSingleItem(cStockBox[index],cStockMap);
          },
          itemCount: cStockBox.length,
        );
      },
    );
  }


  Widget buildSingleItem(CStock cStock, Map map) => Container(
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
                      "Truck Plate Number",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    Text(
                      cStock.truckNumber,
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
            SizedBox(
                  width: 70,
                ),
                IconButton(
                  onPressed: () {
                    map.forEach((key, value) {
                      if (value.invoice == cStock.invoice) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CrusherStockUpdateScreen(
                                      cStock: cStock,
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
                      if (value.invoice == cStock.invoice) {
                        Hive.box('cStocks').delete(key);
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

    final _list = <CrusherStockItem>[];
    final cStockBox = Hive.box('cStocks').values.where((c) => c.port
        .toLowerCase()
        .contains("tamabil")).toList();
    for(int i = 0; i<cStockBox.length;i++){
      final _temp = cStockBox[i] as CStock;
      _list.add(new CrusherStockItem(_temp.date, _temp.truckCount, _temp.port,_temp.supplierName,_temp.supplierContact, _temp.cft,_temp.rate,_temp.price,_temp.threeToFour,_temp.oneToSix, _temp.half,_temp.fiveToTen, _temp.totalBalance,_temp.extra, _temp.remarks));
    }

    final invoice = InvoiceCrusherStock(
        _list
    );


    final pdfFile = await PdfCrusherStock.generate(invoice);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Pdf Generated!!")));

  }
}
