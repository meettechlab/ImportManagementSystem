import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/daily_entry_screen.dart';
import 'package:importmanagementsoftware/screens/individual_lc_history_screen.dart';
import 'package:importmanagementsoftware/screens/lc_new_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/screens/new_stone_sale_screen.dart';

import '../model/daily.dart';
import '../model/stone.dart';
import 'individual_lc_entry_screen.dart';

class DailyStoneScreen extends StatefulWidget {
  const DailyStoneScreen({Key? key}) : super(key: key);

  @override
  _DailyStoneScreenState createState() => _DailyStoneScreenState();
}

class _DailyStoneScreenState extends State<DailyStoneScreen> {

  double _totalCost = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final tempDailyBox =Hive.box('daily')
        .values
        .where((c) => c.invoice
        .toLowerCase()
        .contains("stone"))
        .toList();
    for (var i = 0; i < tempDailyBox.length; i++) {
      final _temp = tempDailyBox[i] as Daily;
      setState(() {
        _totalCost = (_totalCost + double.parse(_temp.totalBalance));

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'Daily Stone Cost'
        ),
      ),


      body: Column(
        children: [


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "Daily Cost : $_totalCost TK",
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => DailyEntryScreen()));
        },
        child:Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('daily').listenable(),
      builder: (context, dailyBox, _) {
        final dailyBox = Hive.box('daily')
            .values
            .where((c) => c.invoice
            .toLowerCase()
            .contains("stone"))
            .toList();
        return (dailyBox == null)
            ? Center(
          child: CircularProgressIndicator(),
        )
            : (dailyBox.isEmpty)
            ? Center(
          child: Text('No Entry'),
        )
            : ListView.builder(
          itemBuilder: (context, index) {
            return buildSingleItem(dailyBox[index]);
          },
          itemCount: dailyBox.length,
        );
      },
    );
  }


  Widget buildSingleItem(Daily daily) => Container(
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
                  style: TextStyle(color: Colors.blue,fontSize: 20),
                ),
                Text(
                  daily.date,
                  style: TextStyle(color: Colors.grey,fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Transport Cost",
                  style: TextStyle(color: Colors.blue,fontSize: 20),
                ),
                Text(
                  daily.transport,
                  style: TextStyle(color: Colors.grey,fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Unload Cost",
                  style: TextStyle(color: Colors.blue,fontSize: 20),
                ),
                Text(
                  daily.unload,
                  style: TextStyle(color: Colors.grey,fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Depo Rent Cost",
                  style: TextStyle(color: Colors.blue,fontSize: 20),
                ),
                Text(
                  daily.depoRent,
                  style: TextStyle(color: Colors.grey,fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Koipot",
                  style: TextStyle(color: Colors.blue,fontSize: 20),
                ),
                Text(
                  daily.koipot,
                  style: TextStyle(color: Colors.grey,fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Stone Crafting",
                  style: TextStyle(color: Colors.blue,fontSize: 20),
                ),
                Text(
                  daily.stoneCrafting,
                  style: TextStyle(color: Colors.grey,fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Dissel Cost",
                  style: TextStyle(color: Colors.blue,fontSize: 20),
                ),
                Text(
                  daily.disselCost,
                  style: TextStyle(color: Colors.grey,fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Griss Cost",
                  style: TextStyle(color: Colors.blue,fontSize: 20),
                ),
                Text(
                  daily.grissCost,
                  style: TextStyle(color: Colors.grey,fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Mobil Cost",
                  style: TextStyle(color: Colors.blue,fontSize: 20),
                ),
                Text(
                  daily.mobilCost,
                  style: TextStyle(color: Colors.grey,fontSize: 20),
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
                  style: TextStyle(color: Colors.blue,fontSize: 20),
                ),
                Text(
                  daily.extra,
                  style: TextStyle(color: Colors.grey,fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Total",
                  style: TextStyle(color: Colors.blue,fontSize: 20),
                ),
                Text(
                  daily.totalBalance,
                  style: TextStyle(color: Colors.grey,fontSize: 20),
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
                  style: TextStyle(color: Colors.blue,fontSize: 20),
                ),
                Text(
                  daily.remarks,
                  style: TextStyle(color: Colors.grey,fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
