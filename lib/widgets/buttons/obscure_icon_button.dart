import 'package:flutter/material.dart';
import 'package:rachadinha/utils/app_color.dart';

import '../../utils/app_size.dart';

class ObscureIconButtonController {
  bool isHide = true;
}

class ObscureIconButton extends StatefulWidget {
  final ObscureIconButtonController controller;
  const ObscureIconButton({
    super.key,
    required this.controller,
  });

  @override
  State<ObscureIconButton> createState() => _ObscureIconButtonState();
}

class _ObscureIconButtonState extends State<ObscureIconButton> {
  bool isHide = true;
  @override
  void initState() {
    isHide = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.controller.isHide = !widget.controller.isHide;
          isHide = widget.controller.isHide;
          print('setState');
        });
      },
      child: Container(
          height: 42.5 + AppSize.asd,
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.all(AppSize.asd),
          child: Icon(
            isHide ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: AppColor.black_40,
          )),
    );
  }
}
