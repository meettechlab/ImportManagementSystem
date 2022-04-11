import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/api/pdf_company.dart';
import 'package:importmanagementsoftware/model/employee.dart';
import 'package:importmanagementsoftware/model/invoiceCompany.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/company_payment_screen.dart';
import 'package:importmanagementsoftware/screens/company_update_screen.dart';
import 'package:importmanagementsoftware/screens/employee_salary_entry.dart';
import 'package:importmanagementsoftware/screens/individual_lc_entry_screen.dart';

import '../model/company.dart';

class SingleCompanyScreen extends StatefulWidget {
  final Company companyModel;

  const SingleCompanyScreen({Key? key, required this.companyModel})
      : super(key: key);

  @override
  _SingleCompanyScreenState createState() => _SingleCompanyScreenState();
}

class _SingleCompanyScreenState extends State<SingleCompanyScreen> {
  double _due = 0.0;

  @override
  void initState() {
    super.initState();

    final tempBox = Hive.box('companies').values.where((c) =>
        c.name.toLowerCase() == (widget.companyModel.name.toLowerCase()));
    final tempBoxList = tempBox.toList();
    for (var i = 0; i < tempBoxList.length; i++) {
      final _temp = tempBoxList[i] as Company;
      setState(() {
        _due = (_due - double.parse(_temp.credit) + double.parse(_temp.debit));
      });
    }
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CompanyPaymentScreen(
                          companyModel: widget.companyModel)));
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

  @override
  Widget build(BuildContext context) {
    Widget buildSingleItem(Company company, Map map) => Container(
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
                  SizedBox(
                    width: 70,
                  ),
                  (company.id == "check")
                      ? IconButton(
                          onPressed: () {
                            map.forEach((key, value) {
                              if (value.name == company.name &&
                                  value.invoice == company.invoice) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CompanyUpdateScreen(
                                              companyModel: company,
                                              k: key,
                                            )));
                              }
                            });
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.red,
                          ),
                        )
                      : Text(""),
                  (company.id == "check")
                      ? IconButton(
                          onPressed: () {
                            map.forEach((key, value) {
                              if (value.name == company.name &&
                                  value.invoice == company.invoice) {
                                Hive.box('companies').delete(key);
                              }
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )
                      : Text(""),
                ],
              ),
            ),
          ),
        );

    Widget _buildListView() {
      return ValueListenableBuilder(
        valueListenable: Hive.box('companies').listenable(),
        builder: (context, companyBox, _) {
          final companyBox = Hive.box('companies')
              .values
              .where((c) =>
                  c.name.toLowerCase() ==
                  (widget.companyModel.name.toLowerCase()))
              .toList();

          final Map companyMap = Hive.box('companies').toMap();
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
                        return buildSingleItem(companyBox[index], companyMap);
                      },
                      itemCount: companyBox.length,
                    );
        },
      );
    }

    ;

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
      floatingActionButton: _getFAB(),
    );
  }

  void generatePdf() async {
    final _list = <CompanyItem>[];
    final companyBox = Hive.box('companies')
        .values
        .where((c) =>
            c.name.toLowerCase() == (widget.companyModel.name.toLowerCase()))
        .toList();
    for (int i = 0; i < companyBox.length; i++) {
      final _temp = companyBox[i] as Company;
      _list.add(new CompanyItem(_temp.date, _temp.debit, _temp.credit,
          _temp.paymentTypes, _temp.paymentInfo, _temp.remarks));
    }

    final tempCompany = companyBox[0] as Company;
    final invoice = InvoiceCompany(tempCompany.name, tempCompany.contact,
        tempCompany.address, _due.toString(), _list);

    final pdfFile = await PdfCompany.generate(invoice);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green, content: Text("Pdf Generated!!")));
  }
}
