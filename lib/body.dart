import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:steganosaurus/home.dart';
import 'package:steganosaurus/image_picker_and_preview.dart';
import 'package:steganosaurus/secret_message_input.dart';
import 'package:steganosaurus/shared/button_styles.dart';
import 'package:steganosaurus/shared/card.dart';
import 'package:steganosaurus/shared/steganography.dart';
import 'package:steganosaurus/shared/text_styles.dart';

class Body extends StatefulWidget {
  final ModeOfOperationEnum modeOfOperation;

  const Body({super.key, required this.modeOfOperation});

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

  void setImage(String chosenImage) async {
    final img.Image? image = await img.decodeImageFile(chosenImage);

    setState(() {
      if (widget.modeOfOperation == ModeOfOperationEnum.generate) {
        coverImagePath = coverImagePath;
      } else {
        stegoImagePath = coverImagePath;
      }

      this.image = image;
    });
  }

  void setMessageToEmbed(String messageToEmbed) {
    setState(() {
      this.messageToEmbed = messageToEmbed;
    });
  }

  void processImage() async {
    if (widget.modeOfOperation == ModeOfOperationEnum.generate) {
      embedSecretMessage(image!, messageToEmbed!);
    } else {
      extractSecretMessage(image!);
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
                  if (widget.modeOfOperation ==
                      ModeOfOperationEnum.generate) ...[
                    MyCard(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Choosing a picture',
                            style: getAccentedTextStyle(null)),
                        ImagePickerAndPreview(setImage: setImage)
                      ],
                    )),
                    Text(
                      'Then...',
                      style: getBaseTextStyle(20),
                    ),
                    MyCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Write a secret message',
                              style: getAccentedTextStyle(null)),
                          SecretMessageInput(
                              maxCharacters: image == null
                                  ? 0
                                  : image!.width *
                                      image!.height *
                                      bitsToBeEmbeddedPerPixel,
                              setMessageToEmbed: setMessageToEmbed),
                        ],
                      ),
                    ),
                    FilledButton(
                        onPressed: image == null ||
                                messageToEmbed == null ||
                                messageToEmbed!.isEmpty
                            ? null
                            : () {
                                processImage();
                              },
                        style: buttonStyle,
                        child: const Text('Generate stego image'))
                  ],
                  if (widget.modeOfOperation ==
                      ModeOfOperationEnum.extract) ...[
                    MyCard(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Choosing a picture',
                            style: getAccentedTextStyle(null)),
                        ImagePickerAndPreview(setImage: setImage)
                      ],
                    )),
                    FilledButton(
                        onPressed: () {
                          processImage();
                        },
                        style: buttonStyle,
                        child: const Text('Extract secret message'))
                  ]
                ]))
      ],
    );
  }
}
