import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:steganosaurus/shared/button_styles.dart';

class ImagePickerAndPreview extends StatefulWidget {
  final Function setImage;

  const ImagePickerAndPreview({super.key, required this.setImage});

  @override
  State<StatefulWidget> createState() => _ImagePickerAndPreviewState();
}

class _ImagePickerAndPreviewState extends State<ImagePickerAndPreview> {
  final _imagePicker = ImagePicker();

  String? imagePath;

  void setImagePath(String pickedImagePath) {
    imagePath = pickedImagePath;

    setState(() {
      widget.setImage(imagePath);
    });
  }

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setImagePath(pickedImage.path);
    }
  }

  List<Widget> get children {
    List<Widget> children = [];
    List<Widget> toolbarChildren = [
      ElevatedButton(
        onPressed: _openImagePicker,
        style: buttonStyle,
        child: const Text('Select an image'),
      ),
    ];

    bool imageChosen = imagePath != null;

    if (imageChosen) {
      children.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.file(File(imagePath!)),
      ));

      /* toolbarChildren.add(ElevatedButton(
        onPressed: () {},
        style: buttonStyle,
        child: const Text('Next'),
      )); */
    }

    children.add(Row(
      mainAxisAlignment: /* imageChosen
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.center, */
          MainAxisAlignment.center,
      children: toolbarChildren,
    ));

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: children,
      ),
    );
  }
}
