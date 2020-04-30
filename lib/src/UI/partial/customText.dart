import 'package:flutter/material.dart';

class CustomText {
  final String label;
  final double fontSize;
  final String fontName;
  final int textColor;
  final int iconColor;
  final TextAlign textAlign;
  final int maxLines;
  final IconData icon;

  CustomText(
      {@required this.label,
      this.fontSize = 10.0,
      this.fontName,
      this.textColor = 0xFF000000,
      this.iconColor = 0xFF000000,
      this.textAlign = TextAlign.start,
      this.maxLines = 1,
        this.icon=Icons.broken_image
      });

  Widget text() {
    var text = new Text(
      label,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: new TextStyle(
        color: Color(textColor),
        fontSize: fontSize,
        fontFamily: fontName,
      ),
    );

    return new Row(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.all(10.0),
          child: new Icon(icon,color: Color(iconColor),),
        ),
        text
      ],
    );
  }
}