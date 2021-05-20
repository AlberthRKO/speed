import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InputControl extends StatelessWidget {
  const InputControl({
    Key key,
    @required this.hint,
    @required this.icon,
    @required this.controlador,
    this.validar,
  }) : super(key: key);

  final String hint;
  final dynamic icon;
  final dynamic controlador;
  final dynamic validar;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controlador,
      validator: validar,
      style: TextStyle(
        color: Theme.of(context).hintColor,
      ),
      obscureText: false,
      cursorColor: Theme.of(context).hintColor,
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red.shade600),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        helperStyle: TextStyle(color: Colors.black),
        suffixIcon: Icon(
          icon,
          size: 18,
          color: Theme.of(context).primaryColor,
        ),
        labelText: hint,
        labelStyle: TextStyle(color: Theme.of(context).hintColor),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
      ),
    );
  }
}

// input para form de contra
class InputControl2 extends StatefulWidget {
  const InputControl2({
    Key key,
    @required this.hint,
    @required this.controlador2,
    this.validar,
  }) : super(key: key);

  final String hint;
  final dynamic controlador2;
  final dynamic validar;

  @override
  _InputControl2State createState() => _InputControl2State();
}

class _InputControl2State extends State<InputControl2> {
  bool estadoPass = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controlador2,
      validator: widget.validar,
      style: TextStyle(
        color: Theme.of(context).hintColor,
      ),
      obscureText: estadoPass,
      cursorColor: Theme.of(context).hintColor,
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red.shade600),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        suffixIcon: IconButton(
          icon: estadoPass
              ? Icon(
                  FontAwesomeIcons.solidEyeSlash,
                  size: 18,
                  color: Theme.of(context).primaryColor,
                )
              : Icon(
                  FontAwesomeIcons.solidEye,
                  size: 18,
                  color: Theme.of(context).primaryColor,
                ),
          onPressed: () {
            setState(
              () {
                estadoPass = !estadoPass;
              },
            );
          },
        ),
        labelText: widget.hint,
        labelStyle: TextStyle(color: Theme.of(context).hintColor),
        hintText: widget.hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
      ),
    );
  }
}
