import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/model/nonstone.dart';
import 'package:importmanagementsoftware/screens/individual_lc_history_screen.dart';
import 'package:importmanagementsoftware/screens/lc_new_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/screens/non_stone_create_screen.dart';
import 'package:importmanagementsoftware/screens/non_stone_history_screen.dart';

import '../model/stone.dart';
import 'individual_lc_entry_screen.dart';

class NonStoneListScreen extends StatefulWidget {
  const NonStoneListScreen({Key? key}) : super(key: key);

  @override
  _NonStoneListScreenState createState() => _NonStoneListScreenState();
}

class _NonStoneListScreenState extends State<NonStoneListScreen> {
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
        title: Text(
            'Non-LC Stone List'
        ),
      ),


      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child:  _buildListView(),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NonStoneCreateScreen()));
        },
        child:Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('nonstone').listenable(),
      builder: (context, lcBox, _) {
        final lcBox = Hive.box('nonstone')
            .values
            .where((c) => c.invoice
            .toLowerCase()
            .contains("1"))
            .toList();
        final Map nonStoneMap = Hive.box('nonstone').toMap();
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
            return buildSingleItem(lcBox[index], nonStoneMap);
          },
          itemCount: lcBox.length,
        );
      },
    );
  }


  Widget buildSingleItem(NonStone lc, Map map) => InkWell(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => NonStoneHistoryScreen(lcModel: lc)));
    },
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 20,),
            Text(
              lc.lcNumber,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 25,
                  fontWeight: FontWeight.bold
              ),
            ),

            IconButton(
              onPressed: (){
                showDialog(
                    context: context,
                    builder: (BuildContext context) => new AlertDialog(
                      title: new Text('Enter the LC number to Save'),
                      content:new Form(
                        key: _formKey,
                        child: Container(
                            width: MediaQuery.of(context).size.width / 4,
                            child: TextFormField(
                                cursorColor: Colors.blue,
                                autofocus: false,
                                controller: lcNumberEditingController,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return ("LC Number cannot be empty!!");
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  lcNumberEditingController.text = value!;
                                },
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                    20,
                                    15,
                                    20,
                                    15,
                                  ),
                                  labelText: 'LC Number',
                                  labelStyle: TextStyle(color: Colors.blue),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.blue),
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
                              AddData(lc,map);
                            })
                      ],
                    ));
              },
              icon: Icon(Icons.save, color: Colors.red, size: 20,),
            )
          ],
        ),
      ),
    ),
  );

  void AddData(NonStone nonStone, Map map){
    if(_formKey.currentState!.validate()) {
      final _tempBox = Hive
          .box('nonstone')
          .values
          .toList();
      for (int i = 0; i < _tempBox.length; i++) {
        final _temp = _tempBox[i] as NonStone;
        if (_temp.lcNumber == nonStone.lcNumber) {
          var _lcModel = LC(
              _temp.date,
              _temp.truckCount,
              _temp.truckNumber,
              _temp.invoice,
              _temp.port,
              _temp.cft,
              _temp.rate,
              _temp.stockBalance,
              _temp.sellerName,
              _temp.sellerContact,
              _temp.paymentType,
              _temp.paymentInformation,
              _temp.purchaseBalance,
              _temp.lcOpenPrice,
              _temp.dutyCost,
              _temp.speedMoney,
              _temp.remarks,
              lcNumberEditingController.text,
              _temp.totalBalance,
              _temp.year);
          Hive.box('lcs').add(_lcModel);
        }
      }

      map.forEach((key, value) {
        if (value.lcNumber == nonStone.lcNumber) {
          Hive.box('nonstone').delete(key);
        }
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("LC moved!!")));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red,content: Text("Something Wrong!!")));
    }
  }
}

