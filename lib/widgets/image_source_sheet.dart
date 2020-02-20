import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final Function(File) onImageSelected;

  const ImageSourceSheet({this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton(
              child: Text('Câmera'),
              onPressed: () async {
                File image =
                    await ImagePicker.pickImage(source: ImageSource.camera);
                imageSelected(image);
              }),
          FlatButton(
              child: Text('Galeria'),
              onPressed: () async {
                File image =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                imageSelected(image);
              })
        ],
      ),
      onClosing: () {},
    );
  }

  Future<void> imageSelected(File image) async {
    if (image != null) {
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio16x9
          ]);
      onImageSelected(croppedImage);
    }
  }
}
