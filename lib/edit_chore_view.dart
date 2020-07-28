import 'package:flutter/material.dart';

class EditChoreView extends StatelessWidget {
  final dynamic chore;

  EditChoreView({this.chore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            print("navigating back");
            Navigator.pop(context);
          },
        ),
        title: Text('Edit chore details'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: chore['title'],
                    decoration: InputDecoration(
                      labelText: 'Chore title',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    minLines: 2,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RaisedButton(
                  child: Text('Save'),
                  onPressed: () {},
                ),
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
