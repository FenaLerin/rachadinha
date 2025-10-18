import 'package:flutter/material.dart';
import 'package:rachadinha/utils/app_color.dart';

import '../../utils/enum.dart';

class CustomSnackbar {
  final String message;
  final SnackBarAction? action;
  final SnackStatus? snackStatus;
  const CustomSnackbar({
    required this.message,
    this.action,
    this.snackStatus,
  });

  SnackBar build() {
    return SnackBar(
      content: Text(message, maxLines: 5),
      behavior: SnackBarBehavior.floating,
      action: action,
      backgroundColor: _getColor(),
    );
  }

  Color _getColor() {
    switch (snackStatus) {
      case SnackStatus.normal:
        return AppColor.primary;
      case SnackStatus.error:
        return AppColor.red;
      case SnackStatus.alert:
        return AppColor.red;
      default:
        return AppColor.primary;
    }
  }
}
