import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:my_right/styles/colors.dart';

class DefaultFormField extends StatelessWidget {
  String? label;
  TextEditingController? controller;
  TextInputType? type;
  void Function(String)? onSubmit;
  void Function(String)? onChange;
  void Function(String?)? onSaved;
  void Function()? onTap;
  TextDirection? textDirection;
  bool isPassword = false;
  String? Function(String?)? validate;
  IconData? prefix;
  IconData? suffix;
  void Function()? suffixPressed;
  void Function()? prefixPressed;
  bool isClickable = true;
  bool isSuffix = false;
  int? minLines;
  int? maxLines;
  double? borderWidth;
  String? hintText;
  Color? prefixColorIcon;
  Color? suffixColorIcon;
  Color? fillColor;
  Color? hintColor;
  Color borderColor = Colors.grey;
  Color? labelColor;
  Color focusedColorBorder;
  String? intialVal;
  bool autoFocus;
  Key? key;
  TextAlignVertical? textAlignVertical;
  TextAlign? textAlign;
  TextStyle? style;

  DefaultFormField(
      {this.key,
      this.controller,
      this.isClickable = true,
      this.isPassword = false,
      this.isSuffix = false,
      this.label,
      this.onChange,
      this.onSaved,
      this.onSubmit,
      this.onTap,
      this.textDirection,
      this.prefix,
      this.suffix,
      this.suffixPressed,
      this.prefixPressed,
      this.textAlignVertical = TextAlignVertical.center,
      this.textAlign,
      this.type,
      this.validate,
      this.minLines,
      this.maxLines,
      this.borderWidth = 10.0,
      this.hintText,
      this.prefixColorIcon,
      this.suffixColorIcon,
      this.fillColor,
      this.hintColor,
      required this.borderColor,
      this.labelColor,
      this.focusedColorBorder = Colors.grey,
      this.intialVal,
      this.autoFocus = false,
      this.style});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
          key: key,
          controller: controller,
          style: style ?? Theme.of(context).textTheme.bodyText2,
          keyboardType: type,
          obscureText: isPassword,
          textAlign: textAlign??TextAlign.start,
          enabled: isClickable,
          onFieldSubmitted: onSubmit,
          onSaved: onSaved,
          autofocus: autoFocus,
          cursorColor: mainColor,
          onChanged: onChange,
          initialValue: intialVal,
          onTap: onTap,
          textDirection: textDirection ?? TextDirection.rtl,
          validator: validate,
          minLines: minLines,
          textAlignVertical: textAlignVertical,
          maxLines: maxLines,
          decoration: InputDecoration(
              floatingLabelAlignment: FloatingLabelAlignment.start,
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: mainColor, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(borderWidth!)),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(borderWidth!)),
              ),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              hintText: hintText,
              hintTextDirection: TextDirection.rtl,
              hintStyle: TextStyle(color: hintColor),
              contentPadding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor, width: 0),
                borderRadius: BorderRadius.all(Radius.circular(borderWidth!)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: focusedColorBorder, width: .5),
                borderRadius: BorderRadius.all(Radius.circular(borderWidth!)),
              ),
              labelText: label,
              labelStyle: TextStyle(color: labelColor),
              
              prefixIcon: prefix != null
                  ? IconButton(
                      icon: Icon(
                        prefix,
                        color: prefixColorIcon ?? Colors.grey,
                      ),
                      onPressed: prefixPressed,
                    )
                  : null,
              suffixIcon: isSuffix
                  ? IconButton(
                      onPressed: suffixPressed,
                      icon: Icon(
                        suffix,
                        color: suffixColorIcon ?? Colors.grey,
                      ))
                  : null)),
    );
  }
}
