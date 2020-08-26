import 'package:cloud_firestore/cloud_firestore.dart';

///
/// Chore data as in the database
///
class Chore {
  String title;
  String description;

  Chore({this.title, this.description});

  void add(WriteBatch batch, DocumentReference documentReference) {
    return batch.setData(
        documentReference, {'title': title, 'description': description});
  }

  void delete(WriteBatch batch, DocumentReference documentReference) {
    return batch.delete(documentReference);
  }
}
