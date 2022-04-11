import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:importmanagementsoftware/model/coal.dart';
import 'package:importmanagementsoftware/model/lc.dart';
import 'package:importmanagementsoftware/screens/coal_lc_create_screen.dart';
import 'package:importmanagementsoftware/screens/individual_lc_history_screen.dart';
import 'package:importmanagementsoftware/screens/lc_new_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:importmanagementsoftware/screens/single_coal_lc_screen.dart';

import '../model/stone.dart';
import 'individual_lc_entry_screen.dart';

class CoalLCListScreen extends StatefulWidget {
  const CoalLCListScreen({Key? key}) : super(key: key);

  @override
  _CoalLCListScreenState createState() => _CoalLCListScreenState();
}

class _CoalLCListScreenState extends State<CoalLCListScreen> {
  double _totalStock = 0.0;
  double _totalAmount = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final tempCoalBox = Hive.box('coals').values.toList();
    for (var i = 0; i < tempCoalBox.length; i++) {
      final _temp = tempCoalBox[i] as Coal;
      if (_temp.lc != "sale") {
        setState(() {
          _totalStock = (_totalStock + double.parse(_temp.ton));
          _totalAmount = (_totalAmount + double.parse(_temp.credit));
        });
      } else {
        setState(() {
          _totalStock = (_totalStock - double.parse(_temp.ton));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Coal LC List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Available Stock : $_totalStock Ton",
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CoalLCCreateScreen()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('coals').listenable(),
      builder: (context, coalBox, _) {
        final coalBox = Hive.box('coals')
            .values
            .where((c) => c.invoice.toLowerCase().contains("1"))
            .toList();
        final Map coalMap = Hive.box('coals').toMap();
        return (coalBox == null)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (coalBox.isEmpty)
                ? Center(
                    child: Text('No Coal LC'),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return buildSingleItem(coalBox[index], coalMap);
                    },
                    itemCount: coalBox.length,
                  );
      },
    );
  }

  Widget buildSingleItem(Coal coal, Map map) => InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SingleCoalLCScreen(coalModel: coal)));
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
                  coal.lc,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    map.forEach((key, value) {
                      if (value.lc == coal.lc) {
                        Hive.box('coals').delete(key);
                      }
                    });

                    Hive.box('companies').toMap().forEach((key, value) {
                      if (value.id == "coalstock" + coal.lc) {
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
  List searchTerms = Hive.box('coals')
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
    List<Coal> matchQuery = [];
    for (Coal lc in searchTerms) {
      if (lc.lc.toLowerCase().contains(query.toLowerCase())) {
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
                        SingleCoalLCScreen(coalModel: result)));
          },
          child: ListTile(
            title: Text(result.lc),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Coal> matchQuery = [];
    for (Coal lc in searchTerms) {
      if (lc.lc.toLowerCase().contains(query.toLowerCase())) {
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
                        SingleCoalLCScreen(coalModel: result)));
          },
          child: ListTile(
            title: Text(result.lc),
          ),
        );
      },
    );
  }
}

class YearSearch extends SearchDelegate {
  List searchTerms = Hive.box('coals')
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
    List<Coal> matchQuery = [];
    for (Coal lc in searchTerms) {
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
                        SingleCoalLCScreen(coalModel: result)));
          },
          child: ListTile(
            title: Text(result.lc),
            subtitle: Text(result.year),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Coal> matchQuery = [];
    for (Coal lc in searchTerms) {
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
                        SingleCoalLCScreen(coalModel: result)));
          },
          child: ListTile(
            title: Text(result.lc),
            subtitle: Text(result.year),
          ),
        );
      },
    );
  }
}
