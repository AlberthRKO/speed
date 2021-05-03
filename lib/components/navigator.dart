import 'package:flutter/material.dart';

class NavigatorLink extends StatelessWidget {
  const NavigatorLink({
    Key key,
    @required this.vista,
    this.typeAnimation = Curves.fastOutSlowIn,
    @required this.child,
  }) : super(key: key);
  final Widget vista;
  final Widget child;
  final Curve typeAnimation;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (context, animation, animationTime) => vista,
          transitionsBuilder: (context, animation, animationTime, child) {
            animation = CurvedAnimation(
              parent: animation,
              curve: typeAnimation,
            );
            return ScaleTransition(
              scale: animation,
              alignment: Alignment.center,
              child: child,
            );
          },
        ),
      ),
      child: child,
    );
  }
}
