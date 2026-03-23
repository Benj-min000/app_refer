import 'package:flutter/material.dart';

Widget circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 20),
    child: SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(Colors.amber.withValues(alpha: 0.2)),
          ),
          const CircularProgressIndicator(
            strokeWidth: 4,
            strokeCap: StrokeCap.round, // Modern rounded edges
            valueColor: AlwaysStoppedAnimation(Colors.amber),
          ),
        ],
      ),
    ),
  );
}