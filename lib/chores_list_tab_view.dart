import 'package:chores/edit_chore_view.dart';
import 'package:chores/routing_constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chore.dart';

///
/// A structure used for rendering each list view tile in the list of chores
///
class ChoreChecked {
  Chore chore;
  String documentID;
  bool checked;

  ChoreChecked({this.documentID, this.chore, this.checked});

  ChoreChecked.fromSnapshot(DocumentSnapshot snap)
      : chore = new Chore(
          title: snap.data()['title'],
          description: snap.data()['description'],
        ),
        documentID = snap.id,
        checked = false;

  void addToCollection(
      WriteBatch batch, CollectionReference collectionReference) {
    return chore.add(batch,
        collectionReference.doc(documentID)); // This document should not exist
  }

  void deleteFromCollection(
      WriteBatch batch, CollectionReference collectionReference) {
    return chore.delete(batch, collectionReference.doc(documentID));
  }
}

///
/// The main widget — the tab view with an optional button at the bottom
///
class ChoresListTabView extends StatefulWidget {
  final CollectionReference _choresCollection;
  final List<ChoreChecked> _choresChecked;
  final bool _addButton;
  final String _buttonTitle;
  final Function _buttonFunction;

  ChoresListTabView(
      {choresCollection,
      choresChecked,
      addButton = false,
      buttonTitle,
      buttonFunction})
      : _choresCollection = choresCollection,
        _choresChecked = choresChecked,
        _addButton = addButton,
        _buttonTitle = buttonTitle,
        _buttonFunction = buttonFunction;

  @override
  _ChoresListTabViewState createState() => _ChoresListTabViewState();
}

class _ChoresListTabViewState extends State<ChoresListTabView> {
  _ChoresListTabViewState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildChoreList(),
            if (widget._addButton) ...[
              SizedBox(height: 20),
              FloatingActionButton(
                tooltip: "Add new chore",
                child: Icon(Icons.add),
                onPressed: () {
                  _editChore(context, null);
                },
              ),
            ]
          ],
        ),
        Spacer(),
        ChoresMainButton(widget._buttonTitle, widget._buttonFunction),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildChoreList() {
    // if (snapshot.hasError) return new Text('Error: ${snapshot.error}');

    return new ListView(
      shrinkWrap: true,
      children: widget._choresChecked.map((chore) {
        return new CheckboxListTile(
            title: new Text(chore.chore.title),
            subtitle: new Text(chore.chore.description),
            value: chore.checked,
            secondary:
                PopupMenuButton<String>(itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.create),
                      SizedBox(width: 20),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: 20),
                      Text('Delete'),
                    ],
                  ),
                ),
              ];
            }, onSelected: (value) async {
              switch (value) {
                case 'edit':
                  _editChore(context, chore);
                  break;

                case 'delete':
                  _deleteChore(context, chore);
                  break;

                default:
              }
            }),
            onChanged: (bool newValue) {
              setState(() {
                chore.checked = newValue;
              });
            });
      }).toList(),
    );
  }

  ///
  /// Edit a chore or create a new chore if chore is null
  ///
  void _editChore(BuildContext context, ChoreChecked choreChecked) async {
    var result = await Navigator.pushNamed(context, EditChoreViewRoute,
        arguments: EditChoreViewArguments(
          chore: choreChecked?.chore,
          documentID: choreChecked?.documentID ?? "",
          collectionReference: widget._choresCollection,
        ));
    if (result == "cancel") {
      return;
    }
    final snackBar = SnackBar(
        content: Text(
            result == "success" ? "Chore saved" : "Please try again later"));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  ///
  /// Delete a chore
  ///
  void _deleteChore(BuildContext context, ChoreChecked chore) async {
    try {
      await widget._choresCollection.doc(chore.documentID).delete();
    } catch (e) {
      final snackBar = SnackBar(content: Text('Something went wrong'));
      Scaffold.of(context).showSnackBar(snackBar);
    }
    final snackBar = SnackBar(content: Text('Chore deleted'));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}

///
/// Renders the main gradient button
///
class ChoresMainButton extends StatelessWidget {
  final String _title;
  final Function _onPressed;

  ChoresMainButton(this._title, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: _onPressed,
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
        width: 100,
        padding: const EdgeInsets.all(10.0),
        child: Center(child: Text(_title, style: TextStyle(fontSize: 14))),
      ),
    );
  }
}
