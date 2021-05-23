import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';

class Progresso {
  static ProgressDialog crearProgress(context, msg) {
    ProgressDialog pr = new ProgressDialog(context);

    pr.style(
      message: msg,
      backgroundColor: Theme.of(context).cardColor,
      messageTextStyle: Theme.of(context).textTheme.bodyText1,
      progressWidget: SpinKitDoubleBounce(
        color: Theme.of(context).primaryColor,
      ),
      elevation: 10,
    );

    return pr;
  }
}
