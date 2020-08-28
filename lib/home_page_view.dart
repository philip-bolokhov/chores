import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  /*
   * Firestore collection references to the collections of chores
   */
  var _openChoresRef = FirebaseFirestore.instance.collection('openChores');
  var _completedChoresRef =
      FirebaseFirestore.instance.collection('completedChores');

  var subscriptions = new List<StreamSubscription<QuerySnapshot>>();

  var _openChoresChecked = new List<ChoreChecked>();
  var _completedChoresChecked = new List<ChoreChecked>();

  @protected
  @mustCallSuper
  initState() {
    subscriptions
        .add(_subscribetoCollection(_openChoresRef, _openChoresChecked));
    subscriptions.add(
        _subscribetoCollection(_completedChoresRef, _completedChoresChecked));
    super.initState();
  }

  @override
  dispose() {
    subscriptions.forEach((subscription) => subscription.cancel());
    subscriptions.clear();
    super.dispose();
  }

  // Subscribes to the collection snapshot to update a list
  StreamSubscription<QuerySnapshot> _subscribetoCollection(
      CollectionReference collectionReference, List<ChoreChecked> list) {
    return collectionReference.snapshots().listen((event) {
      if (list.length != 0) {
        list.clear();
      }
      setState(() {
        event.docs
            .forEach((snap) => list.add(new ChoreChecked.fromSnapshot(snap)));
      });
    });
  }

  // Moves all checked chores from one list to another
  Future<void> _moveChore(
      List<ChoreChecked> fromList,
      List<ChoreChecked> toList,
      CollectionReference fromCollection,
      CollectionReference toCollection) async {
    var batch = FirebaseFirestore.instance.batch();
    await Future.wait(
        fromList.where((element) => element.checked).map((element) async {
      // Check that the document still exists
      var snapFrom = await fromCollection.doc(element.documentID).get();
      if (!snapFrom.exists) {
        return;
      }
      // Check that the document does not exist on the target collection
      var snapTo = await toCollection.doc(element.documentID).get();
      if (snapTo.exists) {
        return;
      }
      element.addToCollection(batch, toCollection);
      element.deleteFromCollection(batch, fromCollection);
    }));
    batch.commit();

    // Unselect all chores
    fromList.forEach((element) {
      element.checked = false;
    });
  }

  Future<void> _applySelected() async {
    return await _moveChore(_openChoresChecked, _completedChoresChecked,
        _openChoresRef, _completedChoresRef);
  }

  Future<void> _restoreSelected() async {
    return await _moveChore(_completedChoresChecked, _openChoresChecked,
        _completedChoresRef, _openChoresRef);
  }

  @override
  Widget build(BuildContext context) {
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
      // The number of tabs / content sections to display.
      length: 2,
      child: Stack(fit: StackFit.expand, children: [
        Image(
            fit: BoxFit.cover, image: AssetImage('assets/images/kitchen.jpg')),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3.0,
            sigmaY: 3.0,
          ),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(0x21, 0x96, 0xF3, 0.6),
              bottom: TabBar(tabs: [
                Tab(text: "Tasks"),
                Tab(text: "Completed Tasks"),
              ]),
              // Here we take the value from the HomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text('Chores'),
              centerTitle: true,
            ),
            backgroundColor: Color.fromARGB(230, 200, 200, 200),
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
        ),
      ]),
    );
  }
}
