import 'package:flutter/material.dart';

class AuthButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color color;

  const AuthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = 220,
    this.height = 56,
    this.color = const Color(0xFFF48FB1), // Colors.pink.shade300
  });

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: _pressed ? widget.color : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: widget.color,
            width: 2,
          ),
          boxShadow: _pressed
              ? [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.5),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _pressed ? Colors.white : widget.color,
              letterSpacing: 0.5,
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
