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

class _MyHomePageState extends State<MyHomePage> {
  var _openChoresChecked = new List<bool>.filled(100, false,
      growable: true); // AAAA 100 has to be changed

  var _completedChoresChecked = new List<bool>.filled(100, false,
      growable: true); // AAAA 100 has to be changed

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
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('openChores').snapshots(),
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
                          value: _openChoresChecked[documentEntry.key],
                          secondary: Icon(Icons.schedule),
                          onChanged: (bool newValue) {
                            setState(() {
                              _openChoresChecked[documentEntry.key] = newValue;
                            });
                          });
                    }).toList(),
                  );
              }
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream:
                Firestore.instance.collection('completedChores').snapshots(),
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
