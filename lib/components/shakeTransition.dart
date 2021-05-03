import 'package:flutter/material.dart';

class ShakeTransition extends StatelessWidget {
  const ShakeTransition({
    Key key,
    // indicamos los parametros por defecto
    this.duration = const Duration(milliseconds: 1200),
    this.offset = 140.0,
    @required this.child,
    this.axis = Axis.horizontal,
    this.typeAnimation = Curves.elasticOut,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  final Curve typeAnimation;
  // la distancia que se movera
  final double offset;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      child: child,
      // le decimos como va a animar..desde 1 a 0
      tween: Tween(begin: 1, end: 0),
      // elejimos el tipo de anicacion
      curve: typeAnimation,
      // la duracion de la animacion que por defecto es 900
      duration: duration,
      // el contructor que recibira el transform
      builder: (context, value, child) {
        return Transform.translate(
          // le indicamos como arrancara la animacion desde el eje x
          offset: axis == Axis.horizontal
              ? Offset(value * offset, 0)
              : Offset(0, value * offset),
          child: child,
        );
      },
    );
  }
}

class ShakeTransition2 extends StatelessWidget {
  const ShakeTransition2({
    Key key,
    // indicamos los parametros por defecto
    this.duration = const Duration(milliseconds: 1200),
    this.offset = 140.0,
    @required this.child,
    this.axis = Axis.horizontal,
    this.typeAnimation = Curves.elasticOut,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  // la distancia que se movera
  final double offset;
  final Curve typeAnimation;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      child: child,
      // le decimos como va a animar..desde 1 a 0
      tween: Tween(begin: 1, end: 0),
      // elejimos el tipo de anicacion
      curve: typeAnimation,
      // la duracion de la animacion que por defecto es 900
      duration: duration,
      // el contructor que recibira el transform
      builder: (context, value, child) {
        return Transform.translate(
          // le indicamos como arrancara la animacion desde el eje x
          offset: axis == Axis.horizontal
              ? Offset(-(value * offset), 0)
              : Offset(0, -(value * offset)),
          child: child,
        );
      },
    );
  }
}
