import 'dart:math';

import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets outerPadding =
      const EdgeInsets.symmetric(horizontal: 0, vertical: 16);
  final EdgeInsets innerPadding =
      const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  final Radius borderRadius = const Radius.circular(4);
  final Offset boxShadowOffset = Offset.fromDirection(3 / 4 * pi, 4);

  MyCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: outerPadding,
      child: Container(
        padding: innerPadding,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.all(borderRadius),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).primaryColor,
                  offset: boxShadowOffset)
            ],
            border: Border.all(color: Theme.of(context).primaryColor)),
        child: child,
      ),
    );
  }
}
