import 'package:chores/chores_list_tab_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditChoreView extends StatefulWidget {
  final ChoreCheckedData chore;
  final CollectionReference _collectionRef;

  EditChoreView(dynamic choreData)
      : chore = choreData['data'],
        _collectionRef = choreData['reference'];

  @override
  EditChoreViewState createState() => EditChoreViewState();
}

class EditChoreViewState extends State<EditChoreView> {
  final _formKey = GlobalKey<FormState>();

  // Chore title
  String _title;

  // Chore description
  String _description;

  @override
  Widget build(BuildContext context) {
    _title = widget.chore.title;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Edit chore details'),
      ),
      body: Builder(
        builder: (innerContext) => Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue: _title,
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _title = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        minLines: 2,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _description = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RaisedButton(
                    child: Text('Save'),
                    onPressed: () async {
                      try {
                        await widget._collectionRef
                            .document(widget.chore.documentID)
                            .setData({
                          'title': _title,
                          'description': _description,
                        }, merge: true);
                      } catch (e) {
                        final snackBar =
                            SnackBar(content: Text("Something went wrong"));
                        Scaffold.of(innerContext).showSnackBar(snackBar);
                        return;
                      }
                      print(
                          "Got title = '$_title', description = '$_description'");
                      Navigator.pop(context, "success");
                    },
                  ),
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context, "cancel");
                    },
                  )
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
