import 'package:flutter/material.dart';

class SecretMessageInput extends StatelessWidget {
  final int maxCharacters;
  final Function setMessageToEmbed;
  final EdgeInsets outerPadding =
      const EdgeInsets.symmetric(horizontal: 0, vertical: 16);

  const SecretMessageInput(
      {super.key,
      required this.maxCharacters,
      required this.setMessageToEmbed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: outerPadding,
      child: TextField(
        enabled: maxCharacters > 0,
        maxLength: maxCharacters > 0 ? maxCharacters : null,
        onChanged: (value) {
          setMessageToEmbed(value);
        },
        decoration: const InputDecoration(labelText: 'Message to embed...'),
      ),
    );
  }
}
