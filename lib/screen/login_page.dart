import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginManual extends StatefulWidget {
  @override
  _LoginManualState createState() => _LoginManualState();
}

class _LoginManualState extends State<LoginManual> {
  bool estadoPass = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: size.height * 0,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              width: 550,
              child: Image.asset(
                'assets/images/topWave.png',
              ),
            ),
            ListView(
              // oculta el teclado al hacer scroll
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                Container(
                  width: double.infinity,
                  height: size.height * 0.96,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      returnBack(context),
                      SvgPicture.asset(
                        'assets/images/login.svg',
                        height: size.height * 0.3,
                      ),
                      contentForm(context, size),
                      SizedBox(
                        height: 10,
                      ),
                      actionAccess(context),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget returnBack(context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(
              FontAwesomeIcons.arrowLeft,
              size: 20,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Text('Atras'),
        ],
      ),
    );
  }

  Widget contentForm(context, size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: size.height * 0.48,
        decoration: decoracion(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          child: formulario(context),
        ),
      ),
    );
  }

  BoxDecoration decoracion(context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(-4, 6),
          blurRadius: 4,
        )
      ],
    );
  }

  Widget formulario(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                'Inicia sesión con tu cuenta',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                inputController(
                    context, 'Email', FontAwesomeIcons.solidEnvelope),
                SizedBox(
                  height: 10,
                ),
                inputController2(context, 'Contraseña', FontAwesomeIcons.lock),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Olvido su contraseña ?',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
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
                    color: Theme.of(context).primaryColor,
                    onPressed: () {},
                    child: Text(
                      'Login',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget inputController(context, hint, icon) {
    return TextField(
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
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        suffixIcon: Icon(
          icon,
          size: 20,
        ),
        labelText: hint,
        labelStyle: TextStyle(color: Theme.of(context).hintColor),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
      ),
    );
  }

  Widget inputController2(context, hint, icon) {
    return TextField(
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
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        suffixIcon: IconButton(
          icon: estadoPass
              ? Icon(FontAwesomeIcons.solidEyeSlash)
              : Icon(FontAwesomeIcons.solidEye),
          onPressed: () {
            setState(() {
              estadoPass = !estadoPass;
            });
          },
        ),
        labelText: hint,
        labelStyle: TextStyle(color: Theme.of(context).hintColor),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
      ),
    );
  }

  Widget actionAccess(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'No tienes una cuenta ?',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          'Registrate',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ],
    );
  }
}
