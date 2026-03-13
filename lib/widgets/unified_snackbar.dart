import 'package:flutter/material.dart';
import 'package:user_app/extensions/extensions_import.dart';

void unifiedSnackBar(BuildContext context, String msg, {bool error = false}) {
  final brandColors = Theme.of(context).extension<BrandColors>();
  final colorScheme = Theme.of(context).colorScheme;
  final overlay = Overlay.of(context);

  final Color bgColor = error
      ? Colors.redAccent.shade700
      : (brandColors?.navy ?? colorScheme.primary);

  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => _SnackBarToast(
      msg: msg,
      error: error,
      bgColor: bgColor,
      onDismiss: () => overlayEntry.remove(),
    ),
  );

  overlay.insert(overlayEntry);
}

class _SnackBarToast extends StatefulWidget {
  final String msg;
  final bool error;
  final Color bgColor;
  final VoidCallback onDismiss;

  const _SnackBarToast({
    required this.msg,
    required this.error,
    required this.bgColor,
    required this.onDismiss,
  });

  @override
  State<_SnackBarToast> createState() => _SnackBarToastState();
}

class _SnackBarToastState extends State<_SnackBarToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // 3 second duration as requested
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controller.forward();

    // Auto-dismiss when the progress bar finishes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 16, // Aligned to the right
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity, // Shorter/fixed width
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      widget.error
                          ? Icons.error_outline
                          : Icons.check_circle_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.msg,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextButton(
                      onPressed: widget.onDismiss,
                      child: Text(context.l10n.snackbar_dismiss,
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12)),
                    ),
                  ],
                ),
              ),
              // Progress Bar
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: 1.0 - _controller.value, // Shrinks as time passes
                    minHeight: 3,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withValues(alpha: 0.5)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
