import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
    required String labelText,
    String? hintText,
    required Color borderColors,
    required Color labelColor,
    Widget? icon,
    bool? outlineBorder = false
  }) {
    return InputDecoration(
        enabledBorder: outlineBorder! ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: borderColors 
          )
        ) : UnderlineInputBorder(
            borderSide: BorderSide(
              color: borderColors
            )
        ),
        focusedBorder: outlineBorder ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: borderColors, 
            width: 2
          )
        ) : UnderlineInputBorder(
            borderSide: BorderSide(
              color: borderColors,
              width: 2
            )
          ),
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(color: labelColor),
        prefixIcon: icon
      );
  }
}
