import 'package:flutter/material.dart';
import 'package:steganosaurus/shared/theme.dart';

const double fontSizeDefault = 32;

TextStyle getBaseTextStyle(double? fontSize) {
  return TextStyle(fontSize: fontSize ?? fontSizeDefault);
}

TextStyle getAccentedTextStyle(double? fontSize) {
  TextStyle baseTextStyle = getBaseTextStyle(fontSize);

  return baseTextStyle.merge(TextStyle(color: theme.primaryColor));
}
