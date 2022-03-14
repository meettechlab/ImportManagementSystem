import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/model/employee.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/company_payment_screen.dart';
import 'package:importmanagementsoftware/screens/employee_salary_entry.dart';
import 'package:importmanagementsoftware/screens/individual_lc_entry_screen.dart';

import '../model/company.dart';

class SingleCompanyScreen extends StatefulWidget {
  final Company companyModel;

  const SingleCompanyScreen({Key? key, required this.companyModel})
      : super(key: key);

  @override
  _SingleCompanyScreenState createState() =>
      _SingleCompanyScreenState();
}

class _SingleCompanyScreenState extends State<SingleCompanyScreen> {

  double _due = 0.0;

  @override
  void initState() {
    super.initState();

    final tempBox = Hive.box('companies')
        .values
        .where((c) => c.name
        .toLowerCase()
        .contains(widget.companyModel.name.toLowerCase()));
    final tempBoxList = tempBox.toList();
    for (var i = 0; i < tempBoxList.length; i++) {
      final _temp = tempBoxList[i] as Company;
      setState(() {
        _due = (double.parse(_due.toString()) - double.parse(_temp.credit) + double.parse(_temp.debit));
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    Widget buildSingleItem(Company company) =>
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
                        "Date",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                      Text(
                        company.date,
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
                        "Credit",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                      Text(
                        company.credit,
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
                        "Debit",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                      Text(
                        company.debit,
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
                        "Payment Type",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                      Text(
                        company.paymentTypes,
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
                        "Payment Information",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                      Text(
                        company.paymentInfo,
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
                        company.remarks,
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
        valueListenable: Hive.box('companies').listenable(),
        builder: (context, companyBox, _) {
          final companyBox = Hive
              .box('companies')
              .values
              .where((c) =>
              c.name
                  .toLowerCase()
                  .contains(widget.companyModel.name.toLowerCase()))
              .toList();
          return (companyBox == null)
              ? Center(
            child: CircularProgressIndicator(),
          )
              : (companyBox.isEmpty)
              ? Center(
            child: Text('No Transaction'),
          )
              : ListView.builder(
            itemBuilder: (context, index) {
              return buildSingleItem(companyBox[index]);
            },
            itemCount: companyBox.length,
          );
        },
      );
    };

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Client/Supplier Name : ${widget.companyModel.name}"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Client/Supplier Name : ${widget.companyModel.name}",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                Text(
                  "Contact : ${widget.companyModel.contact}",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),

                Text(
                  "Address : ${widget.companyModel.address}",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Due : $_due TK",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            ),
            Expanded(child: _buildListView()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CompanyPaymentScreen(companyModel: widget.companyModel)));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

}
