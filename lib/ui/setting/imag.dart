import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';

class imag extends StatefulWidget {
  imag({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _imagState createState() => _imagState();
}

class _imagState extends State<imag> {
  File _image;

  Future getImage(ImgSource source) async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
    );
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 300,
                child: RaisedButton(
                  onPressed: () => getImage(ImgSource.Gallery),
                  color: Colors.blue,
                  child: Text(
                    "From Gallery".toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: RaisedButton(
                  onPressed: () => getImage(ImgSource.Camera),
                  color: Colors.deepPurple,
                  child: Text(
                    "From Camera".toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: RaisedButton(
                  onPressed: () => getImage(ImgSource.Both),
                  color: Colors.red,
                  child: Text(
                    "Both".toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              _image != null ? Image.file(_image) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
