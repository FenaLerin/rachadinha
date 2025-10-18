
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(70);

  final String title;
  final String? toolTip;
  final IconData icon;
  final void Function()? onPressed;

  const CustomAppbar({
    super.key,
    this.title = "",
    this.toolTip = "Voltar",
    this.icon = Icons.arrow_back_ios,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Icon(icon, size: 15),
          tooltip: toolTip,
          onPressed: onPressed ??
              () {
                Navigator.of(context).pop();
                FocusScope.of(context).unfocus();
              },
        ),
      ),
    );
  }
}
