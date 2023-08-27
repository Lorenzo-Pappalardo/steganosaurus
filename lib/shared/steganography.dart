import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';

const String stegoImageName = "stegoImage.png";
const String endOfEmbeddedMessage = "[*LP*]";

Future<String?> get _outputPath async {
  final Directory? directory = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getDownloadsDirectory();
  return directory?.path;
}

Future<File> get _outputFile async {
  final path = await _outputPath;
  return File('$path/$stegoImageName');
}

String addPadding(String value) {
  int neededPadding = 8 - value.length;
  String padding = "";

  for (var i = 0; i < neededPadding; i++) {
    padding += "0";
  }

  return padding;
}

void processImage(Image coverImage, String messageToEmbed,
    {int bitsToBeEmbeddedPerPixel = 2}) async {
  messageToEmbed += endOfEmbeddedMessage;

  final List<int> messageToEmbedBytes = utf8.encode(messageToEmbed);
  final Iterable<String> messageToEmbedPixels =
      messageToEmbedBytes.map((e) => addPadding(e.toRadixString(2)));

  final Uint8List coverImageBytes = coverImage.toUint8List();
  final List<String> coverImagePixels =
      coverImageBytes.map((e) => e.toRadixString(2)).toList();

  int coverImageNextPixelIndex = 0;
  for (String bits in messageToEmbedPixels) {
    int i = 0;
    while (i < bits.length) {
      String coverImageBits = coverImagePixels[coverImageNextPixelIndex];

      coverImageBits = addPadding(coverImageBits) + coverImageBits;

      bool isLastIteration = i + bitsToBeEmbeddedPerPixel > bits.length;
      String patchedBits = coverImageBits.substring(
              0, coverImageBits.length - bitsToBeEmbeddedPerPixel) +
          bits.substring(
              i, isLastIteration ? null : i + bitsToBeEmbeddedPerPixel);

      coverImagePixels[coverImageNextPixelIndex] = patchedBits;

      coverImageNextPixelIndex++;
      i += bitsToBeEmbeddedPerPixel;
    }
  }

  final Uint8List stegoImage = Uint8List.fromList(
      coverImagePixels.map((e) => int.parse(e, radix: 2)).toList());

  final Uint8List pngOutput = encodePng(Image.fromBytes(
      width: coverImage.width,
      height: coverImage.height,
      bytes: stegoImage.buffer));

  await (await _outputFile).writeAsBytes(pngOutput);

  print("Message embedded successfully");
}
