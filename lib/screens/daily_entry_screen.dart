import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/model/daily.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/daily_coal_screen.dart';
import 'package:importmanagementsoftware/screens/single_company_screen.dart';
import 'package:importmanagementsoftware/screens/single_employee_screen.dart';
import 'package:intl/intl.dart';

import '../model/company.dart';
import '../model/employee.dart';
import 'daily_crusher_screen.dart';
import 'daily_stone_screen.dart';
import 'individual_lc_history_screen.dart';

class DailyEntryScreen extends StatefulWidget {
  const DailyEntryScreen({Key? key}) : super(key: key);

  @override
  _DailyEntryScreenState createState() => _DailyEntryScreenState();
}

class _DailyEntryScreenState extends State<DailyEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final transportEditingController = new TextEditingController();
  final unloadEditingController = new TextEditingController();
  final depoRentEditingController = new TextEditingController();
  final koipotEditingController = new TextEditingController();
  final stoneCraftingEditingController = new TextEditingController();
  final disselCostEditingController = new TextEditingController();
  final grissCostEditingController = new TextEditingController();
  final mobilCostEditingController = new TextEditingController();
  final extraEditingController = new TextEditingController();
  final remarksEditingController = new TextEditingController();
  DateTime? _date;
  final _costTypes = ['Coal', 'Stone', 'Crusher', 'Company', 'Employee'];
  String? _chosenCost;
  bool? _process;
  int? _count;

  bool _selection = false;
  bool _isCompany = false;

  String _selectionString = "Credit";
  String _debit = "0";
  String _credit = "0";
  final _paymentTypes = ['Cash', 'Bank'];
  String? _chosenPayment;
  final debitCreditEditingController = new TextEditingController();
  final paymentInformationEditingController = new TextEditingController();
  List<String> _companyNameList = [];
  String? _chosenCompanyName;

  bool _isEmployee = false;
  final salaryAdvancedEditingController = new TextEditingController();
  final salaryGivenEditingController = new TextEditingController();
  int? _invoice;
  List<String> _employeeNameList = [];
  String? _chosenEmployeeName;
  String? salary;
  String? post;

  @override
  void initState() {
    super.initState();
    _process = false;
    _count = 1;

    final _tempCompanyList = Hive.box('companies')
        .values
        .where((c) => c.invoice.toLowerCase() == ("1"))
        .toList();
    for (int i = 0; i < _tempCompanyList.length; i++) {
      final _tempCompany = _tempCompanyList[i] as Company;
      _companyNameList.add(_tempCompany.name);
    }

    final _tempEmployeeList = Hive.box('employees')
        .values
        .where((c) => c.invoice.toLowerCase() == ("1"))
        .toList();
    for (int i = 0; i < _tempEmployeeList.length; i++) {
      final _tempEmployee = _tempEmployeeList[i] as Employee;
      _employeeNameList.add(_tempEmployee.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final salaryAdvancedField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            cursorColor: Colors.blue,
            autofocus: false,
            controller: salaryAdvancedEditingController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              salaryAdvancedEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Salary Advanced',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final salaryGivenField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: salaryGivenEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              salaryGivenEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Salary Given',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    DropdownMenuItem<String> buildMenuName(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: Colors.blue),
        ));

    final nameDropdown = Container(
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
            items: _companyNameList.map(buildMenuName).toList(),
            hint: Text(
              'Select Client/Supplier',
              style: TextStyle(color: Colors.blue),
            ),
            value: _chosenCompanyName,
            onChanged: (newValue) {
              setState(() {
                _chosenCompanyName = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuEmployee(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: Colors.blue),
        ));

    final employeeDropdown = Container(
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
            items: _employeeNameList.map(buildMenuEmployee).toList(),
            hint: Text(
              'Select Employee',
              style: TextStyle(color: Colors.blue),
            ),
            value: _chosenEmployeeName,
            onChanged: (newValue) {
              setState(() {
                _chosenEmployeeName = newValue;

                final _tempEmployeeList = Hive.box('employees')
                    .values
                    .where((c) => c.invoice.toLowerCase().contains("1"))
                    .toList();
                for (int i = 0; i < _tempEmployeeList.length; i++) {
                  final _tempEmployee = _tempEmployeeList[i] as Employee;
                  if (_tempEmployee.name == (newValue!)) {
                    salary = _tempEmployee.salary;
                    post = _tempEmployee.post;
                  }
                }
              });
            }));

    final paymentInformationField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: paymentInformationEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (_chosenPayment == "") {
                return ("Payment Type required!!");
              } else if (_chosenPayment == 'Bank') {
                if (value!.isEmpty) {
                  return ("Payment Information cannot be empty!!");
                }
              }
              return null;
            },
            onSaved: (value) {
              paymentInformationEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Payment Information',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final debitCreditField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: false,
            controller: debitCreditEditingController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              debitCreditEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Debit/Credit',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    DropdownMenuItem<String> buildPaymentItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: Colors.blue),
        ));

    final paymentDropdown = Container(
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
            items: _paymentTypes.map(buildPaymentItem).toList(),
            hint: Text(
              'Select Payment',
              style: TextStyle(color: Colors.blue),
            ),
            value: _chosenPayment,
            onChanged: (newValue) {
              setState(() {
                _chosenPayment = newValue;
              });
            }));

    final checkField = Checkbox(
      activeColor: Colors.transparent,
      side: BorderSide(color: Colors.blue),
      checkColor: Colors.blue,
      onChanged: (bool? value) {
        setState(() {
          _selection = value!;
          if (_selection) {
            _selectionString = "Debit";
          } else {
            _selectionString = "Credit";
          }
        });
      },
      value: _selection,
    );
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

    final transportField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: false,
            controller: transportEditingController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              transportEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Transport Cost',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final unloadField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: false,
            controller: unloadEditingController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              unloadEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Unload Cost',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));
    final depoRentField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: false,
            controller: depoRentEditingController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              depoRentEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Depo Rent Cost',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));
    final koipotField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: false,
            controller: koipotEditingController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              koipotEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Koipot Cost',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));
    final stoneCraftingField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: false,
            controller: stoneCraftingEditingController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              stoneCraftingEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Stone Crafting Cost',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));
    final disselCostField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: false,
            controller: disselCostEditingController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              disselCostEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Dissel Cost',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));
    final grissField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: false,
            controller: grissCostEditingController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              grissCostEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Griss Cost',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));
    final mobilField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: false,
            controller: mobilCostEditingController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              mobilCostEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Mobil Cost',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));
    final extraField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: false,
            controller: extraEditingController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              extraEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Extra Cost',
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
                _isCompany
                    ? "Add New Payment"
                    : _isEmployee
                        ? "Add new Payment"
                        : 'Add New Cost',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
      ),
    );

    DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: Colors.blue),
        ));

    final costDropdown = Container(
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
            items: _costTypes.map(buildMenuItem).toList(),
            hint: Text(
              'Select Cost Type',
              style: TextStyle(color: Colors.blue),
            ),
            value: _chosenCost,
            onChanged: (newValue) {
              setState(() {
                _chosenCost = newValue;
                if (_chosenCost == "Company") {
                  _isCompany = true;
                  _isEmployee = false;
                } else if (_chosenCost == "Employee") {
                  _isCompany = false;
                  _isEmployee = true;
                } else {
                  _isCompany = false;
                  _isEmployee = false;
                }

                if (_chosenCost == "Coal") {
                  final tempDaily = Hive.box('daily')
                      .values
                      .where((c) => c.invoice.toLowerCase().contains("coal"))
                      .toList();
                  if (tempDaily.isEmpty) {
                    setState(() {
                      _invoice = 1;
                    });
                  } else {
                    setState(() {
                      _invoice = int.parse(tempDaily.last.invoice) + 1;
                    });
                  }
                } else if (_chosenCost == "Stone") {
                  final tempDaily = Hive.box('daily')
                      .values
                      .where((c) => c.invoice.toLowerCase().contains("stone"))
                      .toList();
                  if (tempDaily.isEmpty) {
                    setState(() {
                      _invoice = 1;
                    });
                  } else {
                    setState(() {
                      _invoice = int.parse(tempDaily.last.invoice) + 1;
                    });
                  }
                } else if (_chosenCost == "Crusher") {
                  final tempDaily = Hive.box('daily')
                      .values
                      .where((c) => c.invoice.toLowerCase().contains("crusher"))
                      .toList();
                  if (tempDaily.isEmpty) {
                    setState(() {
                      _invoice = 1;
                    });
                  } else {
                    setState(() {
                      _invoice = int.parse(tempDaily.last.invoice) + 1;
                    });
                  }
                }
              });
            }));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_isCompany ? "Add New Payment" : "Add New Cost"),
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
                        costDropdown,
                        pickDate,
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _isCompany
                            ? nameDropdown
                            : _isEmployee
                                ? employeeDropdown
                                : transportField,
                        _isCompany
                            ? Text('')
                            : _isEmployee
                                ? Text(
                                    "Salary : $salary",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  )
                                : unloadField
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _isCompany
                            ? Row(
                                children: [
                                  checkField,
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    _selectionString,
                                    style: TextStyle(color: Colors.blue),
                                  )
                                ],
                              )
                            : _isEmployee
                                ? salaryAdvancedField
                                : depoRentField,
                        _isCompany
                            ? debitCreditField
                            : _isEmployee
                                ? salaryGivenField
                                : koipotField
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _isEmployee
                        ? remarksField
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _isCompany ? paymentDropdown : stoneCraftingField,
                              _isCompany
                                  ? paymentInformationField
                                  : disselCostField
                            ],
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    _isCompany
                        ? remarksField
                        : _isEmployee
                            ? addButton
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [grissField, mobilField],
                              ),
                    SizedBox(
                      height: 20,
                    ),
                    _isCompany
                        ? addButton
                        : _isEmployee
                            ? Text("")
                            : extraField,
                    _isCompany
                        ? SizedBox(
                            height: 10,
                          )
                        : SizedBox(
                            height: 20,
                          ),
                    _isCompany
                        ? Text('')
                        : _isEmployee
                            ? Text("")
                            : remarksField,
                    _isCompany
                        ? Text('')
                        : _isEmployee
                            ? Text("")
                            : SizedBox(
                                height: 20,
                              ),
                    _isCompany
                        ? Text('')
                        : _isEmployee
                            ? Text("")
                            : addButton,
                    _isCompany
                        ? Text('')
                        : _isEmployee
                            ? Text("")
                            : SizedBox(
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
    if (_formKey.currentState!.validate() &&
        _date != null &&
        _chosenCost != null &&
        _chosenCost != "Company" &&
        _chosenCost != "Employee") {
      final dailyBox = Hive.box('daily');
      final _total = double.parse(transportEditingController.text) +
          double.parse(unloadEditingController.text) +
          double.parse(depoRentEditingController.text) +
          double.parse(koipotEditingController.text) +
          double.parse(stoneCraftingEditingController.text) +
          double.parse(disselCostEditingController.text) +
          double.parse(grissCostEditingController.text) +
          double.parse(mobilCostEditingController.text) +
          double.parse(extraEditingController.text);
      final dailyModel = Daily(
          _chosenCost! + _invoice.toString(),
          DateFormat('dd-MMM-yyyy').format(_date!),
          transportEditingController.text,
          unloadEditingController.text,
          depoRentEditingController.text,
          koipotEditingController.text,
          stoneCraftingEditingController.text,
          disselCostEditingController.text,
          grissCostEditingController.text,
          mobilCostEditingController.text,
          _total.toString(),
          extraEditingController.text,
          remarksEditingController.text,
          DateFormat('MMM-yyyy').format(_date!));
      dailyBox.add(dailyModel);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green, content: Text("Entry Added!!")));
      setState(() {
        _process = false;
        _count = 1;
      });
      if (_chosenCost == "Coal") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DailyCoalScreen()));
      } else if (_chosenCost == "Stone") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DailyStoneScreen()));
      } else if (_chosenCost == "Crusher") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DailyCrusherScreen()));
      }
    } else if (_formKey.currentState!.validate() &&
        _chosenCost == "Company" &&
        _date != null) {
      final companyBox = Hive.box('companies');
      if (_selection) {
        _debit = debitCreditEditingController.text;
      } else {
        _credit = debitCreditEditingController.text;
      }
      final companyModel = Company(
          "check",
          _chosenCompanyName!,
          "0",
          "0",
          _credit,
          _debit,
          remarksEditingController.text,
          _invoice.toString(),
          _chosenPayment!,
          paymentInformationEditingController.text,
          DateFormat('dd-MMM-yyyy').format(_date!),
          DateFormat('MMM-yyyy').format(_date!));
      companyBox.add(companyModel);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green, content: Text("Entry Added!!")));
      setState(() {
        _process = false;
        _count = 1;
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SingleCompanyScreen(companyModel: companyModel)));
    } else if (_formKey.currentState!.validate() &&
        _chosenCost == "Employee" &&
        _date != null) {
      final employeeBox = Hive.box('employees');
      final employeeModel = Employee(
          DateFormat('dd-MMM-yyyy').format(_date!),
          _chosenEmployeeName!,
          post!,
          salary!,
          salaryAdvancedEditingController.text,
          salaryGivenEditingController.text,
          "0",
          remarksEditingController.text,
          _invoice.toString(),
          "0",
          "0",
          DateFormat('MMM-yyyy').format(_date!));

      employeeBox.add(employeeModel);
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
              builder: (context) =>
                  SingleEmployeeScreen(employeeModel: employeeModel)));
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
