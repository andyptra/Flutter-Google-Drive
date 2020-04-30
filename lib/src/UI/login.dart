import 'package:flutter/material.dart';
import 'package:techtest/src/Services/authGoogle.dart';
import 'package:techtest/src/Services/secureStorage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final authGoogle = AuthGoogle();
  final secureStore = SecureStorage();
  
  Color primaryColor = Colors.black;
  Color secondaryColor = Colors.white;
  Color thirdColor = Color.fromRGBO(17, 77, 153, 1.0);
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Center(
          child: new Builder(
            builder: (BuildContext context) {
              return new Stack(
                children: <Widget>[
                  new Container(
                    color: secondaryColor,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Wrap(children: <Widget>[
                    Center(child: _showLogo()),
                    Center(child: _showTextLogo()),
                    Center(child: showButton()),
                  ]),
                  // Center(child: showButton2()),
                 
                ],
              );
            },
          ),
        ));
  }

  Widget _showLogo() {
    return new Container(
      margin: EdgeInsets.only(top: 100.0),
      child: new Image.asset("assets/img/login_screen.jpg", width: 120.0),
    );
  }

  Widget _showTextLogo() {
    return new Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Text("SAVE MOMENT", style: TextStyle(fontSize: 18.0)),
    );
  }

  Widget showButton() {
    return Container(
      margin: EdgeInsets.only(top: 150.0),
      child: ButtonTheme(
        minWidth: 220.0,
        height: 40.0,
        child: FlatButton(
            color: thirdColor,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            
            child: Text("Login With Google",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold)), 
                    onPressed: () async{
            authGoogle.loginWithGoogle().whenComplete(() {

              Future.delayed(const Duration(seconds: 5), () {
                  Navigator.of(context).pushReplacementNamed('/home');
              });


            
            });
          },),
      ),
    );
  }
}
