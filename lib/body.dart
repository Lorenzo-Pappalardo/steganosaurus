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
  String? stegoImagePath;

  void setCoverImage(String coverImagePath) {
    setState(() {
      this.coverImagePath = coverImagePath;
    });
  }

  void setStegoImage(String stegoImage) {
    setState(() {
      this.stegoImagePath = stegoImage;
    });
  }

  void startProcessingImage(String imagePath, bool isEncoding) async {
    final chosenImage = await img.decodeImageFile(imagePath);

    if (chosenImage != null) {
      if (isEncoding) {
        processImage(chosenImage, "messageToEmbed");
      } else {
        extractSecretMessage(chosenImage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Begin by...',
                    style: getBaseTextStyle(20),
                  ),
                  MyCard(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Choosing a picture',
                          style: getAccentedTextStyle(null)),
                      ImagePickerAndPreview(setImage: setCoverImage)
                    ],
                  )),
                  FilledButton(
                      onPressed: () {
                        startProcessingImage(coverImagePath!, true);
                      },
                      style: buttonStyle,
                      child: const Text('Generate stego image')),
                  MyCard(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Choosing a picture',
                          style: getAccentedTextStyle(null)),
                      ImagePickerAndPreview(setImage: setStegoImage)
                    ],
                  )),
                  FilledButton(
                      onPressed: () {
                        startProcessingImage(stegoImagePath!, false);
                      },
                      style: buttonStyle,
                      child: const Text('Extract secret message'))
                ])),
      ],
    );
  }
}
