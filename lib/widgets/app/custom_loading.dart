import 'package:flutter/material.dart';
import 'package:rachadinha/utils/app_size.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppSize.childSpacing),
        child: const CircularProgressIndicator(
          strokeWidth: 3,
        ),
      ),
    );
  }
}
