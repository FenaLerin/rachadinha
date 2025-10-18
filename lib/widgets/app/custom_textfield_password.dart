import 'package:flutter/material.dart';
import 'package:rachadinha/utils/app_color.dart';

import '../../utils/app_size.dart';
import '../buttons/obscure_icon_button.dart';
import 'custom_textfield.dart';

class CustomTextFieldPassword extends StatefulWidget {
  final String title;
  final TextEditingController tectrlPassword;
  final String? Function(String?)? validator;
  const CustomTextFieldPassword({
    super.key,
    required this.title,
    required this.tectrlPassword,
    this.validator,
  });

  @override
  State<CustomTextFieldPassword> createState() =>
      _CustomTextFieldPasswordState();
}

class _CustomTextFieldPasswordState extends State<CustomTextFieldPassword> {
  final ObscureIconButtonController isHideCtrl = ObscureIconButtonController();
  // var maskFormatter = new MaskTextInputFormatter(mask: '+# (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomTextField(
          textEditingController: widget.tectrlPassword,
          margin: EdgeInsets.zero,
          label: widget.title,
          validator: widget.validator,
          obscureText: isHideCtrl.isHide,
          enableSuggestions: false,
          autocorrect: false,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isHideCtrl.isHide = !isHideCtrl.isHide;
            });
          },
          child: Container(
              height: 42.5 + AppSize.asd,
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(AppSize.asd),
              child: Icon(
                isHideCtrl.isHide
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColor.black_40,
              )),
        ),
      ],
    );
  }
}
