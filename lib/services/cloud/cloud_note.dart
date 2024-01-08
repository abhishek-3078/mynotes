
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  final DateTime createdAt;

  const CloudNote({
  required this.documentId,
  required this.ownerUserId,
  required this.text,
  required this.createdAt
});

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String,dynamic>>snapshot ): documentId=snapshot.id,
  ownerUserId=snapshot.data()[ownerUserIdFieldName],
  text=snapshot.data()[textFieldName] as String,
  createdAt = snapshot.data().containsKey("created_at")
          ? (snapshot.data()["created_at"] as Timestamp).toDate()
          : DateTime(2000,1,1);
  
}