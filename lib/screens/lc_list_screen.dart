import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/individual_lc_history_screen.dart';
import 'package:importmanagementsoftware/screens/lc_new_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/stone.dart';
import 'individual_lc_entry_screen.dart';

class LCListScreen extends StatefulWidget {
  const LCListScreen({Key? key}) : super(key: key);

  @override
  _LCListScreenState createState() => _LCListScreenState();
}

class _LCListScreenState extends State<LCListScreen> {
  double _totalStock = 0.0;
  double _totalAmount = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final tempLCBox = Hive.box('lcs').values.toList();
    for (var i = 0; i < tempLCBox.length; i++) {
      final _temp = tempLCBox[i] as LC;
      setState(() {
        _totalStock =
            (double.parse(_totalStock.toString()) + double.parse(_temp.cft));
        _totalAmount = (double.parse(_totalAmount.toString()) +
            double.parse(_temp.totalBalance));
      });
    }
    final tempStoneBox = Hive.box('stones').values.toList();
    for (var i = 0; i < tempStoneBox.length; i++) {
      final _temp = tempStoneBox[i] as Stone;
      setState(() {
        _totalStock =
            (double.parse(_totalStock.toString()) - double.parse(_temp.cft));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('LC List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Stock : $_totalStock CFT",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                Text(
                  "Total Purchase : $_totalAmount TK",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () {
                    showSearch(context: context, delegate: LCSearch());
                  },
                  child: Row(
                    children: [Text('Search By LC')],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () {
                    showSearch(context: context, delegate: YearSearch());
                  },
                  child: Row(
                    children: [Text('Search By Year')],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(),
          ),
          Expanded(child: _buildListView()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LCNewScreen()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('lcs').listenable(),
      builder: (context, lcBox, _) {
        final lcBox = Hive.box('lcs')
            .values
            .where((c) => c.invoice.toLowerCase().contains("1"))
            .toList();

        final Map lcMap = Hive.box('lcs').toMap();
        return (lcBox == null)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (lcBox.isEmpty)
                ? Center(
                    child: Text('No LC'),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return buildSingleItem(lcBox[index], lcMap);
                    },
                    itemCount: lcBox.length,
                  );
      },
    );
  }

  Widget buildSingleItem(LC lc, Map map) => InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      IndividualLCHistoryScreen(lcModel: lc)));
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
                  lc.lcNumber,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    map.forEach((key, value) {
                      if (value.lcNumber == lc.lcNumber) {
                        Hive.box('lcs').delete(key);
                      }
                    });

                    Hive.box('companies').toMap().forEach((key, value) {
                      if (value.id ==
                          "stonestock" + lc.lcNumber) {
                        Hive.box('companies').delete(key);
                      }
                    });
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ),
        ),
      );
}

class LCSearch extends SearchDelegate {
  List searchTerms = Hive.box('lcs')
      .values
      .where((c) => c.invoice.toLowerCase().contains("1"))
      .toList();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: AnimatedIcon(
          progress: transitionAnimation,
          icon: AnimatedIcons.menu_arrow,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<LC> matchQuery = [];
    for (LC lc in searchTerms) {
      if (lc.lcNumber.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(lc);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        IndividualLCHistoryScreen(lcModel: result)));
          },
          child: ListTile(
            title: Text(result.lcNumber),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<LC> matchQuery = [];
    for (LC lc in searchTerms) {
      if (lc.lcNumber.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(lc);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        IndividualLCHistoryScreen(lcModel: result)));
          },
          child: ListTile(
            title: Text(result.lcNumber),
          ),
        );
      },
    );
  }
}

class YearSearch extends SearchDelegate {
  List searchTerms = Hive.box('lcs')
      .values
      .where((c) => c.invoice.toLowerCase().contains("1"))
      .toList();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: AnimatedIcon(
          progress: transitionAnimation,
          icon: AnimatedIcons.menu_arrow,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<LC> matchQuery = [];
    for (LC lc in searchTerms) {
      if (lc.year.contains(query)) {
        matchQuery.add(lc);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        IndividualLCHistoryScreen(lcModel: result)));
          },
          child: ListTile(
            title: Text(result.lcNumber),
            subtitle: Text(result.year),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<LC> matchQuery = [];
    for (LC lc in searchTerms) {
      if (lc.year.contains(query)) {
        matchQuery.add(lc);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        IndividualLCHistoryScreen(lcModel: result)));
          },
          child: ListTile(
            title: Text(result.lcNumber),
            subtitle: Text(result.year),
          ),
        );
      },
    );
  }
}
