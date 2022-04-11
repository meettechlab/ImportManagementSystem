import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/api/pdf_api.dart';
import 'package:importmanagementsoftware/api/pdf_invoice_api_stone_purchase.dart';
import 'package:importmanagementsoftware/model/invoiceStonePurchase.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/individual_lc_entry_screen.dart';
import 'package:importmanagementsoftware/screens/individual_lc_update_screen.dart';
import 'package:intl/intl.dart';

import '../model/company.dart';

class IndividualLCHistoryScreen extends StatefulWidget {
  final LC lcModel;

  const IndividualLCHistoryScreen({Key? key, required this.lcModel})
      : super(key: key);

  @override
  _IndividualLCHistoryScreenState createState() =>
      _IndividualLCHistoryScreenState();
}

class _IndividualLCHistoryScreenState extends State<IndividualLCHistoryScreen> {
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
  String rate = "0";
  String lcOpenPrice = "0";
  String dutyCost = "0";
  String speedMoney = "0";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _process = false;
    _count = 1;
    final tempBox = Hive.box('lcs').values.where((c) =>
        c.lcNumber.toLowerCase() == (widget.lcModel.lcNumber.toLowerCase()));
    final tempBoxList = tempBox.toList();
    for (var i = 0; i < tempBoxList.length; i++) {
      final _temp = tempBoxList[i] as LC;
      setState(() {
        _totalStock =
            (double.parse(_totalStock.toString()) + double.parse(_temp.cft));
      });
    }
    final tempItem = tempBox.last as LC;
    if (double.parse(tempItem.totalBalance) > 0) {
      _totalAmount = double.parse(tempItem.totalBalance);
      disFAB = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rateField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: false,
            controller: rateEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Rate cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              rateEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Rate',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final lcOpenPriceField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: lcOpenPriceEditingController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("LC Open Price cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              lcOpenPriceEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'LC Open Price',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final dutyCostField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: dutyCostEditingController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Duty Cost cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              dutyCostEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Duty Cost',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final speedMoneyField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: speedMoneyEditingController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Speed Money cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              speedMoneyEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Speed Money',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final addButton = Material(
      elevation: (_process!) ? 0 : 5,
      color: (_process!) ? Colors.blue.shade800 : Colors.blue,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(
          100,
          30,
          100,
          30,
        ),
        minWidth: 20,
        onPressed: () {
          setState(() {
            _process = true;
            _count = (_count! - 1);
          });
          (_count! < 0)
              ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red, content: Text("Please Wait!!")))
              : AddData();
        },
        child: (_process!)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Processing',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Center(
                      child: SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ))),
                ],
              )
            : Text(
                'Close LC',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
      ),
    );
    Widget buildSingleItem(LC lc, Map map) => Container(
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
                  SizedBox(
                    width: 70,
                  ),
                  disFAB
                      ? Text("")
                      : IconButton(
                          onPressed: () {
                            map.forEach((key, value) {
                              if (value.lcNumber == lc.lcNumber &&
                                  value.invoice == lc.invoice) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            IndividualLCUpdateScreen(
                                              lcModel: lc,
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
                  disFAB
                      ? Text("")
                      : IconButton(
                          onPressed: () {
                            map.forEach((key, value) {
                              if (value.lcNumber == lc.lcNumber &&
                                  value.invoice == lc.invoice) {
                                Hive.box('lcs').delete(key);
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

    Widget _buildListView() {
      return ValueListenableBuilder(
        valueListenable: Hive.box('lcs').listenable(),
        builder: (context, lcBox, _) {
          final lcBox = Hive.box('lcs')
              .values
              .where((c) =>
                  c.lcNumber.toLowerCase() ==
                  (widget.lcModel.lcNumber.toLowerCase()))
              .toList();

          final Map lcMap = Hive.box('lcs').toMap();
          return (lcBox == null)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : (lcBox.isEmpty)
                  ? Center(
                      child: Text('No LC'),
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        return buildSingleItem(lcBox[index], lcMap);
                      },
                      itemCount: lcBox.length,
                    );
        },
      );
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
                disFAB
                    ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.green,
                        content: Text("LC Closed!!")))
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IndividualLCEntryScreen(
                                lcModel: widget.lcModel)));
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
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    rateField,
                    lcOpenPriceField,
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [dutyCostField, speedMoneyField],
                ),
                SizedBox(
                  height: 20,
                ),
                addButton,
                SizedBox(
                  height: 20,
                ),
                Expanded(child: _buildListView()),
              ],
            ),
          ),
        ),
        floatingActionButton: _getFAB());
  }

  void AddData() {
    if (_formKey.currentState!.validate()) {
      final lcBox = Hive.box('lcs');
      final _stock = _totalStock.toString();
      final _purchaseBalance = (double.parse(_totalStock.toString()) *
              double.parse(rateEditingController.text))
          .toString();
      final _totalBalance = (double.parse(_purchaseBalance) +
              double.parse(lcOpenPriceEditingController.text) +
              double.parse(dutyCostEditingController.text) +
              double.parse(speedMoneyEditingController.text))
          .toString();
      final lcModel = LC(
          DateFormat('dd-MMM-yyyy').format(DateTime.now()),
          "LC Closed",
          "LC Closed",
          "LC Closed",
          "LC Closed",
          "0",
          rateEditingController.text,
          _stock,
          "LC Closed",
          "LC Closed",
          "LC Closed",
          "LC Closed",
          _purchaseBalance,
          lcOpenPriceEditingController.text,
          dutyCostEditingController.text,
          speedMoneyEditingController.text,
          "LC Closed",
          widget.lcModel.lcNumber,
          _totalBalance,
          widget.lcModel.date);

      lcBox.add(lcModel);
      final tempBox = Hive.box('lcs').values.where((c) => c.lcNumber
          .toLowerCase()
          .contains(widget.lcModel.lcNumber.toLowerCase()));

      final tempItem = tempBox.last as LC;
      if (double.parse(tempItem.totalBalance) > 0) {
        setState(() {
          _totalAmount = double.parse(tempItem.totalBalance);
          disFAB = true;
          rate = rateEditingController.text;
          lcOpenPrice = lcOpenPriceEditingController.text;
          dutyCost = dutyCostEditingController.text;
          speedMoney = speedMoneyEditingController.text;

          rateEditingController.clear();
          lcOpenPriceEditingController.clear();
          dutyCostEditingController.clear();
          speedMoneyEditingController.clear();

          final companyModel = Company(
              "stonestock" + widget.lcModel.lcNumber,
              widget.lcModel.sellerName,
              widget.lcModel.sellerContact,
              "0",
              _purchaseBalance,
              "0",
              "stonestock" + widget.lcModel.lcNumber,
              "2",
              "0",
              "0",
              widget.lcModel.date,
              "0");
          Hive.box('companies').add(companyModel);
        });
      }

      setState(() {
        _process = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green, content: Text("LC Closed!!")));
      setState(() {
        _process = false;
        _count = 1;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text("Something Wrong!!")));
      setState(() {
        _process = false;
        _count = 1;
      });
    }
  }

  void generatePdf() async {
    final _list = <StonePurchaseItem>[];
    final lcBox = Hive.box('lcs')
        .values
        .where((c) =>
            c.lcNumber.toLowerCase() == (widget.lcModel.lcNumber.toLowerCase()))
        .toList();
    for (int i = 0; i < lcBox.length; i++) {
      final _temp = lcBox[i] as LC;
      _list.add(new StonePurchaseItem(_temp.date, _temp.truckCount,
          _temp.truckNumber, _temp.port, _temp.cft, _temp.remarks));
    }

    final invoice = InvoiceStonePurchase(
        widget.lcModel.lcNumber,
        widget.lcModel.sellerName,
        widget.lcModel.sellerContact,
        rate,
        lcOpenPrice,
        dutyCost,
        speedMoney,
        _list);

    final pdfFile = await PdfInvoiceApiStonePurchase.generate(invoice);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green, content: Text("Pdf Generated!!")));
  }
}
