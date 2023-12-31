import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:steganosaurus/home.dart';
import 'package:steganosaurus/shared/theme.dart';

void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steganosaurus',
      themeMode: getThemeMode(context),
      theme: lightTheme,
      darkTheme: darkTheme,
      home: ProgressHUD(child: const SafeArea(child: Home())),
    );
  }
}
