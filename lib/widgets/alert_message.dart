import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void alertMessage(String message) async {
  await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
