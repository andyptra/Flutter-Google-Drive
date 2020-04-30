
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:techtest/src/Services/secureStorage.dart';

class GoogleHttpClient extends IOClient {
  Map<String, String> _headers;
  GoogleHttpClient(this._headers) : super();
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      super.send(request..headers.addAll(_headers));
  @override
  Future<http.Response> head(Object url, {Map<String, String> headers}) =>
      super.head(url, headers: headers..addAll(_headers));
}

class AuthGoogle {
  final storageSecure = SecureStorage();
  final storage = new FlutterSecureStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/drive',
    'https://www.googleapis.com/auth/datastore'
  ]);
  GoogleSignInAccount googleSignInAccount;
  ga.FileList list;
  var signedIn = false;
  Future<void> loginWithGoogle() async {
    signedIn = await storage.read(key: "signedIn") == "true" ? true : false;
    googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount googleSignInAccount) async {
      if (googleSignInAccount != null) {
        _afterGoogleLogin(googleSignInAccount);
      }
    });
    if (signedIn) {
      try {
        googleSignIn.signInSilently().whenComplete(() => () {});
      } catch (e) {
        storageSecure.saveStatusLogin("false").then((value) {
          signedIn = false;
        });
      }
    } else {
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
        _afterGoogleLogin(googleSignInAccount);
    }
  }

  Future<void> _afterGoogleLogin(GoogleSignInAccount gSA) async {
    googleSignInAccount = gSA;

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    await storageSecure.saveCredentials(googleSignInAuthentication.accessToken,
        user.displayName, user.email, user.photoUrl);

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    storageSecure.saveStatusLogin("true").then((value) {
      signedIn = true;
    });
  }

  Future<void> signOutGoogle() async {
    await storageSecure.clear();
    await googleSignIn.signOut();
  }
}




