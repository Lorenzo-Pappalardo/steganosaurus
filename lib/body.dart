import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
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

  @override
  void didUpdateWidget(covariant Body oldWidget) {
    _image = null;
    embeddedMessage = null;
    super.didUpdateWidget(oldWidget);
  }

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

  void _embedSecretMessage(BuildContext context) {
    final progress = ProgressHUD.of(context);
    progress?.show();

    embedSecretMessage(
            _image!, messageToEmbed!, widget.bitsToBeEmbeddedPerPixel)
        .then((succeeded) {
      progress?.dismiss();
    });
  }

  void _extractSecretMessage(BuildContext context) async {
    final progress = ProgressHUD.of(context);
    progress?.show();

    final extractionResult =
        await extractSecretMessage(_image!, widget.bitsToBeEmbeddedPerPixel);

    progress?.dismiss();

    setState(() {
      embeddedMessage = extractionResult;
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
                    style: getBaseTextStyle(context, 20),
                  ),
                  if (widget.modeOfOperation ==
                      ModeOfOperationEnum.generate) ...[
                    MyCard(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Choosing a picture',
                            style: getBaseTextStyle(context, null)),
                        ImagePickerAndPreview(
                            key: const Key("generation"),
                            setImage: _onImagePicked)
                      ],
                    )),
                    if (_image != null) ...[
                      Text(
                        'Then...',
                        style: getBaseTextStyle(context, 20),
                      ),
                      MyCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Write a secret message',
                                style: getBaseTextStyle(context, null)),
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
                                  _embedSecretMessage(context);
                                },
                          style: buttonStyle,
                          child: const Text('Generate stego image'))
                    ]
                  ],
                  if (widget.modeOfOperation ==
                      ModeOfOperationEnum.extract) ...[
                    MyCard(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Choosing a picture',
                            style: getBaseTextStyle(context, null)),
                        ImagePickerAndPreview(
                            key: const Key("extraction"), setImage: _setImage)
                      ],
                    )),
                    if (_image != null)
                      FilledButton(
                          onPressed: () {
                            _extractSecretMessage(context);
                          },
                          style: buttonStyle,
                          child: const Text('Extract secret message')),
                    if (embeddedMessage != null)
                      MyCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Extracted secret message:',
                                style: getBaseTextStyle(context, null)),
                            Text(
                              embeddedMessage!,
                              style: getBaseTextStyle(context, 20),
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
