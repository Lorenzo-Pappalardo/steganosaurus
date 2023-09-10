import 'package:flutter/material.dart';
import 'package:steganosaurus/body.dart';

enum ModeOfOperationEnum { generate, extract }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ModeOfOperationEnum _modeOfOperation = ModeOfOperationEnum.generate;

  void setModeOfOperation(ModeOfOperationEnum newModeOfOperationEnum) {
    setState(() {
      _modeOfOperation = newModeOfOperationEnum;
    });
  }

  int get navigationBarActiveIndex =>
      _modeOfOperation == ModeOfOperationEnum.generate ? 0 : 1;

  void setNewModeOfOperation(int tappedIndex) {
    setModeOfOperation(tappedIndex == 0
        ? ModeOfOperationEnum.generate
        : ModeOfOperationEnum.extract);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Body(modeOfOperation: _modeOfOperation),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: navigationBarActiveIndex,
            onTap: setNewModeOfOperation,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.enhanced_encryption), label: 'Embed'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.lock_open), label: 'Extract')
            ]));
  }
}
