import 'dart:async';

import 'package:techtest/src/core/utils.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
          color: CustomColors.primaryColor,
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Center(
                child: new Container(
                  child: new Image.asset(
                    "assets/img/city.png",
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
