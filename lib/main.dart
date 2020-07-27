import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  Future.delayed(Duration(seconds: 3), () {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  static const MAX_PAGE_WIDTH = 800;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Chore',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > MAX_PAGE_WIDTH) {
          return _wideLayout(constraints);
        } else {
          return _normalLayout();
        }
      }),
    );
  }

  Widget _wideLayout(BoxConstraints constraints) {
    double padding = (constraints.maxWidth - MAX_PAGE_WIDTH) / 2.0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: MyHomePage(),
    );
  }

  Widget _normalLayout() {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _ChoreCheckedData {
  String documentID;
  String title;
  bool checked;
  _ChoreCheckedData(this.documentID, this.title, this.checked);
}

class _MyHomePageState extends State<MyHomePage> {
  var _openChoresChecked = new List<_ChoreCheckedData>.generate(
      100, (_) => new _ChoreCheckedData("", "", false),
      growable: true); // AAAA 100 has to be changed

  var _completedChoresChecked = new List<bool>.filled(100, false,
      growable: true); // AAAA 100 has to be changed

  /*
   * Firestore collection references to the collections of chores
   */
  var _openChoresRef = Firestore.instance.collection('openChores');
  var _completedChoresRef = Firestore.instance.collection('completedChores');

  void _applySelected() {
    _openChoresChecked
        .where((element) => element.checked)
        .forEach((element) async {
      await _completedChoresRef.add({
        'title': element.title,
      });
      await _openChoresRef.document(element.documentID).delete();

      // Unselect the chore
      element.checked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
      // The number of tabs / content sections to display.
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(tabs: [
            Tab(text: "Tasks"),
            Tab(text: "Completed Tasks"),
          ]),
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('Chores'),
          centerTitle: true,
        ),
        body: TabBarView(children: [
          Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _openChoresRef.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                            child: SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator()));
                      default:
                        return new ListView(
                          children: snapshot.data.documents.asMap().entries.map(
                              (MapEntry<int, DocumentSnapshot> documentEntry) {
                            _openChoresChecked[documentEntry.key].documentID =
                                documentEntry.value.documentID;
                            _openChoresChecked[documentEntry.key].title =
                                documentEntry.value['title'];
                            return new CheckboxListTile(
                                title: new Text(documentEntry.value['title']),
                                value: _openChoresChecked[documentEntry.key]
                                    .checked,
                                secondary: Icon(Icons.schedule),
                                onChanged: (bool newValue) {
                                  setState(() {
                                    _openChoresChecked[documentEntry.key]
                                        .checked = newValue;
                                  });
                                });
                          }).toList(),
                        );
                    }
                  },
                ),
              ),
              RaisedButton(
                onPressed: _applySelected,
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFF0D47A1),
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5),
                      ],
                    ),
                  ),
                  width: 90,
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                      child:
                          const Text('Apply', style: TextStyle(fontSize: 14))),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _completedChoresRef.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                      child: SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator()));
                default:
                  return new ListView(
                    children: snapshot.data.documents
                        .asMap()
                        .entries
                        .map((MapEntry<int, DocumentSnapshot> documentEntry) {
                      return new CheckboxListTile(
                          title: new Text(documentEntry.value['title']),
                          value: _completedChoresChecked[documentEntry.key],
                          secondary: Icon(Icons.schedule),
                          onChanged: (bool newValue) {
                            setState(() {
                              _completedChoresChecked[documentEntry.key] =
                                  newValue;
                            });
                          });
                    }).toList(),
                  );
              }
            },
          ),
        ]),
      ),
    );
  }
}
