import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:techtest/src/Services/secureStorage.dart';
import 'package:techtest/src/Services/authGoogle.dart';
import 'package:techtest/src/Services/serviceFireStore.dart';
import 'package:techtest/src/Model/ImageModel.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:techtest/src/core/utils.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final firestore = ServiceFireStore();
  final storage = SecureStorage();
  bool isLoading = false;
  final authGoogle = AuthGoogle();
  List<Object> images = List<Object>();
  Future<File> _imageFile;
  ga.FileList list;
  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      for (var i = 0; i < 21; i++) {
        images.add("Add Image");
      }
    });
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

  Future _onAddImageClick(int index, int tipe) async {
    setState(() {
      if (tipe == 1) {
        _imageFile = ImagePicker.pickImage(
            source: ImageSource.gallery, imageQuality: 40);
      } else {
        _imageFile =
            ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 40);
      }

      getFileImage(index);
    });
  }

  void getFileImage(int index) async {
//    var dir = await path_provider.getTemporaryDirectory();

    _imageFile.then((file) async {
      setState(() {
        ImageUploadModel imageUpload = new ImageUploadModel();
        imageUpload.isUploaded = false;
        imageUpload.uploading = false;
        imageUpload.imageFile = file;
        imageUpload.imageUrl = file.path;
        images.replaceRange(index, index + 1, [imageUpload]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isLoading = true;
          });
          _uploadFileToGoogleDrive();
        },
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Icon(Icons.cloud_upload),
        ),
        elevation: 4.0,
      ),
      appBar: new AppBar(
          centerTitle: true,
          backgroundColor: CustomColors.BlueIcon,
          title: new Text(
            "Upload Photo",
            style: new TextStyle(color: Colors.white),
          ),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed('/home'))),
      body: Column(
        children: <Widget>[
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : buildGridView(),
          ),
        ],
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 1,
      children: List.generate(images.length, (index) {
        if (images[index] is ImageUploadModel) {
          ImageUploadModel uploadModel = images[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Image.file(
                  uploadModel.imageFile,
                  width: 300,
                  height: 300,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        images.replaceRange(index, index + 1, ['Add Image']);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Card(
              child: new ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.camera),
                color: Colors.blue,
                onPressed: () {
                  _onAddImageClick(index, 1);
                },
              ),
              IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () {
                  _onAddImageClick(index, 2);
                },
              ),
            ],
          ));
        }
      }),
    );
  }

  _uploadFileToGoogleDrive() async {
    var client = GoogleHttpClient(await authHeadersx);
    var drive = ga.DriveApi(client);
    var credentials = await storage.getCredentials();
    final String email = credentials["accEmail"];
    final String name = credentials["accName"];
    ga.File fileToUpload = ga.File();
    ga.File imageUpload = ga.File();

    final driveID = await firestore.getDataById(email);
    if (driveID != null) {
      for (var i = 0; i < images.length; i++) {
        if (images[i] is ImageUploadModel) {
          ImageUploadModel uploadModel = images[i];
          var file = uploadModel.imageFile;

          fileToUpload.parents = [driveID];
          // fileToUpload.mimeType = 'application/vnd.google-apps.folder';
          fileToUpload.name = path.basename(file.absolute.path);
          await drive.files
              .create(
            fileToUpload,
            uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
          )
              .whenComplete(() {
            setState(() {
              isLoading = false;
              Navigator.of(context).pushReplacementNamed('/home');
            });
          });
        }
      }
    } else {
      String nameFolder = name.replaceAll(' ', '-');
      fileToUpload.name = 'Data-$nameFolder';
      fileToUpload.mimeType = 'application/vnd.google-apps.folder';
      ga.File getID = await drive.files.create(
        fileToUpload,
      );
      var idDrive = getID.id;
      firestore.addData(idDrive, email);
      for (var i = 0; i < images.length; i++) {
        if (images[i] is ImageUploadModel) {
          ImageUploadModel uploadModel = images[i];

          var file = uploadModel.imageFile;

          imageUpload.parents = [idDrive];
          // fileToUpload.mimeType = 'application/vnd.google-apps.folder';
          imageUpload.name = path.basename(file.absolute.path);
          var response = await drive.files.create(
            imageUpload,
            uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
          );
          print(response);
          // _listGoogleDriveFiles(getID.driveId);
        }
      }
    }
  }

  Future<void> listGoogleDriveFiles() async {
    print("ddx");
    var client = GoogleHttpClient(await authHeadersx);
    var drive = ga.DriveApi(client);
    var folderID = '1cxfMxta1Zi1h0Gx_e06JcnKOjmYS_2EE';
    var q = "'$folderID' in parents";
    drive.files.list(q: q).then((value) {
      setState(() {
        list = value;
      });
      for (var i = 0; i < list.files.length; i++) {
        print("Id: ${list.files[i].id} File Name:${list.files[i].id}");
      }
    });
  }
}
