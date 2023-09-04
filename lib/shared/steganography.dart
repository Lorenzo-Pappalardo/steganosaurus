import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

const String stegoImageName = "stegoImage.bmp";
const String endOfEmbeddedMessage = "[*LP*]";
const int defaultBitsToBeEmbeddedPerPixel = 2;

Future<String?> get _outputPath async {
  Directory? directory;

  if (Platform.isAndroid) {
    directory = Directory("/storage/emulated/0/Download");

    if (!directory.existsSync()) {
      directory = Directory("/storage/emulated/0/Downloads");
    }
  } else {
    directory = await getDownloadsDirectory();
  }

  return directory?.path;
}

Future<File> get _outputFile async {
  final path = await _outputPath;
  return File('$path/$stegoImageName');
}

Future<bool> embedSecretMessage(Image coverImage, String messageToEmbed,
    {int bitsToBeEmbeddedPerPixel = defaultBitsToBeEmbeddedPerPixel}) async {
  messageToEmbed += endOfEmbeddedMessage;

  final String messageToEmbedBinary = messageToEmbed.codeUnits
      .map((x) => x.toRadixString(2).padLeft(8, '0'))
      .join();

  final List<String> coverImageBytes = coverImage
      .toUint8List()
      .map((e) => e.toRadixString(2).padLeft(8, '0'))
      .toList();

  int coverImageNextByteToModify = 0;
  for (int i = 0;
      i < messageToEmbedBinary.length;
      i += bitsToBeEmbeddedPerPixel) {
    final bitsToEmbed =
        messageToEmbedBinary.substring(i, i + bitsToBeEmbeddedPerPixel);
    final String original = coverImageBytes[coverImageNextByteToModify];
    final String modified =
        original.substring(original.length - bitsToBeEmbeddedPerPixel) +
            bitsToEmbed;
    coverImageBytes[coverImageNextByteToModify] = modified;
    coverImageNextByteToModify++;
  }

  final Uint8List stegoImage = Uint8List.fromList(
      coverImageBytes.map((e) => int.parse(e, radix: 2)).toList());

  final Uint8List encodedStegoImage = encodeBmp(Image.fromBytes(
      width: coverImage.width,
      height: coverImage.height,
      bytes: stegoImage.buffer));

  if (await Permission.manageExternalStorage.request().isGranted) {
    // Either the permission was already granted before or the user just granted it.
    await (await _outputFile).writeAsBytes(encodedStegoImage, flush: true);

    if (kDebugMode) {
      print("Message embedded successfully");
    }

    return true;
  }

  if (kDebugMode) {
    print("Message could not be embedded as the permission was denied");
  }
  return false;
}

String extractSecretMessage(Image stegoImage,
    {int bitsToBeEmbeddedPerPixel = defaultBitsToBeEmbeddedPerPixel}) {
  final List<String> stegoImageBytes = stegoImage
      .toUint8List()
      .map((e) => e.toRadixString(2).padLeft(8, '0'))
      .toList();

  final String endOfEmbeddedMessageBinary = endOfEmbeddedMessage.codeUnits
      .map((x) => x.toRadixString(2).padLeft(8, '0'))
      .join();

  String secretMessageBinary = "";

  for (String byte in stegoImageBytes) {
    secretMessageBinary +=
        byte.substring(byte.length - bitsToBeEmbeddedPerPixel);

    if (secretMessageBinary.endsWith(endOfEmbeddedMessageBinary)) {
      secretMessageBinary = secretMessageBinary.substring(
          0, secretMessageBinary.length - endOfEmbeddedMessageBinary.length);
      break;
    }
  }

  List<int> decodedMessageBytes = [];
  for (int i = 0; i < secretMessageBinary.length; i += 8) {
    String byte = secretMessageBinary.substring(i, i + 8);
    decodedMessageBytes.add(int.parse(byte, radix: 2));
  }

  String secretMessage = String.fromCharCodes(decodedMessageBytes);

  if (kDebugMode) {
    print('Extracted embedded message: $secretMessage');
  }

  return secretMessage;
}
