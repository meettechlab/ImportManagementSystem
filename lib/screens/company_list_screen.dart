import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/model/company.dart';
import 'package:importmanagementsoftware/model/employee.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/create_company_screen.dart';
import 'package:importmanagementsoftware/screens/create_employee_screen.dart';
import 'package:importmanagementsoftware/screens/individual_lc_history_screen.dart';
import 'package:importmanagementsoftware/screens/lc_new_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/screens/single_employee_screen.dart';

import 'single_company_screen.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({Key? key}) : super(key: key);

  @override
  _CompanyListScreenState createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
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
            'Clients/Suppliers List'
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
                    showSearch(context: context, delegate: CompanySearch());
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
              context, MaterialPageRoute(builder: (context) => CreateCompanyScreen()));
        },
        child:Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('companies').listenable(),
      builder: (context, companyBox, _) {
        final companyBox = Hive.box('companies')
            .values
            .where((c) => c.invoice
            .toLowerCase()
            .contains("1"))
            .toList();

        final Map companyMap = Hive.box('companies').toMap();
        return (companyBox == null)
            ? Center(
          child: CircularProgressIndicator(),
        )
            : (companyBox.isEmpty)
            ? Center(
          child: Text('No Client/Supplier'),
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


  Widget buildSingleItem(Company company, Map map) => InkWell(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => SingleCompanyScreen(companyModel: company,)));
    },
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 20,),
            Text(
              company.name,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 25,
                  fontWeight: FontWeight.bold
              ),
            ),
            IconButton(
              onPressed: (){
                map.forEach((key, value) {
                  if(value.name == company.name){
                    Hive.box('companies').delete(key);
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



class CompanySearch extends SearchDelegate{

  List searchTerms = Hive.box('companies')
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
    List<Company> matchQuery = [];
    for(Company lc in searchTerms){
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
                context, MaterialPageRoute(builder: (context) =>  SingleCompanyScreen(companyModel: result)));
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
    List<Company> matchQuery = [];
    for(Company lc in searchTerms){
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
                context, MaterialPageRoute(builder: (context) =>  SingleCompanyScreen(companyModel: result)));
          },
          child: ListTile(
            title: Text(result.name),
          ),
        );
      },
    );
  }

}
