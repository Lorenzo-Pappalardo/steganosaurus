import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:steganosaurus/image_picker_and_preview.dart';
import 'package:steganosaurus/shared/button_styles.dart';
import 'package:steganosaurus/shared/card.dart';
import 'package:steganosaurus/shared/steganography.dart';
import 'package:steganosaurus/shared/text_styles.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<StatefulWidget> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final double padding = 16;

  String? coverImagePath;

  void setCoverImage(String coverImagePath) {
    setState(() {
      this.coverImagePath = coverImagePath;
    });
  }

  void startProcessingImage() async {
    final coverImage = await img.decodeImageFile(coverImagePath!);

    if (coverImage != null) {
      processImage(coverImage, "messageToEmbed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(padding),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(
            'Begin by...',
            style: getBaseTextStyle(20),
          ),
          MyCard(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Choosing a picture', style: getAccentedTextStyle(null)),
              ImagePickerAndPreview(setCoverImage: setCoverImage)
            ],
          )),
          FilledButton(
              onPressed: startProcessingImage,
              style: buttonStyle,
              child: const Text('Generate stego image'))
        ]));
  }
}
