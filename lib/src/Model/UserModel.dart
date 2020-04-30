import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String driveID;
  String email;

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.documentID,
        driveID = snapshot['driveID'] ??'',
        email = snapshot['email'] ?? '';
}
