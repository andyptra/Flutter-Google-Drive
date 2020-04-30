import 'package:techtest/src/core/routes.dart';
import 'package:flutter/material.dart';
import 'package:techtest/src/core/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:techtest/src/ui/splashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 
  Routes routes = new Routes();
  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
      title: 'MOMENTKU',
      initialRoute: '/',
      routes: routes.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        buttonTheme: ButtonThemeData(
          height: 50.0,
          alignedDropdown: true,
        ),
        fontFamily: 'Nunito',
        cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: CustomColors.secondaryColor
        ),
        cursorColor: CustomColors.secondaryColor,
        primaryColor: CustomColors.bgColor,
        primarySwatch: Colors.blue,
        primaryTextTheme: new TextTheme(
          title: new TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0)
        ),
        inputDecorationTheme: new InputDecorationTheme(
          hintStyle: TextStyle(
            color: CustomColors.fontColor,
            fontSize: 18.0
          ),
          border: new UnderlineInputBorder(
            borderSide: new BorderSide(
              color: CustomColors.fontColor
            )
          )
        )
      ),
      home: new SplashScreen(),
    );
    return materialApp;
  }
}