import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final double taman;
  const Background({
    Key key,
    @required this.child,
    @required this.taman,
  }) : super(key: key);

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
              width: taman,
              child: Image.asset(
                'assets/images/topWave.png',
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
