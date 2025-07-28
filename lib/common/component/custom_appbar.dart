import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final String imagePath;
  final List<Widget>? actions;

  const CommonAppBar({
    Key? key,
    this.showBack = false, // default is false
    required this.imagePath,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 1,
      backgroundColor: Colors.white,
      leading: showBack
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      )
          : const SizedBox(width: kToolbarHeight), // keeps title centered
      title: Image.asset(
        imagePath,
        height: 40,
      ),
      centerTitle: true,
      actions: actions ?? [const SizedBox(width: 48)], // to balance the back button
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
