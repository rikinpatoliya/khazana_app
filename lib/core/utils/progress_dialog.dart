import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

late CustomProgressDialog _progressDialog;

void showProgressDialog(BuildContext context) {
  final progressDialog = CustomProgressDialog(
    context,
    blur: 2,
    dismissable: false,
    backgroundColor: const Color(0x33000000),
    dialogTransitionType: DialogTransitionType.Bubble,
    transitionDuration: const Duration(milliseconds: 300),
  );
  _progressDialog = progressDialog;
  _progressDialog.show();
}

void dismissDialog() {
  _progressDialog.dismiss();
}
