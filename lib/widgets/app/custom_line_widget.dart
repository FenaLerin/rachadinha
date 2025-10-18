import 'package:rachadinha/utils/app_size.dart';
import 'package:flutter/material.dart';

class CustomLineWidget extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final Color? color;
  const CustomLineWidget({
    super.key,
    this.margin,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.line,
      color: color ?? Theme.of(context).colorScheme.inversePrimary,
      margin: margin,
    );
  }
}
