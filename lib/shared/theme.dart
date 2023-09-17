import 'package:flutter/material.dart';

const Color accentColor = Color.fromRGBO(255, 33, 33, 1);

ColorScheme getColorScheme(Brightness brightness) {
  return ColorScheme.fromSwatch(
      brightness: brightness,
      accentColor: accentColor,
      primarySwatch: Colors.red);
}

FilledButtonThemeData get filledButtonThemeData {
  return const FilledButtonThemeData(
      style:
          ButtonStyle(backgroundColor: MaterialStatePropertyAll(accentColor)));
}

ElevatedButtonThemeData get elevatedButtonThemeData {
  return const ElevatedButtonThemeData(
      style:
          ButtonStyle(backgroundColor: MaterialStatePropertyAll(accentColor)));
}

ThemeData get lightTheme {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: accentColor,
    colorScheme: getColorScheme(Brightness.light),
    filledButtonTheme: filledButtonThemeData,
    elevatedButtonTheme: elevatedButtonThemeData,
  );
}

ThemeData get darkTheme {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: accentColor,
    colorScheme: getColorScheme(Brightness.dark),
    filledButtonTheme: filledButtonThemeData,
    elevatedButtonTheme: elevatedButtonThemeData,
  );
}

ThemeMode getThemeMode(BuildContext context) {
  final brightness = MediaQuery.of(context).platformBrightness;
  return brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark;
}
