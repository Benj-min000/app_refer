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
  final shadowDecoration = BoxDecoration(
    shape: BoxShape.circle, 
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.06),
        blurRadius: 6,
        offset: const Offset(1, 1),
      ),
    ],
  );

  final Widget? shadowedLeading = leading != null
      ? Container(
          margin: const EdgeInsets.all(8),
          decoration: shadowDecoration,
          child: leading,
        )
      : null;

    final List<Widget>? shadowedActions = actions?.map((widget) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: shadowDecoration,
        child: widget,
      );
    }).toList();

    return AppBar(
      leading: shadowedLeading,
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
      actions: shadowedActions,
      actionsPadding: const EdgeInsets.all(8),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}