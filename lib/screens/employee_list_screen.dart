import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/model/employee.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/create_employee_screen.dart';
import 'package:importmanagementsoftware/screens/individual_lc_history_screen.dart';
import 'package:importmanagementsoftware/screens/lc_new_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/screens/single_employee_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({Key? key}) : super(key: key);

  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
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
            'Employee List'
        ),
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: (){
                    showSearch(context: context, delegate: EmployeeSearch());
                  },
                  child: Row(
                    children: [
                      Text('Search By Name')
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _buildListView()),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateEmployeeScreen()));
        },
        child:Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('employees').listenable(),
      builder: (context, employeeBox, _) {
        final employeeBox = Hive.box('employees')
            .values
            .where((c) => c.invoice
            .toLowerCase()
            .contains("1"))
            .toList();

        final Map employeeMap = Hive.box('employees').toMap();
        return (employeeBox == null)
            ? Center(
          child: CircularProgressIndicator(),
        )
            : (employeeBox.isEmpty)
            ? Center(
          child: Text('No employee'),
        )
            : ListView.builder(
          itemBuilder: (context, index) {
            return buildSingleItem(employeeBox[index], employeeMap);
          },
          itemCount: employeeBox.length,
        );
      },
    );
  }


  Widget buildSingleItem(Employee employee, Map map) => InkWell(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => SingleEmployeeScreen(employeeModel: employee)));
    },
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 20,),
            Text(
              employee.name,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 25,
                  fontWeight: FontWeight.bold
              ),
            ),
            IconButton(
              onPressed: (){
                map.forEach((key, value) {
                  if(value.name == employee.name){
                    Hive.box('employees').delete(key);
                  }
                });
              },
              icon: Icon(Icons.delete, color: Colors.red,),
            )
          ],
        ),
      ),
    ),
  );


}



class EmployeeSearch extends SearchDelegate{

  List searchTerms = Hive.box('employees')
      .values
      .where((c) => c.invoice
      .toLowerCase()
      .contains("1"))
      .toList();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){
        query = '';
      }, icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: (){
          close(context, null);
        },
        icon: AnimatedIcon(
          progress: transitionAnimation,
          icon: AnimatedIcons.menu_arrow,
        )
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Employee> matchQuery = [];
    for(Employee lc in searchTerms){
      if(lc.name.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(lc);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index){
        var result = matchQuery[index];
        return InkWell(
          onTap: (){
            Navigator.push(
                context, MaterialPageRoute(builder: (context) =>  SingleEmployeeScreen(employeeModel: result)));
          },
          child: ListTile(
            title: Text(result.name),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Employee> matchQuery = [];
    for(Employee lc in searchTerms){
      if(lc.name.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(lc);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index){
        var result = matchQuery[index];
        return InkWell(
          onTap: (){
            Navigator.push(
                context, MaterialPageRoute(builder: (context) =>  SingleEmployeeScreen(employeeModel: result)));
          },
          child: ListTile(
            title: Text(result.name),
          ),
        );
      },
    );
  }

}