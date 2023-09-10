import 'package:flutter/material.dart';
import 'package:steganosaurus/home.dart';
import 'package:steganosaurus/shared/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steganosaurus',
      themeMode: ThemeMode.system,
      theme: theme,
      home: const SafeArea(child: Home()),
      color: accentColor,
    );
  }
}
