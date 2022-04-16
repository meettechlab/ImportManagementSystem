import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/individual_lc_entry_screen.dart';
import 'package:importmanagementsoftware/screens/single_coal_entry_screen.dart';
import 'package:importmanagementsoftware/screens/single_coal_update_screen.dart';
import 'package:intl/intl.dart';

import '../api/pdf_coal.dart';
import '../model/coal.dart';
import '../model/company.dart';
import '../model/invoiceCoal.dart';

class SingleCoalLCScreen extends StatefulWidget {
  final Coal coalModel;

  const SingleCoalLCScreen({Key? key, required this.coalModel})
      : super(key: key);

  @override
  _SingleCoalLCScreenState createState() => _SingleCoalLCScreenState();
}

class _SingleCoalLCScreenState extends State<SingleCoalLCScreen> {
  double _totalStock = 0.0;
  double _totalAmount = 0.0;
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
    final tempBox = Hive.box('coals').values.where(
        (c) => c.lc.toLowerCase() == (widget.coalModel.lc.toLowerCase()));
    final tempBoxList = tempBox.toList();
    for (var i = 0; i < tempBoxList.length; i++) {
      final _temp = tempBoxList[i] as Coal;
      setState(() {
        _totalStock =
            (double.parse(_totalStock.toString()) + double.parse(_temp.ton));
      });
    }
    final tempItem = tempBox.last as Coal;
    if (double.parse(tempItem.totalPrice) > 0) {
      _totalAmount = double.parse(tempItem.totalPrice);
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
                  SizedBox(
                    width: 70,
                  ),
                  disFAB
                      ? Text("")
                      : IconButton(
                          onPressed: () {
                            map.forEach((key, value) {
                              if (value.lc == coal.lc &&
                                  value.invoice == coal.invoice) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SingleCoalUpdateScreen(
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
                  disFAB
                      ? Text("")
                      : IconButton(
                          onPressed: () {
                            map.forEach((key, value) {
                              if (value.lc == coal.lc &&
                                  value.invoice == coal.invoice) {
                                Hive.box('coals').delete(key);
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
        valueListenable: Hive.box('coals').listenable(),
        builder: (context, coalBox, _) {
          final coalBox = Hive.box('coals')
              .values
              .where((c) =>
                  c.lc.toLowerCase() == (widget.coalModel.lc.toLowerCase()))
              .toList();
          final Map coalMap = Hive.box('coals').toMap();
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
                        return buildSingleItem(coalBox[index], coalMap);
                      },
                      itemCount: coalBox.length,
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
                            builder: (context) => SingleCoalEntryScreen(
                                  coalModel: widget.coalModel,
                                )));
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
        title: Text("LC Number ${widget.coalModel.lc}"),
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
              SizedBox(
                height: 20,
              ),
              rateField,
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
      floatingActionButton: _getFAB(),
    );
  }

  void AddData() {
    if (_formKey.currentState!.validate()) {
      final coalBox = Hive.box('coals');
      final _totalPrice = (double.parse(_totalStock.toString()) *
              double.parse(rateEditingController.text))
          .toString();
      //final _totalBalance = (double.parse(_purchaseBalance) + double.parse(lcOpenPriceEditingController.text) + double.parse(dutyCostEditingController.text) + double.parse(speedMoneyEditingController.text)).toString();
      final coalModel = Coal(
          widget.coalModel.lc,
          "LC Closed",
          "0",
          widget.coalModel.supplierName,
          widget.coalModel.port,
          "0",
          rateEditingController.text,
          _totalPrice,
          "LC Closed",
          "LC Closed",
          _totalPrice,
          "0",
          "LC Closed",
          widget.coalModel.date,
          "LC Closed",
          "LC Closed",
          widget.coalModel.contact);

      coalBox.add(coalModel);
      final tempBox = Hive.box('coals').values.where(
          (c) => c.lc.toLowerCase() == (widget.coalModel.lc.toLowerCase()));

      final tempItem = tempBox.last as Coal;
      if (double.parse(tempItem.totalPrice) > 0) {
        setState(() {
          _totalAmount = double.parse(tempItem.totalPrice);
          disFAB = true;
          rateEditingController.clear();
          final companyModel = Company(
              "coalstock" + widget.coalModel.lc,
              widget.coalModel.supplierName,
              "0",
              "0",
              _totalPrice,
              "0",
              "Coal Purchase :" + widget.coalModel.lc,
              "2",
              "0",
              "0",
              widget.coalModel.date,
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
    final _list = <CoalItem>[];
    final coalBox = Hive.box('coals')
        .values
        .where((c) => c.lc.toLowerCase() == widget.coalModel.lc)
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

    final invoice = InvoiceCoal(_totalStock.toString(), _totalAmount.toString(),
        widget.coalModel.lc, _list);

    final pdfFile = await PdfCoal.generate(invoice, false);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green, content: Text("Pdf Generated!!")));
  }
}
