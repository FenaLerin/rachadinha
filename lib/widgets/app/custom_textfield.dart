import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rachadinha/utils/app_size.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String label;
  final EdgeInsetsGeometry? margin;
  final String? hintText;
  final String? helperText;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? mask;
  final FocusNode? focusNode;
  final void Function(String)? onChange;
  final TextInputType? textInputType;
  final TextAlign textAlign;
  final int? maxLines;
  final int? minLines;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;

  const CustomTextField({
    required this.textEditingController,
    required this.label,
    super.key,
    this.margin,
    this.hintText,
    this.helperText,
    this.enabled = true,
    this.padding,
    this.validator,
    this.mask,
    this.focusNode,
    this.onChange,
    this.textInputType,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.minLines = 1,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.textInputAction = TextInputAction.done,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: padding ?? EdgeInsets.zero,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: AppSize.asd),
      child: TextFormField(
        controller: textEditingController,
        validator: validator ?? (t) => null,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        inputFormatters: mask,
        focusNode: focusNode,
        onChanged: onChange,
        keyboardType: textInputType,
        textAlign: textAlign,
        maxLines: maxLines,
        minLines: minLines,
        obscureText: obscureText,
        enableSuggestions: enableSuggestions,
        autocorrect: autocorrect,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          enabled: enabled,
          labelText: label,
          hintText: hintText,
          helperText: helperText,
          labelStyle: TextStyle(color: theme.colorScheme.primary),
          hintStyle: TextStyle(color: theme.hintColor),
          helperStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
          fillColor: theme.inputDecorationTheme.fillColor ?? theme.colorScheme.surface,
          filled: true,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.primary),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.secondary),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.error),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.error),
          ),
        ),
      ),
    );
  }
}
