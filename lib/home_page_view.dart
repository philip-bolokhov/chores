import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chores_list_tab_view.dart';

class HomePageView extends StatefulWidget {
  HomePageView({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  var _openChoresChecked = new List<ChoreCheckedData>.generate(
      100,
      (_) => new ChoreCheckedData(
          documentID: "",
          chore: new Chore(title: "", description: ""),
          checked: false),
      growable: true); // AAAA 100 has to be changed

  var _completedChoresChecked = new List<ChoreCheckedData>.generate(
      100,
      (_) => new ChoreCheckedData(
          documentID: "",
          chore: new Chore(title: "", description: ""),
          checked: false),
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
        'title': element.chore.title,
        'description': element.chore.description,
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
        'title': element.chore.title,
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
            addButton: true,
            buttonTitle: 'Complete',
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
