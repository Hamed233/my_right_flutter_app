import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:my_right/blocs/general_app_cubit/app_general_cubit.dart';
import 'package:my_right/layout/client_sheet.dart';
import 'package:my_right/layout/installment_sheet.dart';

class Helper {
  static showCustomSnackBar(BuildContext context,
      {required String content,
      required Color bgColor,
      required Color textColor}) {
    final snackBar = SnackBar(
      content: Text(
        content,
        style: TextStyle(
          color: textColor,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: bgColor.withOpacity(0.7),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static showAddClientBottomSheet(BuildContext context,
      {bool isUpdate = false, int clientId = 0}) {
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      enableDrag: true,
      topRadius: Radius.circular(20),
      backgroundColor: Colors.transparent,
      builder: (context) => ClientSheet(isUpdate, clientId),
    ).then((value) {
      AppCubit.get(context).leftPrice = 0.0;
      AppCubit.get(context).totalPrice = 0.0;
      AppCubit.get(context).payedPrice = 0.0;
    });
  }

  static showInstallmentBottomSheet(BuildContext context, clientId) {
    AppCubit.get(context).getClientData(clientId);
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      enableDrag: true,
      topRadius: Radius.circular(20),
      backgroundColor: Colors.transparent,
      builder: (context) => InstallmentSheet(clientId),
    );
  }
}
