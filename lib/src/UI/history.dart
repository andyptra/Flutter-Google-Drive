// import 'package:crypto_app/global.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

Color darkBlue = Color(0xff071d40);
Color lightBlue = Color(0xff1b4dff);

class HistoryContainer extends StatelessWidget {
  final int id;
  final String url;
  const HistoryContainer({Key key, @required this.id, this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: CachedNetworkImage(
        imageUrl:
            "https://drive.google.com/uc?id=1649GbVNwUVxVq13-wCDjhWdHwGynkp0M",
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        height: 120,
        placeholder: (context, url) => new CircularProgressIndicator(),
        errorWidget: (context, url, error) => new Icon(Icons.error),
      ),
      margin: EdgeInsets.all(0.0),
    );
  }
}
