import 'package:flutter/material.dart';
import 'package:rachadinha/utils/app_color.dart';

import '../../utils/app_size.dart';
import '../buttons/custom_text_button.dart';

class CustomBottomButton extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  final bool active;
  const CustomBottomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.active = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.height + (AppSize.asd * 2),
      color: AppColor.white,
      child: CustomTextButton(
        title: title,
        padding: const EdgeInsets.all(AppSize.asd),
        active: active,
        onPressed: onPressed,
      ),
    );
  }
}
