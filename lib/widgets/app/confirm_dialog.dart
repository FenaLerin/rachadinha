import 'package:rachadinha/utils/app_color.dart';
import 'package:rachadinha/utils/app_size.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String message;
  final VoidCallback onConfirm;

  const ConfirmDialog({
    super.key,
    required this.message,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    required String message,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ConfirmDialog(
        message: message,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.asd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSize.asd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSize.asd),
            Text(
              "Confirmação",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: AppSize.asd),
            Text(
              message,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSize.asd * 1.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColor.grey_20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.radius),
                      ),
                    ),
                    child: const Text("Não"),
                  ),
                ),
                const SizedBox(width: AppSize.asd),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.radius),
                      ),
                    ),
                    child: const Text("Sim"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
