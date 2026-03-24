import 'package:flutter/material.dart';
import 'package:rider_app/extensions/extensions_import.dart';

/// Reformat timestamps to a readable string
String formatTime(BuildContext context, DateTime dt) {
  final now = DateTime.now();
  final diff = now.difference(dt);
  if (diff.inMinutes < 1) return context.l10n.time_just_now;
  if (diff.inMinutes < 60) {
    return context.l10n.time_minutes(diff.inMinutes);
  }
  if (diff.inHours < 24) return context.l10n.time_hours(diff.inHours);
  return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}';
}
