import 'package:flutter/material.dart';
import 'package:get/get.dart';

void snackError({@required title, @required msg}) {
  return Get.snackbar(
    title,
    msg,
    // icon: Icon(FontAwesomeIcons.exclamation),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red[400],
  );
}
