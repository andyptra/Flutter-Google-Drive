
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:techtest/src/Services/secureStorage.dart';
import 'package:techtest/src/ui/partial/appBar.dart';
import 'package:techtest/src/ui/partial/flexibleBar.dart';
import 'package:techtest/src/Services/authGoogle.dart';
import 'package:techtest/src/Services/serviceFireStore.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:cached_network_image/cached_network_image.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final firestore = ServiceFireStore();
  final storage = SecureStorage();
  final authGoogle = AuthGoogle();
  ga.FileList list;
  List<String> items = <String>[];
  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  void initState() {
   
    super.initState();
  }

  Color darkBlue = Color(0xff071d40);
  Color lightBlue = Color(0xff1b4dff);

  Future<Map<String, String>> get authHeadersx async {
    var credentials = await storage.getCredentials();
    final String token = credentials["accToken"];
    return <String, String>{
      "Authorization": "Bearer $token",
      "X-Goog-AuthUser": "0",
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Expanded(
          child: _buildBody(),
        ),
      ],
    ));
  }

  listGoogleDriveFiles() async {
    var client = GoogleHttpClient(await authHeadersx);
    var drive = ga.DriveApi(client);
    var credentials = await storage.getCredentials();
    final String email = credentials["accEmail"];
    final driveID = await firestore.getDataById(email);

    var q = "'$driveID' in parents";
    drive.files.list(q: q).then((value) {
      setState(() {
        list = value;
      });
      for (var i = 0; i < list.files.length; i++) {
        print("Id: ${list.files[i].id} File Name:${list.files[i].id}");
      }
    });
  }

  Widget _buildBody() {
    return CustomScrollView(
      slivers: <Widget>[appBar(), sliderImage()],
    );
  }

  Row titlerow(String title) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text(
            "$title",
            style: Theme.of(context)
                .textTheme
                .title
                .apply(color: darkBlue, fontWeightDelta: 2),
          ),
        )
      ],
    );
  }

  SliverAppBar appBar() {
    return SliverAppBar(
      title: MyAppBar(),
      expandedHeight: 200.0,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: FlexibleBar(),
      ),
    );
  }

  SliverToBoxAdapter sliderImage() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                color: darkBlue,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Total Photo",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 11.0,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "201",
                          style: Theme.of(context)
                              .textTheme
                              .display1
                              .apply(color: Colors.white, fontWeightDelta: 2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 11.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 11.0),
                          color: darkBlue,
                          onPressed: () {
                             
                          },
                          child: Text(
                            'Profile',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(9.0),
                              side: BorderSide(color: Colors.white)),
                        ),
                      ),
                      Flexible(
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 11.0),
                          color: darkBlue,
                          onPressed: () {
                             Navigator.of(context).pushReplacementNamed('/upload');
                          },
                          child: Text(
                            'Upload',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(9.0),
                              side: BorderSide(color: Colors.white)),
                        ),
                      ),
                      Flexible(
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 11.0),
                          color: lightBlue,
                          onPressed: () {},
                          child: Text(
                            'All Photo',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(9.0),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divider(
              height: 30,
            ),
            // titlerow("Latest Upload"),
            // sliderPhoto()
          ],
        ),
      ),
    );
  }

Widget sliderPhoto(){
  return Container(
              child: SizedBox(
                height: 150,
                child:  FutureBuilder(
                  future: Future.delayed(Duration(seconds: 3)),
                  builder: (context, snapshot) {
                    return ListView.builder(
                        itemExtent: 150,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Container(
                              padding: EdgeInsets.all(5.0),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://www.googleapis.com/drive/v3/files/15t5wI3fjOaNQJXGjbxFpbADA9oJW78lk",
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                height: 120,
                                placeholder: (context, url) =>
                                    new CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    new Icon(Icons.error),
                              ),
                              margin: EdgeInsets.all(0.0),
                            ),
                        itemCount: list.files.length);
                  }
                ),
              ),
            );
}
  SliverGrid gridPhoto() {
    return SliverGrid(
      gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200.0,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 0.0,
        childAspectRatio: 1.0,
      ),
      delegate: new SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return new Container(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: CachedNetworkImage(
                imageUrl:
                    "https://drive.google.com/uc?id=1649GbVNwUVxVq13-wCDjhWdHwGynkp0M",
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
          );
        },
        childCount: 20,
      ),
    );
  }
}
