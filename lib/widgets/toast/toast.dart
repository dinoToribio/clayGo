import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class Toast {
  static void showSuccessMsg({
    required BuildContext context,
    required String message,
  }) {
    toastification.show(
      context: context,
      title: Text(message),
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 2),
      showProgressBar: false,
    );
  }

    static void showErrorMsg({
    required BuildContext context,
    required String message,
  }) {
    toastification.show(
      context: context,
      title: Text(message),
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 2),
      showProgressBar: false,
    );
  }
}
