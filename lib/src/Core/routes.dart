import 'package:flutter/material.dart';
import 'package:techtest/src/ui/splashScreen.dart' as splashScreen;
import 'package:techtest/src/ui/login.dart' as login;
import 'package:techtest/src/ui/home.dart' as home;
import 'package:techtest/src/ui/uploadPage.dart' as upload;

class Routes {
  final routes = <String, WidgetBuilder>{
    "/login": (BuildContext context) => new login.Login(),
    "splashScreen": (BuildContext context) => new splashScreen.SplashScreen(),
    "/home": (BuildContext context) => new home.Home(),
    "/upload": (BuildContext context) => new upload.UploadPage(),
  };
}
