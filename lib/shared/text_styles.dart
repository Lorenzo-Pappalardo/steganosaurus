import 'package:flutter/material.dart';

const double fontSizeDefault = 32;

TextStyle getBaseTextStyle(BuildContext context, double? fontSize) {
  return TextStyle(
      fontSize: fontSize ?? fontSizeDefault,
      color: Theme.of(context).colorScheme.primary);
}
