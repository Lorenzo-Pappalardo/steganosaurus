import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:steganosaurus/image_picker_and_preview.dart';
import 'package:steganosaurus/secret_message_input.dart';
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
  final int bitsToBeEmbeddedPerPixel = 2;
  final double padding = 16;

  String? coverImagePath;
  String? messageToEmbed;
  String? stegoImagePath;

  img.Image? image;

  void setCoverImage(String coverImagePath) async {
    final img.Image? image = await img.decodeImageFile(coverImagePath);

    setState(() {
      this.coverImagePath = coverImagePath;
      this.image = image;
    });
  }

  void setMessageToEmbed(String messageToEmbed) {
    setState(() {
      this.messageToEmbed = messageToEmbed;
    });
  }

  void setStegoImage(String stegoImagePath) async {
    final img.Image? image = await img.decodeImageFile(stegoImagePath);

    setState(() {
      this.stegoImagePath = stegoImagePath;
      this.image = image;
    });
  }

  void startProcessingImage(String imagePath, bool isEncoding) async {
    if (image != null) {
      if (isEncoding && messageToEmbed != null) {
        processImage(image!, messageToEmbed!);
      } else {
        extractSecretMessage(image!);
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
                  SecretMessageInput(
                      maxCharacters: image == null
                          ? 0
                          : image!.width *
                              image!.height *
                              bitsToBeEmbeddedPerPixel,
                      setMessageToEmbed: setMessageToEmbed),
                  FilledButton(
                      onPressed: image == null ||
                              messageToEmbed == null ||
                              messageToEmbed!.isEmpty
                          ? null
                          : () {
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
