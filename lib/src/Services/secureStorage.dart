import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class SecureStorage {
  final storage = FlutterSecureStorage();

  //Save Credentials
  Future saveCredentials(String accToken, String name, String email, String imageURL) async {
    
    await storage.write(key: "accToken", value: accToken);
    await storage.write(key: "accName", value: name);
    await storage.write(key: "accEmail", value: email);
    await storage.write(key: "accImageURL", value: imageURL);
  }

   Future saveStatusLogin(String statusLogin) async {
    
    await storage.write(key: "signedIn", value: statusLogin);
   
  }

  //Get Saved Credentials
  Future<Map<String, dynamic>> getCredentials() async {
    var result = await storage.readAll();
    if (result.length == 0) return null;
    return result;
  }




  //Clear Saved Credentials
  Future clear() {
    return storage.deleteAll();
  }
}