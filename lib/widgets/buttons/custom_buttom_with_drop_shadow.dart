import 'package:flutter/material.dart';
import 'package:rachadinha/utils/app_color.dart';

import '../../utils/app_size.dart';
import 'custom_text_button.dart';

class CustomButtomWithDropShadow extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  final bool active;
  const CustomButtomWithDropShadow({
    super.key,
    required this.title,
    required this.onPressed,
    this.active = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.height + (AppSize.asd * 2),
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 3,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: CustomTextButton(
          title: title,
          padding: const EdgeInsets.all(AppSize.asd),
          active: active,
          onPressed: onPressed),
    );
  }
}
