import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/individual_lc_entry_screen.dart';
import 'package:importmanagementsoftware/screens/single_coal_entry_screen.dart';
import 'package:intl/intl.dart';

import '../model/coal.dart';
import '../model/company.dart';
import '../model/noncoal.dart';
import 'non_coal_entry_screen.dart';

class NonCoalHistoryScreen extends StatefulWidget {
  final NonCoal coalModel;

  const NonCoalHistoryScreen({Key? key, required this.coalModel})
      : super(key: key);

  @override
  _NonCoalHistoryScreenState createState() =>
      _NonCoalHistoryScreenState();
}

class _NonCoalHistoryScreenState extends State<NonCoalHistoryScreen> {

  double _totalStock = 0.0;
  double _totalAmount = 0.0;
  bool? _process;
  int? _count;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _process = false;
    _count = 1;
    final tempBox = Hive.box('noncoal')
        .values
        .where((c) => c.lc
        .toLowerCase()
        .contains(widget.coalModel.lc.toLowerCase()));
    final tempBoxList = tempBox.toList();
    for (var i = 0; i < tempBoxList.length; i++) {
      final _temp = tempBoxList[i] as NonCoal;
      setState(() {
        _totalStock = (double.parse(_totalStock.toString()) + double.parse(_temp.ton));
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    Widget buildSingleItem(NonCoal coal) => Container(
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
                    "Supplier Name",
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
                    "Supplier Contact",
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

    Widget _buildListView() {
      return ValueListenableBuilder(
        valueListenable: Hive.box('noncoal').listenable(),
        builder: (context, coalBox, _) {
          final coalBox = Hive.box('noncoal')
              .values
              .where((c) => c.lc
              .toLowerCase()
              .contains(widget.coalModel.lc.toLowerCase()))
              .toList();
          return (coalBox == null)
              ? Center(
            child: CircularProgressIndicator(),
          )
              : (coalBox.isEmpty)
              ? Center(
            child: Text('No Coal LC'),
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("LC Number ${widget.coalModel.lc}"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "LC Number : ${widget.coalModel.lc}",
                    style: TextStyle(color: Colors.red, fontSize: 25),
                  ),
                  Text(
                    "Stock : $_totalStock Ton",
                    style: TextStyle(color: Colors.red, fontSize: 25),
                  ),
                  Text(
                    "Total Cost : $_totalAmount TK",
                    style: TextStyle(color: Colors.red, fontSize: 25),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Expanded(child: _buildListView()),

            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
 Navigator.push(context, MaterialPageRoute(builder: (context) => NonCoalEntryScreen(coalModel: widget.coalModel,)));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

}
