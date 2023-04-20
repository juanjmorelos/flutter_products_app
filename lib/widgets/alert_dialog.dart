import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showAlertDialogIOS(BuildContext context, String texto, String titulo, List<Widget> actions) {
  showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
            title: Text(titulo),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(texto),
              ],
            ),
            actions: actions
          );
      });
}

void showAlertDialogAndroid(BuildContext context, String texto, String titulo, List<Widget> actions) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          title: Text(titulo),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(texto)
            ],
          ),
          actions: actions);
    }
  );
}
