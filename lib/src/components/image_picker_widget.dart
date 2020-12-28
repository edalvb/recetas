import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef OnImageSelected = Function(PickedFile imageFile);

class ImagePickerWidget extends StatelessWidget {
  final PickedFile imageFile;
  final OnImageSelected onImageSelected;

  const ImagePickerWidget(
      {@required this.imageFile, @required this.onImageSelected, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.cyan[300],
            Colors.cyan[800],
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        image: imageFile != null
            ? DecorationImage(
                image: FileImage(File(imageFile.path)),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: IconButton(
        icon: Icon(Icons.camera_alt),
        onPressed: () => _showPickerOptions(context),
        iconSize: 90,
        color: Colors.white,
      ),
    );
  }

  _showPickerOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Cámara"),
              onTap: () {
                Navigator.pop(context);
                _showPickerImage(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Galería"),
              onTap: () {
                Navigator.pop(context);
                _showPickerImage(context, ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  _showPickerImage(BuildContext context, ImageSource source) async {
    final _picker = ImagePicker();
    var image = await _picker.getImage(source: source);
    this.onImageSelected(image);
  }
}
