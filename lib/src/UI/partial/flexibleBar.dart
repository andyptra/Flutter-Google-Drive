import 'package:flutter/material.dart';

Color darkBlue = Color(0xff071d40);

class FlexibleBar extends StatelessWidget {
 
  final double appBarHeight = 66.0;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return new Container(
      padding: new EdgeInsets.only(top: 100),
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      height: statusBarHeight + appBarHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Hello,",
            style: Theme.of(context)
                .textTheme
                .display1
                .apply(color: Colors.grey[500]),
          ),
          Text(
            "Welcome To Moment",
            style: Theme.of(context)
                .textTheme
                .display1
                .apply(color: darkBlue, fontWeightDelta: 2),
          ),
        ],
      ),
    );
  }
}
