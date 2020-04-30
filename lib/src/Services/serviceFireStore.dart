import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:techtest/src/Model/UserModel.dart';

class ServiceFireStore {
  final db = Firestore.instance;
  List<UserModel> userModel;


  Future<void> addData(String driveID, String email) async {
    await db.collection("Users").document(email).setData({
      'driveID': driveID,
      'email': email,
    }).catchError((e) {
      print(e);
    });
  }
  
  getDataById(String email) async {
    var snapshot = await db.collection("Users").document(email).get();

    String driveID;
    if (snapshot.data == null) {
      driveID = null;
    } else {
      var data = UserModel.fromSnapshot(snapshot);
      driveID = data.driveID;
    }

    return driveID;
  }

}
