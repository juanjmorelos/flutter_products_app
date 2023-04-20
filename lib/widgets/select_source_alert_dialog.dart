import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showSourceAlertDialogIOS(BuildContext context, Widget child, String titulo, List<Widget> actions) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(titulo),
        content: child,
        actions: actions
      );
    }
  );
}

void showSourceAlertDialogAndroid(BuildContext context, Widget child, String titulo, List<Widget> actions) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        title: Text(titulo),
        content: child,
        actions: actions
      );
    }
  );
}
