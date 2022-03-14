import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/model/cstock.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/individual_lc_history_screen.dart';
import 'package:importmanagementsoftware/screens/lc_new_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../model/coal.dart';
import '../model/csale.dart';
import '../model/stone.dart';
import 'individual_lc_entry_screen.dart';

class ProfitLossScreen extends StatefulWidget {
  const ProfitLossScreen({Key? key}) : super(key: key);

  @override
  _ProfitLossScreenState createState() => _ProfitLossScreenState();
}

class _ProfitLossScreenState extends State<ProfitLossScreen> {

  double _profit = 0.0;
  double _loss = 0.0;
  final _costTypes = ['Coal', 'Stone', 'Crusher'];
  String? _chosenCost;
  final _timeTypes = ['Monthly', 'Yearly'];
  String? _chosenTime;
  DateTime? _date;
  bool? _process;
  int? _count;

  final _portTypes = ['Shutarkandi', 'Tamabil'];
  String? _chosenPort;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _process = false;
    _count = 1;
  }

  @override
  Widget build(BuildContext context) {
    final pickDate = Container(
      child: Row(
        children: [
          SizedBox(
            width: 50,
          ),
          Text(
            'Time   :',
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
              minWidth: MediaQuery.of(context).size.width / 5,
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
                    ? 'Pick Time'
                    : (_chosenTime == null) ? 'Select Calculation Time' : (_chosenTime == 'Monthly') ? DateFormat('MMM-yyyy').format(_date!) : DateFormat('yyyy').format(_date!),
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
    DropdownMenuItem<String> buildMenuItem(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.blue),
            ));

    final typeDropdown = Container(
        width: MediaQuery
            .of(context)
            .size
            .width / 4,
        child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            items: _costTypes.map(buildMenuItem).toList(),
            hint: Text(
              'Select Cost Type',
              style: TextStyle(color: Colors.blue),
            ),
            value: _chosenCost,
            onChanged: (newValue) {
              setState(() {
                _chosenCost = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuTime(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.blue),
            ));

    final timeDropdown = Container(
        width: MediaQuery
            .of(context)
            .size
            .width / 4,
        child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            items: _timeTypes.map(buildMenuTime).toList(),
            hint: Text(
              'Select Calculation Type',
              style: TextStyle(color: Colors.blue),
            ),
            value: _chosenTime,
            onChanged: (newValue) {
              setState(() {
                _chosenTime = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuPort(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: Colors.blue),
        ));

    final portDropdown = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            items: _portTypes.map(buildMenuPort).toList(),
            hint: Text(
              'Select Port',
              style: TextStyle(color: Colors.blue),
            ),
            value: _chosenPort,
            onChanged: (newValue) {
              setState(() {
                _chosenPort = newValue;
              });
            }));

    final addButton = Material(
      elevation: (_process!)? 0 : 5,
      color: (_process!)? Colors.blue.shade800 :Colors.blue,
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
          (_count! < 0) ?      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red,content: Text("Wait Please!!")))
              :
          AddData();
        },
        child:(_process!)? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Processing',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
            ),
            SizedBox(width: 20,),
            Center(child: SizedBox(height:15, width: 15,child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,))),
          ],
        )
            : Text(
          'Get Profit / Loss',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profit / Loss'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                timeDropdown,
                typeDropdown,
                pickDate,

              ],
            ),
          ),
          (_chosenCost == 'Crusher') ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: portDropdown,
          ): Text(''),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: addButton,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(),
          ),
          Container(
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
                            "Profit",
                            style: TextStyle(color: Colors.blue, fontSize: 20),
                          ),
                          Text(
                            _profit.toString(),
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
                            "Loss",
                            style: TextStyle(color: Colors.blue, fontSize: 20),
                          ),
                          Text(
                            _loss.toString(),
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void AddData() {
    if(_date != null && _chosenTime != null && _chosenCost != null) {
      if(_chosenCost=='Coal'){
        if(_chosenTime == 'Monthly'){
          var _amount = 0.0;
          final tempCoalBox = Hive.box('coals')
              .values
              .toList();
          for (var i = 0; i < tempCoalBox.length; i++) {
            final _temp = tempCoalBox[i] as Coal;
            if(_temp.year.contains(DateFormat('MMM-yyyy').format(_date!))){
              _amount = _amount + double.parse(_temp.debit) - double.parse(_temp.credit);
              if(_amount < 0){
                setState(() {
                  _loss = _amount;
                  _process = false;
                  _count = 1;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Updated!!")));
              }else{
               setState(() {
                 _profit = _amount;
                 _process = false;
                 _count = 1;
               });
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Updated!!")));
              }
            } 
          }
        }
        else if(_chosenTime == 'Yearly'){
          var _amount = 0.0;
          final tempCoalBox = Hive.box('coals')
              .values
              .toList();
          for (var i = 0; i < tempCoalBox.length; i++) {
            final _temp = tempCoalBox[i] as Coal;
            if(_temp.year.contains(DateFormat('yyyy').format(_date!))){
              _amount = _amount + double.parse(_temp.debit) - double.parse(_temp.credit);
              if(_amount < 0){
                setState(() {
                  _loss = _amount;
                  _process = false;
                  _count = 1;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Updated!!")));
              }else{
                setState(() {
                  _profit = _amount;
                  _process = false;
                  _count = 1;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Updated!!")));
              }
            } 
          }
        }
      }
      else if(_chosenCost=='Stone'){
        if(_chosenTime == 'Monthly'){
          var _amount = 0.0;
          final tempLCBox = Hive.box('lcs')
              .values
              .toList();
          for (var i = 0; i < tempLCBox.length; i++) {
            final _temp = tempLCBox[i] as LC;
            if(_temp.year.contains(DateFormat('MMM-yyyy').format(_date!))){
              _amount = _amount - double.parse(_temp.totalBalance);
            } 
          }

          final tempStoneBox = Hive.box('stones')
              .values
              .toList();
          for (var i = 0; i < tempStoneBox.length; i++) {
            final _temp = tempStoneBox[i] as Stone;
            if(_temp.year.contains(DateFormat('MMM-yyyy').format(_date!))){
              _amount = _amount + double.parse(_temp.totalSale);
            } 
          }

          if(_amount < 0){
            setState(() {
              _loss = _amount;
              _process = false;
              _count = 1;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Updated!!")));
          }else{
            setState(() {
              _profit = _amount;
              _process = false;
              _count = 1;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Updated!!")));
          }
        }
        else if(_chosenTime == 'Yearly'){
          var _amount = 0.0;
          final tempLCBox = Hive.box('lcs')
              .values
              .toList();
          for (var i = 0; i < tempLCBox.length; i++) {
            final _temp = tempLCBox[i] as LC;
            if(_temp.year.contains(DateFormat('yyyy').format(_date!))){
              _amount = _amount + double.parse(_temp.totalBalance);
            } 
          }

          final tempStoneBox = Hive.box('stones')
              .values
              .toList();
          for (var i = 0; i < tempStoneBox.length; i++) {
            final _temp = tempStoneBox[i] as Stone;
            if(_temp.year.contains(DateFormat('yyyy').format(_date!))){
              _amount = _amount - double.parse(_temp.totalSale);
            } 
          }

          if(_amount < 0){
            setState(() {
              _loss = _amount;
              _process = false;
              _count = 1;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Updated!!")));
          }else{
            setState(() {
              _profit = _amount;
              _process = false;
              _count = 1;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Updated!!")));
          }
        }
      }
      else{
        if(_chosenPort == 'Shutarkandi'){
          if(_chosenTime == 'Monthly'){
            var _amount = 0.0;
            final tempStockBox = Hive.box('cStocks').values.where((c) => c.port
                .toLowerCase()
                .contains("shutarkandi")).toList();
            for (var i = 0; i < tempStockBox.length; i++) {
              final _temp = tempStockBox[i] as CStock;
              if(_temp.year.contains(DateFormat('MMM-yyyy').format(_date!))){
                _amount = _amount - double.parse(_temp.price);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red,content: Text("No Data Found!!")));
              }
            }

            final tempSaleBox = Hive.box('cSales').values.where((c) => c.port
                .toLowerCase()
                .contains("shutarkandi")).toList();
            for (var i = 0; i < tempSaleBox.length; i++) {
              final _temp = tempSaleBox[i] as CSale;
              if(_temp.year.contains(DateFormat('MMM-yyyy').format(_date!))){
                _amount = _amount + double.parse(_temp.price);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red,content: Text("No Data Found!!")));
              }
            }

            if(_amount < 0){
              setState(() {
                _loss = _amount;
                _process = false;
                _count = 1;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Updated!!")));
            }else{
              setState(() {
                _profit = _amount;
                _process = false;
                _count = 1;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Updated!!")));
            }
          }
          else if(_chosenTime == 'Yearly'){
            var _amount = 0.0;
            final tempStockBox = Hive.box('cStocks').values.where((c) => c.port
                .toLowerCase()
                .contains("shutarkandi")).toList();
            for (var i = 0; i < tempStockBox.length; i++) {
              final _temp = tempStockBox[i] as CStock;
              if(_temp.year.contains(DateFormat('yyyy').format(_date!))){
                _amount = _amount - double.parse(_temp.price);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red,content: Text("No Data Found!!")));
              }
            }

            final tempSaleBox = Hive.box('cSales').values.where((c) => c.port
                .toLowerCase()
                .contains("shutarkandi")).toList();
            for (var i = 0; i < tempSaleBox.length; i++) {
              final _temp = tempSaleBox[i] as CSale;
              if(_temp.year.contains(DateFormat('yyyy').format(_date!))){
                _amount = _amount + double.parse(_temp.price);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red,content: Text("No Data Found!!")));
              }
            }

            if(_amount < 0){
              setState(() {
                _loss = _amount;
                _process = false;
                _count = 1;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Updated!!")));
            }else{
              setState(() {
                _profit = _amount;
                _process = false;
                _count = 1;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Updated!!")));
            }
          }
        }
        else if(_chosenPort == 'tamabil'){
          if(_chosenTime == 'Monthly'){
            var _amount = 0.0;
            final tempStockBox = Hive.box('cStocks').values.where((c) => c.port
                .toLowerCase()
                .contains("tamabil")).toList();
            for (var i = 0; i < tempStockBox.length; i++) {
              final _temp = tempStockBox[i] as CStock;
              if(_temp.year.contains(DateFormat('MMM-yyyy').format(_date!))){
                _amount = _amount - double.parse(_temp.price);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red,content: Text("No Data Found!!")));
              }
            }

            final tempSaleBox = Hive.box('cSales').values.where((c) => c.port
                .toLowerCase()
                .contains("tamabil")).toList();
            for (var i = 0; i < tempSaleBox.length; i++) {
              final _temp = tempSaleBox[i] as CSale;
              if(_temp.year.contains(DateFormat('MMM-yyyy').format(_date!))){
                _amount = _amount + double.parse(_temp.price);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red,content: Text("No Data Found!!")));
              }
            }

            if(_amount < 0){
              setState(() {
                _loss = _amount;
                _process = false;
                _count = 1;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Updated!!")));
            }else{
              setState(() {
                _profit = _amount;
                _process = false;
                _count = 1;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Updated!!")));
            }
          }
          else if(_chosenTime == 'Yearly'){
            var _amount = 0.0;
            final tempStockBox = Hive.box('cStocks').values.where((c) => c.port
                .toLowerCase()
                .contains("tamabil")).toList();
            for (var i = 0; i < tempStockBox.length; i++) {
              final _temp = tempStockBox[i] as CStock;
              if(_temp.year.contains(DateFormat('yyyy').format(_date!))){
                _amount = _amount - double.parse(_temp.price);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red,content: Text("No Data Found!!")));
              }
            }

            final tempSaleBox = Hive.box('cSales').values.where((c) => c.port
                .toLowerCase()
                .contains("tamabil")).toList();
            for (var i = 0; i < tempSaleBox.length; i++) {
              final _temp = tempSaleBox[i] as CSale;
              if(_temp.year.contains(DateFormat('yyyy').format(_date!))){
                _amount = _amount + double.parse(_temp.price);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red,content: Text("No Data Found!!")));
              }
            }

            if(_amount < 0){
              setState(() {
                _loss = _amount;
                _process = false;
                _count = 1;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Updated!!")));
            }else{
              setState(() {
                _profit = _amount;
                _process = false;
                _count = 1;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Updated!!")));
            }
          }
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red,content: Text("Please choose any port!!")));
        }
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red,content: Text("Something Wrong!!")));
      setState(() {
        _process = false;
        _count = 1;
      });
    }
  }
}
