import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/model/cstock.dart';
import 'package:importmanagementsoftware/screens/crusher_stock_t_screen.dart';
import 'package:importmanagementsoftware/screens/stone_sale_screen.dart';
import 'package:intl/intl.dart';

import '../model/company.dart';
import '../model/csale.dart';
import 'crusher_stock_s_screen.dart';

class CrusherStockEntryScreen extends StatefulWidget {
  const CrusherStockEntryScreen({Key? key}) : super(key: key);

  @override
  _CrusherStockEntryScreenState createState() => _CrusherStockEntryScreenState();
}

class _CrusherStockEntryScreenState extends State<CrusherStockEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final truckCountEditingController = new TextEditingController();
  final tonEditingController = new TextEditingController();
  final remarksEditingController = new TextEditingController();
  final rateEditingController = new TextEditingController();
  DateTime? _date;
  bool? _process;
  int? _count;
  final _portTypes = ['Shutarkandi', 'Tamabil'];
  String? _chosenPort;
  int? _invoice;

  List<String> _companyNameList = [];
  String? _chosenCompanyName;
  List<String> _companyContactList = [];
  String? _chosenCompanyContact;

  @override
  void initState() {
    super.initState();
    _process = false;
    _count = 1;
    final tempSaleBox = Hive.box('cStocks')
        .values;
    if(tempSaleBox.isEmpty){
      setState(() {
        _invoice = 1;
      });
    }else{
      setState(() {
        _invoice = int.parse(tempSaleBox.last.invoice) + 1;
      });
    }

    final _tempCompanyList = Hive.box('companies')
        .values
        .where((c) => c.invoice
        .toLowerCase()
        .contains("1"))
        .toList();
    for(int i = 0; i< _tempCompanyList.length; i++){
      final _tempCompany = _tempCompanyList[i] as Company;
      _companyNameList.add(_tempCompany.name);
      _companyContactList.add(_tempCompany.contact);
    }
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

    final rateField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: false,
            controller: rateEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Rate cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              rateEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Rate',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final truckCountField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            cursorColor: Colors.blue,
            autofocus: false,
            controller: truckCountEditingController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("No Of Truck cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              truckCountEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'No of Trucks',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final tonField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: tonEditingController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Ton cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              tonEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Ton',
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
          'Add New Stock',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
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
            items: _portTypes.map(buildMenuItem).toList(),
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

                final _tempCompanyList = Hive.box('companies')
                    .values
                    .where((c) => c.invoice
                    .toLowerCase()
                    .contains("1"))
                    .toList();
                for(int i = 0; i< _tempCompanyList.length; i++){
                  final _tempCompany = _tempCompanyList[i] as Company;
                  if(_tempCompany.name.contains(newValue!)){
                    _chosenCompanyContact = _tempCompany.contact;
                  }
                }
              });
            }));


    DropdownMenuItem<String> buildMenuContact(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: Colors.blue),
        ));

    final contactDropdown = Container(
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
            items: _companyContactList.map(buildMenuContact).toList(),
            hint: Text(
              'Select Client/Supplier',
              style: TextStyle(color: Colors.blue),
            ),
            value: _chosenCompanyContact,
            onChanged: (newValue) {
              setState(() {
                _chosenCompanyContact = newValue;


                final _tempCompanyList = Hive.box('companies')
                    .values
                    .where((c) => c.invoice
                    .toLowerCase()
                    .contains("1"))
                    .toList();
                for(int i = 0; i< _tempCompanyList.length; i++){
                  final _tempCompany = _tempCompanyList[i] as Company;
                  if(_tempCompany.contact.contains(newValue!)){
                    _chosenCompanyName = _tempCompany.name;
                  }
                }
              });
            }));



    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add New Stock'),
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
                        truckCountField,
                        pickDate,
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tonField,
                        portDropdown,
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        nameDropdown,
                        contactDropdown
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    rateField,
                    SizedBox(
                      height: 20,
                    ),
                    remarksField,
                    SizedBox(
                      height: 20,
                    ),
                    addButton,
                    SizedBox(
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
    if (_formKey.currentState!.validate() && _chosenPort != null&& _date != null && _chosenCompanyName != null && _chosenCompanyContact != null ) {
      final cStockBox = Hive.box('cStocks');
      final _cftS = double.parse(tonEditingController.text) * 22;
      final _cftT = double.parse(tonEditingController.text) * 25;
      final _threeToFourS = (_cftS * 54) / 100 ;
      final _threeToFourT = (_cftT * 55) / 100 ;
      final _oneToSixS = (_cftS * 29) / 100 ;
      final _oneToSixT = (_cftT * 30) / 100 ;
      final _halfS = (_cftS * 17) / 100 ;
      final _halfT = (_cftT * 15) / 100 ;
      final _fiveToTenS = (_cftS * 7) / 100 ;
      final _fiveToTenT = (_cftT * 7) / 100 ;
      final _totalS = _threeToFourS + _oneToSixS +_halfS + _fiveToTenS;
      final _totalT = _threeToFourT + _oneToSixT +_halfT + _fiveToTenT;
      final _extraS = _totalS - _cftS;
      final _extraT = _totalT - _cftT;


      final _priceS = _cftS * double.parse(rateEditingController.text);
      final _priceT = _cftT * double.parse(rateEditingController.text);

      if(_chosenPort == "Shutarkandi"){
        final cStockModel = CStock(_invoice.toString(), DateFormat('dd-MMM-yyyy').format(_date!),truckCountEditingController.text,_chosenPort!,tonEditingController.text,_cftS.toString(),_threeToFourS.toString(),_oneToSixS.toString(),_halfS.toString(),_fiveToTenS.toString(),_totalS.toString(),_extraS.toString(),remarksEditingController.text,_chosenCompanyName!, _chosenCompanyContact!,DateFormat('MMM-yyyy').format(_date!), rateEditingController.text, _priceS.toString());
        cStockBox.add(cStockModel);
        final companyModel = Company("0", _chosenCompanyName!, _chosenCompanyContact!, "0", "0" , "0","Crusher Sale", "2", "0", "0",  DateFormat('dd-MMM-yyyy').format(_date!),DateFormat('yyyy').format(_date!));
        Hive.box('companies').add(companyModel);
      }else{
        final cStockModel = CStock(_invoice.toString(), DateFormat('dd-MMM-yyyy').format(_date!),truckCountEditingController.text,_chosenPort!,tonEditingController.text,_cftT.toString(),_threeToFourT.toString(),_oneToSixT.toString(),_halfT.toString(),_fiveToTenT.toString(),_totalT.toString(),_extraT.toString(),remarksEditingController.text,_chosenCompanyName!, _chosenCompanyContact!,DateFormat('yyyy').format(_date!), rateEditingController.text, _priceT.toString());
        cStockBox.add(cStockModel);
        final companyModel = Company("0", _chosenCompanyName!, _chosenCompanyContact!, "0", "0" , "0","Crusher Sale", "2", "0", "0",  DateFormat('dd-MMM-yyyy').format(_date!),DateFormat('yyyy').format(_date!));
        Hive.box('companies').add(companyModel);
      }

      setState(() {
        _process = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Text("Entry Added!!")));
      if(_chosenPort == "Tamabil"){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CrusherStockTScreen()));
      }else{
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CrusherStockSScreen()));
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