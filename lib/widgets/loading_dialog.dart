import 'package:flutter/material.dart';
import 'package:user_app/widgets/progress_bar.dart';

class LoadingDialog extends StatelessWidget {
  final String? message;
  const LoadingDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            circularProgress(),
            
            const SizedBox(height: 20),
            
            Text(
              "${message ?? 'Loading'}... Please wait.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
