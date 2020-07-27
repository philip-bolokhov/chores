import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chores_list_tab_view.dart';

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
      child: HomePage(),
    );
  }

  Widget _normalLayout() {
    return HomePage();
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _openChoresChecked = new List<ChoreCheckedData>.generate(
      100, (_) => new ChoreCheckedData("", "", false),
      growable: true); // AAAA 100 has to be changed

  var _completedChoresChecked = new List<ChoreCheckedData>.generate(
      100, (_) => new ChoreCheckedData("", "", false),
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
    });

    // Unselect all selected chores
    _openChoresChecked.forEach((element) {
      element.checked = false;
    });
  }

  void _restoreSelected() {
    _completedChoresChecked
        .where((element) => element.checked)
        .forEach((element) async {
      await _openChoresRef.add({
        'title': element.title,
      });
      await _completedChoresRef.document(element.documentID).delete();
    });

    // Unselect all selected chores
    _completedChoresChecked.forEach((element) {
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
          // Here we take the value from the HomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('Chores'),
          centerTitle: true,
        ),
        body: TabBarView(children: [
          ChoresListTabView(
            choresCollection: _openChoresRef,
            choresChecked: _openChoresChecked,
            buttonTitle: 'Apply',
            buttonFunction: _applySelected,
          ),
          ChoresListTabView(
            choresCollection: _completedChoresRef,
            choresChecked: _completedChoresChecked,
            buttonTitle: 'Restore',
            buttonFunction: _restoreSelected,
          ),
        ]),
      ),
    );
  }
}
