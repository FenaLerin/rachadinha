import 'package:flutter/material.dart';
import 'package:rachadinha/utils/app_color.dart';

import '../../utils/app_size.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  final Widget? icon;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool active;
  final double? height;
  final ButtonStyle? style;

  const CustomTextButton({
    required this.title,
    required this.onPressed,
    super.key,
    this.icon,
    this.margin,
    this.padding,
    this.active = true,
    this.height,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? EdgeInsets.zero,
      child: TextButton(
        onPressed: active ? onPressed : () {},
        style: style ??
            TextButton.styleFrom(
              foregroundColor: active ? null : AppColor.grey_60,
              backgroundColor: active ? null : AppColor.grey_80,
            ),
        child: SizedBox(
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon ?? Container(),
              icon == null
                  ? Container()
                  : const SizedBox(width: AppSize.childSpacing),
              Flexible(child: Text(title)),
            ],
          ),
        ),
      ),
    );
  }
}
