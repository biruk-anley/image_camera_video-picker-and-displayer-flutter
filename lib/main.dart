import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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
    } on PlatformException catch (e) {
      print('Failed to pick image : $e');
    }
  }

  Future getVideo(ImageSource source) async {
    try {
      final video = await ImagePicker().pickVideo(source: source);
      if (video == null) return;
      setState(() {
        this._image.add(video);
      });
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
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                    width: 400,
                    height: 400,
                    child: index >= _image.length
                        ? Container(
                            color: Colors.blue,
                            margin: EdgeInsets.all(10),
                          )
                        : Stack(
                            children: [
                              Image.file(File(_image[index]!.path)),
                              Positioned(
                                  top: 10,
                                  right: 10,
                                  child: IconButton(
                                      onPressed: () => deleteImage(index),
                                      icon: Icon(Icons.remove_circle)))
                            ],
                          ));
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          CustomButton(
              title: 'pick from gallllery',
              icon: Icons.image_outlined,
              OnClick: () => getImage(ImageSource.gallery)),
          SizedBox(
            height: 30,
          ),
          CustomButton(
              title: 'pick from video',
              icon: Icons.image_outlined,
              OnClick: () => getVideo(ImageSource.gallery)),
          SizedBox(
            height: 30,
          ),
          CustomButton(
              title: 'pick from Camera',
              icon: Icons.image_outlined,
              OnClick: () => getImage(ImageSource.camera))
        ],
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
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
