import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbar({required String msg, required String submsg}) {
  GetSnackBar snackbar = GetSnackBar(
    backgroundColor: Colors.black45,
    duration: const Duration(seconds: 15),
    titleText: Text(msg),
    messageText: Text(submsg),
  );
  Get.showSnackbar(snackbar);
}
