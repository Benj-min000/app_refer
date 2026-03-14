import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/screens/notifications_screen.dart';

/// Drop-in bell icon for the phone app's AppBar.
///
/// Shows a red badge with unread count, respecting the user's
/// notification preferences stored in SharedPreferences.
///
/// Usage in UnifiedAppBar actions:
///   actions: [const NotificationBell()],
class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key});

  @override
  State<NotificationBell> createState() =>
      _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;
  int _previousUnread = 0;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.12), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.12, end: -0.12), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -0.12, end: 0.12), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 0.12, end: -0.12), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -0.12, end: 0.0), weight: 1),
    ]).animate(
        CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  bool _shouldCount(Map<String, dynamic> data) {
    final source = data['source']?.toString() ?? 'welcome';
    return switch (source) {
      'order' => getUserPref<bool>('notif_order_status') ?? true,
      'admin' => getUserPref<bool>('notif_promotions') ?? true,
      'nearby' => getUserPref<bool>('notif_nearby') ?? true,
      'news' => getUserPref<bool>('notif_app_news') ?? true,
      _ => true,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (currentUid == null) return const SizedBox.shrink();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .collection('notifications')
          .where('isRead', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        final unreadDocs = snapshot.data?.docs ?? [];

        // Filter by notification prefs
        final unreadCount = unreadDocs
            .where((doc) =>
                _shouldCount(doc.data() as Map<String, dynamic>))
            .length;

        // Shake on new notification
        if (unreadCount > _previousUnread) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _shakeController.forward(from: 0);
          });
        }
        _previousUnread = unreadCount;

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const NotificationsScreen(),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) => Transform.rotate(
                angle: _shakeAnimation.value,
                child: child,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_rounded,
                      color: Colors.white, size: 26),
                  if (unreadCount > 0)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                            minWidth: 16, minHeight: 16),
                        child: Text(
                          unreadCount > 99
                              ? '99+'
                              : unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}