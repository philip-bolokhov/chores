import 'package:chores/chores_list_tab_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chore.dart';

class EditChoreViewArguments {
  Chore chore;
  String documentID;
  CollectionReference collectionReference;

  EditChoreViewArguments(
      {this.chore, this.documentID, this.collectionReference});
}

class EditChoreView extends StatefulWidget {
  final Chore chore;
  final String documentID;
  final CollectionReference collectionReference;

  EditChoreView({this.chore, this.documentID, this.collectionReference});

  @override
  EditChoreViewState createState() => EditChoreViewState(
      initialTitle: chore?.title ?? "",
      initialDescription: chore?.description ?? "");
}

class EditChoreViewState extends State<EditChoreView> {
  final _formKey = GlobalKey<FormState>();

  final String initialTitle;
  final String initialDescription;

  EditChoreViewState({this.initialTitle, this.initialDescription});

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController =
        new TextEditingController(text: initialTitle);
    TextEditingController descriptionController =
        new TextEditingController(text: initialDescription);

    return WillPopScope(
      onWillPop: _onBackButtonPressed,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(widget.chore != null ? 'Edit chore details' : 'New chore'),
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
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: descriptionController,
                          minLines: 2,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Description',
                          ),
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
                          var dataToSave = {
                            'title': titleController.text,
                            'description': descriptionController.text,
                          };
                          await (widget.chore != null
                              ? widget.collectionReference
                                  .document(widget.documentID)
                                  .setData(dataToSave, merge: true)
                              : widget.collectionReference.add(dataToSave));
                        } catch (e) {
                          final snackBar =
                              SnackBar(content: Text("Something went wrong"));
                          Scaffold.of(innerContext).showSnackBar(snackBar);
                          return;
                        }
                        print(
                            "Got title = '${titleController.text}', description = '${descriptionController.text}'");
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
      ),
    );
  }

  Future<bool> _onBackButtonPressed() {
    Navigator.pop(context, "cancel");
    // "false" since we have handled the routing manually
    return new Future<bool>.value(false);
  }
}
