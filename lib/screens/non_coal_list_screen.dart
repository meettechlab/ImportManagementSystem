import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/model/coal.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/model/nonstone.dart';
import 'package:importmanagementsoftware/screens/individual_lc_history_screen.dart';
import 'package:importmanagementsoftware/screens/lc_new_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/screens/non_stone_create_screen.dart';
import 'package:importmanagementsoftware/screens/non_stone_history_screen.dart';

import '../model/noncoal.dart';
import '../model/stone.dart';
import 'individual_lc_entry_screen.dart';
import 'non_coal_create_screen.dart';
import 'non_coal_history_screen.dart';

class NonCoalListScreen extends StatefulWidget {
  const NonCoalListScreen({Key? key}) : super(key: key);

  @override
  _NonCoalListScreenState createState() => _NonCoalListScreenState();
}

class _NonCoalListScreenState extends State<NonCoalListScreen> {
  final _formKey = GlobalKey<FormState>();
  final lcNumberEditingController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Non-LC Coal List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: _buildListView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NonCoalCreateScreen()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('noncoal').listenable(),
      builder: (context, lcBox, _) {
        final lcBox = Hive.box('noncoal')
            .values
            .where((c) => c.invoice.toLowerCase().contains("1"))
            .toList();
        final Map nonCoalMap = Hive.box('noncoal').toMap();
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
                      return buildSingleItem(lcBox[index], nonCoalMap);
                    },
                    itemCount: lcBox.length,
                  );
      },
    );
  }

  Widget buildSingleItem(NonCoal lc, Map map) => InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NonCoalHistoryScreen(
                        coalModel: lc,
                      )));
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  lc.lc,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        map.forEach((key, value) {
                          if (value.lc == lc.lc) {
                            Hive.box('noncoal').delete(key);
                          }
                        });
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => new AlertDialog(
                                  title:
                                      new Text('Enter the LC number to Save'),
                                  content: new Form(
                                    key: _formKey,
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        child: TextFormField(
                                            cursorColor: Colors.blue,
                                            autofocus: false,
                                            controller:
                                                lcNumberEditingController,
                                            keyboardType: TextInputType.name,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return ("LC Number cannot be empty!!");
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              lcNumberEditingController.text =
                                                  value!;
                                            },
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                20,
                                                15,
                                                20,
                                                15,
                                              ),
                                              labelText: 'LC Number',
                                              labelStyle:
                                                  TextStyle(color: Colors.blue),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: Colors.blue),
                                              ),
                                            ))),
                                  ),
                                  actions: <Widget>[
                                    new IconButton(
                                        icon: new Icon(Icons.close),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                    new IconButton(
                                        icon: new Icon(Icons.save),
                                        onPressed: () {
                                          AddData(lc, map);
                                        })
                                  ],
                                ));
                      },
                      icon: Icon(
                        Icons.save,
                        color: Colors.red,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  void AddData(NonCoal nonCoal, Map map) {
    if (_formKey.currentState!.validate()) {
      final _tempBox = Hive.box('noncoal').values.toList();
      for (int i = 0; i < _tempBox.length; i++) {
        final _temp = _tempBox[i] as NonCoal;
        if (_temp.lc == nonCoal.lc) {
          var _lcModel = Coal(
              lcNumberEditingController.text,
              _temp.date,
              _temp.invoice,
              _temp.supplierName,
              _temp.port,
              _temp.ton,
              _temp.rate,
              _temp.totalPrice,
              _temp.paymentType,
              _temp.paymentInformation,
              _temp.credit,
              _temp.debit,
              _temp.remarks,
              _temp.year,
              _temp.truckCount,
              _temp.truckNumber,
              _temp.contact);
          Hive.box('coals').add(_lcModel);
        }
      }

      map.forEach((key, value) {
        if (value.lc == nonCoal.lc) {
          Hive.box('noncoal').delete(key);
        }
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.green, content: Text("LC moved!!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text("Something Wrong!!")));
    }
  }
}
