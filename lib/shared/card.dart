import 'dart:math';

import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final Widget child;

  MyCard({super.key, required this.child});

  final EdgeInsets padding =
      const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  final Radius borderRadius = const Radius.circular(4);
  final Offset boxShadowOffset = Offset.fromDirection(3 / 4 * pi, 4);

  BorderSide getBorder(Color color) {
    return BorderSide(color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.all(borderRadius),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).primaryColor,
                offset: boxShadowOffset,
                blurStyle: BlurStyle.solid)
          ],
          border: Border.all(color: Theme.of(context).primaryColor)),
      child: child,
    );
  }
}
