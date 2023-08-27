import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:steganosaurus/shared/steganography.dart';

class ImagePickerAndPreview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImagePickerAndPreviewState();
}

class _ImagePickerAndPreviewState extends State<ImagePickerAndPreview> {
  final _imagePicker = ImagePicker();

  String? _coverImageFilePath;

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _coverImageFilePath = pickedImage.path;
      });

      img.Image? coverImage = await img.decodeImageFile(_coverImageFilePath!);

      if (coverImage != null) {
        processImage(coverImage, "Hello World!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _openImagePicker,
      child: const Text('Select An Image'),
    );
  }
}
