import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/model/nonstone.dart';
import 'package:importmanagementsoftware/screens/individual_lc_entry_screen.dart';
import 'package:importmanagementsoftware/screens/non_stone_entry_screen.dart';
import 'package:intl/intl.dart';

import '../model/company.dart';

class NonStoneHistoryScreen extends StatefulWidget {
  final NonStone lcModel;

  const NonStoneHistoryScreen({Key? key, required this.lcModel})
      : super(key: key);

  @override
  _NonStoneHistoryScreenState createState() =>
      _NonStoneHistoryScreenState();
}

class _NonStoneHistoryScreenState extends State<NonStoneHistoryScreen> {

  double _totalStock = 0.0;
  double _totalAmount = 0.0;
  final lcOpenPriceEditingController = new TextEditingController();
  final dutyCostEditingController = new TextEditingController();
  final speedMoneyEditingController = new TextEditingController();
  final rateEditingController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool? _process;
  int? _count;
  bool disFAB = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _process = false;
    _count = 1;
    final tempBox = Hive.box('nonstone')
        .values
        .where((c) => c.lcNumber
        .toLowerCase()
        .contains(widget.lcModel.lcNumber.toLowerCase()));
    final tempBoxList = tempBox.toList();
    for (var i = 0; i < tempBoxList.length; i++) {
      final _temp = tempBoxList[i] as NonStone;
      setState(() {
        _totalStock = (double.parse(_totalStock.toString()) + double.parse(_temp.cft));
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    Widget buildSingleItem(NonStone lc) => Container(
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
                    lc.date,
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
                    lc.invoice,
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
                    lc.truckCount,
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
                    lc.truckNumber,
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
                    lc.port,
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
                    "Seller Name",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                  Text(
                    lc.sellerName,
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
                    "Seller Contact",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                  Text(
                    lc.sellerContact,
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
                    lc.cft,
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
                    lc.remarks,
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
        valueListenable: Hive.box('nonstone').listenable(),
        builder: (context, lcBox, _) {
          final lcBox = Hive.box('nonstone')
              .values
              .where((c) => c.lcNumber
              .toLowerCase()
              .contains(widget.lcModel.lcNumber.toLowerCase()))
              .toList();
          return (lcBox == null)
              ? Center(
            child: CircularProgressIndicator(),
          )
              : (lcBox.isEmpty)
              ? Center(
            child: Text('No Non-LC'),
          )
              : ListView.builder(
            itemBuilder: (context, index) {
              return buildSingleItem(lcBox[index]);
            },
            itemCount: lcBox.length,
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("LC Number ${widget.lcModel.lcNumber}"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "LC Number : ${widget.lcModel.lcNumber}",
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                  Text(
                    "Stock : $_totalStock CFT",
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                  Text(
                    "Total Balance : $_totalAmount TK",
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Expanded(child: _buildListView()),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         Navigator.push(context, MaterialPageRoute(builder: (context) => NonStoneEntryScreen(lcModel: widget.lcModel)));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
