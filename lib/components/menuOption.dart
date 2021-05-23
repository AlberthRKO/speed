import 'package:flutter/material.dart';

class MenuOption extends StatelessWidget {
  const MenuOption({
    Key key,
    @required this.text,
    @required this.icono,
    this.link,
  }) : super(key: key);

  final String text;
  final IconData icono;
  final Function link;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: link,
      child: Row(
        children: [
          Icon(
            icono,
            size: 18,
            color: Theme.of(context).hintColor,
          ),
          SizedBox(
            width: 10,
          ),
          Text(text),
        ],
      ),
    );
  }
}
