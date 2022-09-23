import 'package:flutter/material.dart';
import 'package:my_right/styles/colors.dart';

navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

// ----------- Navigate And finish component ----------------
navigateAndFinish(
  context,
  widget,
) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) {
        return false;
      },
    );

// Default Button
Widget defaultTextButton({
  required Function()? function,
  required String text,
  IconData? icon,
  Color? color,
}) =>
    TextButton(
      onPressed: function,
      child: Row(
        children: [
          Text(
            text.toUpperCase(),
            style: TextStyle(color: color ?? mainColor, fontSize: 15),
          ),
          SizedBox(
            width: 1,
          ),
          Icon(
            icon,
            color: mainColor,
            size: 15,
          ),
        ],
      ),
    );


bool isNumeric(String s) {
 if (s == null) {
   return false;
 }
 return double.tryParse(s) != null;
}