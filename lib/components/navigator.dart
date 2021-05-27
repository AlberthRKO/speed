import 'package:flutter/material.dart';

class NavigatorLink extends StatelessWidget {
  const NavigatorLink({
    Key key,
    @required this.funcion,
    @required this.child,
  }) : super(key: key);
  final Function funcion;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: funcion,
      child: child,
    );
  }
}
