import 'package:chores/routing_constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

///
/// A structure used for rendering each list view tile in the list of chores
///
class ChoreCheckedData {
  String documentID;
  String title;
  bool checked;
  ChoreCheckedData(this.documentID, this.title, this.checked);
}

///
/// The main widget — the tab view with a button at the bottom
///
class ChoresListTabView extends StatefulWidget {
  final CollectionReference _choresCollection;
  final List<ChoreCheckedData> _choresChecked;
  final bool _addButton;
  final String _buttonTitle;
  final Function _buttonFunction;

  ChoresListTabView(
      {choresCollection, choresChecked, addButton, buttonTitle, buttonFunction})
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
            StreamBuilder<QuerySnapshot>(
              stream: widget._choresCollection.snapshots(),
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
                      shrinkWrap: true,
                      children: snapshot.data.documents
                          .asMap()
                          .entries
                          .map((MapEntry<int, DocumentSnapshot> documentEntry) {
                        widget._choresChecked[documentEntry.key].documentID =
                            documentEntry.value.documentID;
                        widget._choresChecked[documentEntry.key].title =
                            documentEntry.value['title'];
                        return new CheckboxListTile(
                            title: new Text(documentEntry.value['title']),
                            value: widget
                                ._choresChecked[documentEntry.key].checked,
                            secondary: PopupMenuButton<String>(
                                itemBuilder: (BuildContext context) {
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
                              print(
                                  "Selected item '${documentEntry.value.data['title']}' → " +
                                      value);
                              switch (value) {
                                case 'edit':
                                  _editChore(context,
                                      widget._choresChecked[documentEntry.key]);
                                  break;

                                case 'delete':
                                  _deleteChore(context,
                                      widget._choresChecked[documentEntry.key]);
                                  break;

                                default:
                              }
                            }),
                            onChanged: (bool newValue) {
                              setState(() {
                                widget._choresChecked[documentEntry.key]
                                    .checked = newValue;
                              });
                            });
                      }).toList(),
                    );
                }
              },
            ),
            if (widget._addButton) ...[
              SizedBox(height: 20),
              FloatingActionButton(
                tooltip: "Add new chore",
                child: Icon(Icons.add),
                onPressed: () {
                  print("Add new chore pressed");
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

  ///
  /// Edit a chore or create a new chore if chore is null
  ///
  void _editChore(BuildContext context, ChoreCheckedData chore) async {
    var result =
        await Navigator.pushNamed(context, EditChoreViewRoute, arguments: {
      'data': chore,
      'reference': widget._choresCollection,
    });
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
  void _deleteChore(BuildContext context, ChoreCheckedData chore) async {
    try {
      await widget._choresCollection.document(chore.documentID).delete();
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
