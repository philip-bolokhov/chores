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
        title: Text('Edit the chore'),
      ),
      body: Center(
        child: Text(
          "Editing '${chore['title']}'",
          style: TextStyle(
              fontSize: 16, color: Colors.purple, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
