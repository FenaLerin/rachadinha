import 'package:rachadinha/utils/app_size.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Icon icon;
  final void Function() onPressed;
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      child: Container(
        padding: const EdgeInsets.all(AppSize.childSpacing),
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: icon,
      ),
    );
  }
}
