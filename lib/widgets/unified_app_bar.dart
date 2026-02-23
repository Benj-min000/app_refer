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

  static const _iconShadow = [
    Shadow(
      color: Color(0x66000000),
      offset: Offset(2.0, 2.0),
      blurRadius: 4.0,
    ),
  ];

  Widget _withShadow(Widget child) {
    return IconTheme.merge(
      data: const IconThemeData(shadows: _iconShadow),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading != null ? _withShadow(leading!) : null,
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
      actions: actions?.map((w) => _withShadow(w)).toList(),
      actionsPadding: const EdgeInsets.all(8),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}