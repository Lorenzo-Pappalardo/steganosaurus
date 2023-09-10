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
  final int bitsToBeEmbeddedPerPixel = 2;

  const Body({super.key, required this.modeOfOperation});

  @override
  State<StatefulWidget> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  static const double _padding = 16;

  String? coverImagePath;
  String? messageToEmbed;
  String? stegoImagePath;
  String? embeddedMessage;

  img.Image? _image;

  void _setImagePaths(String chosenImage) {
    setState(() {
      if (widget.modeOfOperation == ModeOfOperationEnum.generate) {
        coverImagePath = chosenImage;
      } else {
        stegoImagePath = chosenImage;
      }
    });
  }

  void _setImage(String chosenImage) async {
    final img.Image? image = await img.decodeImageFile(chosenImage);

    setState(() {
      _image = image;
    });
  }

  void _onImagePicked(String chosenImage) {
    _setImagePaths(chosenImage);
    _setImage(chosenImage);
  }

  void _setMessageToEmbed(String messageToEmbed) {
    setState(() {
      this.messageToEmbed = messageToEmbed;
    });
  }

  void _embedSecretMessage() {
    embedSecretMessage(_image!, messageToEmbed!);
  }

  void _extractSecretMessage() {
    setState(() {
      embeddedMessage = extractSecretMessage(_image!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
            padding: const EdgeInsets.all(_padding),
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
                        ImagePickerAndPreview(
                            key: const Key("generation"),
                            setImage: _onImagePicked)
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
                              maxCharacters: _image == null
                                  ? 0
                                  : _image!.width *
                                      _image!.height *
                                      widget.bitsToBeEmbeddedPerPixel,
                              setMessageToEmbed: _setMessageToEmbed),
                        ],
                      ),
                    ),
                    FilledButton(
                        onPressed: _image == null ||
                                messageToEmbed == null ||
                                messageToEmbed!.isEmpty
                            ? null
                            : () {
                                _embedSecretMessage();
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
                        ImagePickerAndPreview(
                            key: const Key("extraction"), setImage: _setImage)
                      ],
                    )),
                    FilledButton(
                        onPressed: () {
                          _extractSecretMessage();
                        },
                        style: buttonStyle,
                        child: const Text('Extract secret message')),
                    if (embeddedMessage != null)
                      MyCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Extracted secret message:',
                                style: getAccentedTextStyle(null)),
                            Text(
                              embeddedMessage!,
                              style: getBaseTextStyle(20),
                            )
                          ],
                        ),
                      ),
                  ]
                ]))
      ],
    );
  }
}
