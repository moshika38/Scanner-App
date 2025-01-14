import 'package:flutter/material.dart';
import 'package:scanner/core/utils/colors.dart';
 
class CustomSnackBar {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.red,
              ),
        ),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.brown,
              ),
        ),
      ),
    );
  }
}
