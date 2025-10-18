import 'package:flutter/material.dart';
import 'package:rachadinha/utils/app_color.dart';
import 'package:shimmer/shimmer.dart';

class CustomImage extends StatelessWidget {
  final String url;
  final Widget? icon;
  const CustomImage({
    super.key,
    required this.url,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (url == "") {
      return Container(
        color: AppColor.white,
        child: icon ??
            const Icon(
              Icons.local_hospital,
              color: AppColor.primary,
            ),
      );
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Container(
          color: AppColor.white,
          child: icon ??
              const Icon(
                Icons.local_hospital,
                color: AppColor.primary,
              ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Shimmer.fromColors(
          baseColor: AppColor.grey_20,
          highlightColor: AppColor.grey_30,
          child: Container(color: AppColor.primary),
        );
      },
    );
  }
}
