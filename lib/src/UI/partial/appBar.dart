import 'package:flutter/material.dart';
import 'package:techtest/src/Services/authGoogle.dart';

Color darkBlue = Color(0xff071d40);

class MyAppBar extends StatelessWidget {
  final authGoogle = AuthGoogle();
  final double barHeight = 66.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Save Moment',
                style: TextStyle(
                    color: darkBlue, fontFamily: 'Poppins', fontSize: 20.0),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                  color: darkBlue,
                  onPressed: () {
                    authGoogle.signOutGoogle().whenComplete(() {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (_) => false);
                    });
                  },
                  icon: Icon(Icons.power_settings_new)),
            ),
          ),
        ],
      ),
    );
  }

 
}
