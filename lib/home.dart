import 'package:flutter/material.dart';
import 'package:steganosaurus/body.dart';

enum ModeOfOperationEnum { generate, extract }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ModeOfOperationEnum modeOfOperation = ModeOfOperationEnum.generate;

  void setModeOfOperation(ModeOfOperationEnum newModeOfOperationEnum) {
    setState(() {
      modeOfOperation = newModeOfOperationEnum;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Body(modeOfOperation: modeOfOperation),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex:
                modeOfOperation == ModeOfOperationEnum.generate ? 0 : 1,
            onTap: (int tappedNavigationItem) {
              setModeOfOperation(tappedNavigationItem == 0
                  ? ModeOfOperationEnum.generate
                  : ModeOfOperationEnum.extract);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Image')
            ]));
  }
}
