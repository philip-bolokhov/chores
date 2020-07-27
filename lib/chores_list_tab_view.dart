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
  final _choresCollection;
  final _choresChecked;
  final String _buttonTitle;
  final Function _buttonFunction;

  ChoresListTabView(
      {choresCollection, choresChecked, buttonTitle, buttonFunction})
      : _choresCollection = choresCollection,
        _choresChecked = choresChecked,
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
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: widget._choresCollection.snapshots(),
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
                      widget._choresChecked[documentEntry.key].documentID =
                          documentEntry.value.documentID;
                      widget._choresChecked[documentEntry.key].title =
                          documentEntry.value['title'];
                      return new CheckboxListTile(
                          title: new Text(documentEntry.value['title']),
                          value:
                              widget._choresChecked[documentEntry.key].checked,
                          secondary: Icon(Icons.schedule),
                          onChanged: (bool newValue) {
                            setState(() {
                              widget._choresChecked[documentEntry.key].checked =
                                  newValue;
                            });
                          });
                    }).toList(),
                  );
              }
            },
          ),
        ),
        ChoresMainButton(widget._buttonTitle, widget._buttonFunction),
        const SizedBox(height: 15),
      ],
    );
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
        width: 90,
        padding: const EdgeInsets.all(10.0),
        child: Center(child: Text(_title, style: TextStyle(fontSize: 14))),
      ),
    );
  }
}
