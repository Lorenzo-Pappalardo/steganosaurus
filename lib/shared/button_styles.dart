import 'package:flutter/material.dart';

ButtonStyle get buttonStyle {
  return ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))));
}
