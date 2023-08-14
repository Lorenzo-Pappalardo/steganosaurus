import 'package:flutter/material.dart';

const Color accentColor = Color.fromRGBO(255, 55, 55, 1);

ThemeData theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: accentColor,
  ),
  fontFamily: 'Roboto',
  useMaterial3: true,
);
