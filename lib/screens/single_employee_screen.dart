import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/api/pdf_employee.dart';
import 'package:importmanagementsoftware/model/employee.dart';
import 'package:importmanagementsoftware/model/invoiceEmployee.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/employee_salary_entry.dart';
import 'package:importmanagementsoftware/screens/employee_salary_update.dart';
import 'package:importmanagementsoftware/screens/individual_lc_entry_screen.dart';

class SingleEmployeeScreen extends StatefulWidget {
  final Employee employeeModel;

  const SingleEmployeeScreen({Key? key, required this.employeeModel})
      : super(key: key);

  @override
  _SingleEmployeeScreenState createState() =>
      _SingleEmployeeScreenState();
}

class _SingleEmployeeScreenState extends State<SingleEmployeeScreen> {

  int _balance = 0;
  int _due = 0;
  int _salary = 0;
  final _formKey = GlobalKey<FormState>();
  final salaryEditingController = new TextEditingController();
  bool isSalaryFieldOpened = false;


  @override
  void initState() {
    super.initState();
    _salary = int.parse(widget.employeeModel.salary);

    final tempBox = Hive
        .box('employees')
        .values
        .where((c) =>
        c.name
            .toLowerCase()==(widget.employeeModel.name.toLowerCase()))
        .toList();
    for (var i = 0; i < tempBox.length; i++) {
      final _temp = tempBox[i] as Employee;
      _salary = _salary -
          (int.parse(_temp.salaryAdvanced)) + (int.parse(_temp.balance));
    }
    if (_salary < 0) {
      setState(() {
        _balance = 0;
        _due = -(_salary);
      });
    } else {
      setState(() {
        _due = 0;
        _balance = _salary;
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
            child: Icon(Icons.add, color: Colors.white,),
            backgroundColor: Colors.blue,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeSalaryEntryScreen(employeeModel: widget.employeeModel)));
            },
            label: 'Add Data',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.blue),
        // FAB 2
        SpeedDialChild(
            child: Icon(Icons.picture_as_pdf_outlined,color: Colors.white,),
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
    Widget buildSingleItem(Employee employee, Map map) =>
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
                        employee.date,
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
                        "Salary Advanced",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                      Text(
                        employee.salaryAdvanced,
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
                        "Salary Reloaded",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                      Text(
                        employee.balance,
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
                        employee.remarks,
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ],
                  ),


                   SizedBox(
                  width: 70,
                ),
                IconButton(
                  onPressed: () {
                    map.forEach((key, value) {
                      if (value.name == employee.name && value.invoice == employee.invoice) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EmployeeSalaryUpdateScreen(
                                      employeeModel: employee,
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
                IconButton(
                  onPressed: () {
                    map.forEach((key, value) {
                      if (value.name == employee.name && value.invoice == employee.invoice) {
                        Hive.box('employees').delete(key);
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
        valueListenable: Hive.box('employees').listenable(),
        builder: (context, employeeBox, _) {
          final employeeBox = Hive
              .box('employees')
              .values
              .where((c) =>
              c.name
                  .toLowerCase()
                  ==(widget.employeeModel.name.toLowerCase()))
              .toList();

                 final Map employeeMap = Hive.box('employees').toMap();
          return (employeeBox == null)
              ? Center(
            child: CircularProgressIndicator(),
          )
              : (employeeBox.isEmpty)
              ? Center(
            child: Text('No Transaction'),
          )
              : ListView.builder(
            itemBuilder: (context, index) {
              return buildSingleItem(employeeBox[index],employeeMap);
            },
            itemCount: employeeBox.length,
          );
        },
      );
    }

    ;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Employee Name : ${widget.employeeModel.name}"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Employee Name : ${widget.employeeModel.name}",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                Text(
                  "Post : ${widget.employeeModel.post}",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),

                    Text(
                      "Balance : $_balance TK",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Salary : ${widget.employeeModel.salary} TK",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
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

    final _list = <EmployeeItem>[];
    final tempBox = Hive
        .box('employees')
        .values
        .where((c) =>
        c.name
            .toLowerCase().contains(widget.employeeModel.name.toLowerCase()))
        .toList();
    for(int i = 0; i<tempBox.length;i++){
      final _temp = tempBox[i] as Employee;
    _list.add(new EmployeeItem(_temp.date, _temp.salaryAdvanced, _temp.balance, _temp.remarks));
    }

    final tempEmployee = tempBox[0] as Employee;
    final invoice = InvoiceEmployee(
      tempEmployee.name,
        tempEmployee.post,
        tempEmployee.salary,
        _balance.toString(),
        _due.toString(),
        _list
    );


    final pdfFile = await PdfEmployee.generate(invoice);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Pdf Generated!!")));

  }

}
