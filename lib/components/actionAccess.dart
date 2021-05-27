import 'package:flutter/material.dart';

class ActionAccess extends StatelessWidget {
  const ActionAccess({
    Key key,
    @required this.text,
    @required this.textLink,
    @required this.funcion,
    @required this.typeAnimation,
  }) : super(key: key);

  final String text;
  final String textLink;
  final Function funcion;
  final Curve typeAnimation;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          child: Text(
            textLink,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onTap: funcion,
        ),
      ],
    );
  }
}
