import 'package:flutter/material.dart';

class CustomErrorMessage extends StatelessWidget {
  final String? errorMessage;
  
  const CustomErrorMessage({
    super.key,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (errorMessage == null) return SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade300, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                errorMessage!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}