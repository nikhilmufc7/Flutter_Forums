import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImage extends StatefulWidget {
  UserImage(this.imagePickedFn);
  final void Function(File pickedImage) imagePickedFn;

  @override
  _UserImageState createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  File _image;
  final picker = ImagePicker();
  void _selectImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxWidth: 150, imageQuality: 50);

    setState(() {
      _image = File(pickedFile.path);
    });
    widget.imagePickedFn(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: _image != null,
          child: CircleAvatar(
            radius: 40,
            backgroundImage: _image != null ? FileImage(_image) : null,
          ),
        ),
        Visibility(
          visible: _image != null,
          child: SizedBox(
            width: 20,
          ),
        ),
        RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.deepPurpleAccent,
            onPressed: _selectImage,
            child: Row(
              children: [
                Icon(
                  Icons.image,
                  color: Colors.white60,
                ),
                SizedBox(width: 10),
                Text(
                  'Select your profile picture',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ))
      ],
    );
  }
}
