import 'package:flutter/material.dart';

class ActionAccess extends StatelessWidget {
  const ActionAccess({
    Key key,
    @required this.text,
    @required this.textLink,
    @required this.Vista,
    @required this.typeAnimation,
  }) : super(key: key);

  final String text;
  final String textLink;
  final Widget Vista;
  final Curve typeAnimation;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          child: Text(
            textLink,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(seconds: 1),
              pageBuilder: (context, animation, animationTime) => Vista,
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
        ),
      ],
    );
  }
}
