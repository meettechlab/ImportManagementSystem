import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/model/coal.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/single_coal_lc_screen.dart';
import 'package:intl/intl.dart';

import 'individual_lc_history_screen.dart';

class SingleCoalEntryScreen extends StatefulWidget {
  final Coal coalModel;

  const SingleCoalEntryScreen({Key? key, required this.coalModel})
      : super(key: key);

  @override
  _SingleCoalEntryScreenState createState() => _SingleCoalEntryScreenState();
}

class _SingleCoalEntryScreenState extends State<SingleCoalEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  //final lcNumberEditingController = new TextEditingController();
  String? _lcNumber;
  final portEditingController = new TextEditingController();
  final tonEditingController = new TextEditingController();
  final remarksEditingController = new TextEditingController();
  final truckCountEditingController = new TextEditingController();
  final truckNumberEditingController = new TextEditingController();

  DateTime? _date;
  bool? _process;
  int? _count;
  int? _invoice;

  @override
  void initState() {
    super.initState();
    _process = false;
    _count = 1;
    final tempCoalBox = Hive.box('coals').values;
    if (tempCoalBox.isEmpty) {
      setState(() {
        _invoice = 1;
      });
    } else {
      setState(() {
        _invoice = int.parse(tempCoalBox.last.invoice) + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final truckCountField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            cursorColor: Colors.blue,
            autofocus: false,
            controller: truckCountEditingController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("No Of Truck cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              truckCountEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'No of Trucks',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final truckNumberField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: truckNumberEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Truck Plate Number cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              truckNumberEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Truck Plate Number',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));
    final pickDate = Container(
      child: Row(
        children: [
          SizedBox(
            width: 50,
          ),
          Text(
            'Date   :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Material(
            elevation: 5,
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              padding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              minWidth: MediaQuery.of(context).size.width / 6,
              onPressed: () {
                showDatePicker(
                  context: context,
                  firstDate: DateTime(1990, 01),
                  lastDate: DateTime(2101),
                  initialDate: _date ?? DateTime.now(),
                ).then((value) {
                  setState(() {
                    _date = value;
                  });
                });
              },
              child: Text(
                (_date == null)
                    ? 'Pick Date'
                    : DateFormat('dd-MMM-yyyy').format(_date!),
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );

    final portField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: portEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Port cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              portEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Port',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final tonField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: false,
            controller: tonEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Ton cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              tonEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Ton',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final remarksField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            maxLines: 3,
            cursorColor: Colors.blue,
            autofocus: false,
            controller: remarksEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              return null;
            },
            onSaved: (value) {
              remarksEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Remarks',
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
          150,
          35,
          150,
          35,
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
                'Add New Entry',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("LC Number ${widget.coalModel.lc}"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "LC Number : ${widget.coalModel.lc}",
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ),
                        pickDate,
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [tonField, portField],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [truckCountField, truckNumberField],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    remarksField,
                    SizedBox(
                      height: 20,
                    ),
                    addButton,
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void AddData() {
    if (_formKey.currentState!.validate() && _date != null) {
      final coalBox = Hive.box('coals');

      final coalModel = Coal(
          widget.coalModel.lc,
          DateFormat('dd-MMM-yyyy').format(_date!),
          _invoice.toString(),
          widget.coalModel.supplierName,
          portEditingController.text,
          tonEditingController.text,
          "0",
          "0",
          "0",
          "0",
          "0",
          "0",
          remarksEditingController.text,
          DateFormat('MMM-yyyy').format(_date!),
          truckCountEditingController.text,
          truckNumberEditingController.text,
          widget.coalModel.contact);

      coalBox.add(coalModel);
      setState(() {
        _process = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green, content: Text("Entry Added!!")));
      setState(() {
        _process = false;
        _count = 1;
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SingleCoalLCScreen(coalModel: coalModel)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text("Something Wrong!!")));
      setState(() {
        _process = false;
        _count = 1;
      });
    }
  }
}
