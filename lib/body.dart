import 'package:flutter/material.dart';
import 'package:steganosaurus/image_picker_and_preview.dart';
import 'package:steganosaurus/shared/card.dart';
import 'package:steganosaurus/shared/text_styles.dart';

class Body extends StatelessWidget {
  final double padding = 16;

  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(padding),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, (padding / 2)),
            child: Text(
              'Begin by...',
              style: getBaseTextStyle(20),
            ),
          ),
          MyCard(
              child: Column(
            children: [
              Text('Choosing a picture', style: getAccentedTextStyle(null)),
              ImagePickerAndPreview()
            ],
          ))
        ]));
  }
}
