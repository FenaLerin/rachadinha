import 'package:flutter/material.dart';
import 'package:rachadinha/utils/app_size.dart';

import '../app/custom_line_widget.dart';

class ButtonHollowWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function() onPressed;
  const ButtonHollowWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(
          // top: AppSize.mainSpacing,
          right: AppSize.asd,
          left: AppSize.asd,
        ),
        child: Container(
          margin: const EdgeInsets.only(top: AppSize.asd),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon),
              const SizedBox(width: AppSize.asd * 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.start,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: AppSize.asd),
                      child: CustomLineWidget(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
