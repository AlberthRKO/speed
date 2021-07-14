import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key key,
    @required this.imagen,
    this.radio = 40,
  }) : super(key: key);

  final Widget imagen;
  final double radio;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(radio),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(-4, 6),
            blurRadius: 4,
          )
        ],
      ),
      child: CircleAvatar(
        radius: radio,
        child: ClipOval(
          child: imagen,
        ),
      ),
    );
  }
}

class IconCircle extends StatelessWidget {
  const IconCircle({
    Key key,
    this.radio = 20,
    @required this.function,
    @required this.icono,
  }) : super(key: key);

  final double radio;
  final Function function;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(radio),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(-4, 6),
            blurRadius: 4,
          )
        ],
      ),
      child: CircleAvatar(
        backgroundColor: Theme.of(context).cardColor,
        radius: radio,
        child: IconButton(
          onPressed: function,
          icon: Icon(
            icono,
            size: 20,
            color: Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }
}
