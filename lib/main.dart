import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<XFile?> _image = [];

  Future getImage(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final image = await ImagePicker().pickMultiImage();
        if (image == null) return;
        setState(() {
          this._image.addAll(image);
        });
      } else {
        final image = await ImagePicker().pickImage(source: ImageSource.camera);
        if (image == null) return;
        setState(() {
          if (this._image.length == 4) {
            print("you have to pick max of 4");
            return;
          }
          this._image.add(image);
        });
      }
      Navigator.pop(context);
    } on PlatformException catch (e) {
      print('Failed to pick image : $e');
    }
  }

  void deleteImage(int index) {
    setState(() {
      this._image.removeAt(index);
    });
  }

  // to store an image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),

      body: Center(
          child: Column(
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                    margin: EdgeInsets.all(15),
                    width: double.infinity,
                    height: 1000,
                    child: index >= _image.length
                        ? Container(
                            padding: EdgeInsets.all(15.0),
                            color: Color.fromARGB(255, 170, 182, 191),
                            margin: EdgeInsets.all(15),
                            width: double.infinity,
                          )
                        : Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                File(_image[index]!.path),
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                  top: 5,
                                  right: 10,
                                  child: Container(
                                    child: IconButton(
                                      onPressed: () => deleteImage(index),
                                      icon: Icon(Icons.remove_circle_outline),
                                      color: Color.fromARGB(221, 170, 6, 6),
                                      iconSize: 25.0,
                                    ),
                                    padding: EdgeInsets.all(1.0),
                                    margin: EdgeInsets.fromLTRB(0, 5.0, 0, 0.0),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(198, 233, 216, 34),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                    ),
                                  ))
                            ],
                          ));
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if (_image.length > 0 && (_image.length != 4))
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    child: RaisedButton(
                      onPressed: () {
                        _bottomSheet(context);
                      },
                      child: Text('click me'),
                    ),
                  ),
                  Container(
                      child: CustomButton(
                          title: 'Upload',
                          icon: Icons.image_outlined,
                          OnClick: () => null))
                ],
              ),
            ),
          if (_image.length == 4)
            CustomButton(
                title: 'Upload',
                icon: Icons.image_outlined,
                OnClick: () => null),
          if (_image.length == 0)
            CustomButton(
                title: 'pick from gallllery',
                icon: Icons.image_outlined,
                OnClick: () => _bottomSheet(context)),
        ],
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _bottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext c) {
          return Wrap(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Add',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(
                      height: 2.0,
                    ),
                    if (_image.length != 4)
                      CustomButton(
                          title: 'pick from gallllery',
                          icon: Icons.image_outlined,
                          OnClick: () => getImage(ImageSource.gallery)),
                    SizedBox(
                      height: 30,
                    ),
                    if (_image.length != 4)
                      CustomButton(
                          title: 'pick up for camera',
                          icon: Icons.image_outlined,
                          OnClick: () => getImage(ImageSource.camera)),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

Widget CustomButton({
  required String title,
  required IconData icon,
  required VoidCallback OnClick,
}) {
  return Container(
    width: 200,
    child: ElevatedButton(
        onPressed: OnClick,
        child: Row(
          children: <Widget>[
            Icon(icon),
            SizedBox(
              width: 20,
            ),
            Text(title),
          ],
        )),
  );
}
