import 'package:flutter/material.dart';

class UnifiedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;

  const UnifiedAppBar({
    super.key,
    this.leading,
    this.title = "I-Eat",
    this.actions,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      automaticallyImplyLeading: showBackButton,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: "Signatra", 
          fontSize: 46,
          color: Colors.white,
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
        ),
      ),
      actions: actions, 
      actionsPadding: EdgeInsets.all(8),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}