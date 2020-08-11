import 'package:cloud_firestore/cloud_firestore.dart';

///
/// Chore data as in the database
///
class Chore {
  String title;
  String description;

  Chore({this.title, this.description});

  Future<DocumentReference> add(CollectionReference collectionReference) {
    return collectionReference.add({
      'title': title,
      'description': description,
    });
  }

  Future<void> delete(DocumentReference documentReference) {
    return documentReference.delete();
  }
}
