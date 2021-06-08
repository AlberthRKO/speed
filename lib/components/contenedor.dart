import 'dart:math';
import 'package:flutter/material.dart';

class ContenedorAnimado extends StatelessWidget {
  final Widget child;
  final double xOffset;
  final double yOffset;
  final bool isDrawerOpen;

  const ContenedorAnimado({
    Key key,
    this.child,
    this.xOffset,
    this.yOffset,
    this.isDrawerOpen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      // hacemos una transformacion de ejes y una rotacion
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(isDrawerOpen ? 0.90 : 1.00)
        ..rotateZ(isDrawerOpen ? pi / 20 : 0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
            isDrawerOpen ? BorderRadius.circular(25) : BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(-4, 6),
            blurRadius: 4,
          )
        ],
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }
}
