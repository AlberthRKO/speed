import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    Key key,
    @required this.texto,
    @required this.color,
    @required this.funcion,
  }) : super(key: key);
  final String texto;
  final Color color;
  final dynamic funcion;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 5,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FlatButton(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          color: color,
          onPressed: funcion,
          child: Text(
            texto,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      ),
    );
  }
}
