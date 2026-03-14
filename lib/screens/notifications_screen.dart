import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/widgets/unified_app_bar.dart';

// ── Notification source → preference key mapping ──────────────────────────────
// source: 'order'  → notif_order_status
// source: 'admin'  → notif_promotions  (admin broadcasts)
// source: 'nearby' → notif_nearby
// source: 'news'   → notif_app_news
// source: 'welcome'→ always shown

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {

  bool _shouldShow(Map<String, dynamic> data) {
    final source = data['source']?.toString() ?? 'welcome';
    return switch (source) {
      'order' => getUserPref<bool>('notif_order_status') ?? true,
      'admin' => getUserPref<bool>('notif_promotions') ?? true,
      'nearby' => getUserPref<bool>('notif_nearby') ?? true,
      'news' => getUserPref<bool>('notif_app_news') ?? true,
      _ => true, // 'welcome' and unknown sources always shown
    };
  }

  Future<void> _markAllRead(List<QueryDocumentSnapshot> docs) async {
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in docs) {
      if ((doc.data() as Map)['isRead'] != true) {
        batch.update(doc.reference, {'isRead': true});
      }
    }
    await batch.commit();
  }

  Future<void> _markRead(DocumentSnapshot doc) async {
    if ((doc.data() as Map)['isRead'] == true) return;
    await doc.reference.update({'isRead': true});
  }

  Future<void> _delete(DocumentSnapshot doc) async {
    await doc.reference.delete();
  }

  IconData _iconForSource(String source) {
    return switch (source) {
      'order' => Icons.local_shipping_rounded,
      'admin' => Icons.local_offer_rounded,
      'nearby' => Icons.storefront_rounded,
      'news' => Icons.campaign_rounded,
      _ => Icons.notifications_rounded,
    };
  }

  Color _colorForSource(String source) {
    return switch (source) {
      'order' => Colors.redAccent,
      'admin' => const Color(0xFF00C48C),
      'nearby' => Colors.blue,
      'news' => Colors.orange,
      _ => Colors.redAccent,
    };
  }

  String _formatTime(dynamic ts) {
    if (ts == null) return '';
    try {
      final dt = ts is Timestamp ? ts.toDate() : DateTime.now();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays == 1) return 'Yesterday';
      return '${diff.inDays}d ago';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6FB),
      appBar: UnifiedAppBar(
        title: "Notifications",
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUid)
            .collection('notifications')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(color: Colors.redAccent),
            );
          }

          final allDocs = snapshot.data!.docs;

          // Filter by user prefs
          final visible = allDocs.where((doc) {
            return _shouldShow(doc.data() as Map<String, dynamic>);
          }).toList();

          final unread =
              visible.where((d) => (d.data() as Map)['isRead'] != true).toList();

          if (visible.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined,
                      size: 64, color: Colors.grey.shade200),
                  const SizedBox(height: 16),
                  Text("No notifications",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500)),
                  const SizedBox(height: 6),
                  Text("You're all caught up!",
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade400)),
                ],
              ),
            );
          }

          return Column(
            children: [
              // ── Header row ───────────────────────────────────────
              if (unread.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${unread.length} unread",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade500),
                      ),
                      GestureDetector(
                        onTap: () => _markAllRead(visible),
                        child: Text(
                          "Mark all as read",
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ),

              // ── List ─────────────────────────────────────────────
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: visible.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final doc = visible[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final bool isRead = data['isRead'] == true;
                    final source =
                        data['source']?.toString() ?? 'welcome';
                    final color = _colorForSource(source);

                    return Dismissible(
                      key: Key(doc.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.delete_outline_rounded,
                            color: Colors.redAccent),
                      ),
                      onDismissed: (_) => _delete(doc),
                      child: GestureDetector(
                        onTap: () => _markRead(doc),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isRead
                                ? Colors.white
                                : color.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isRead
                                  ? const Color(0xFFEEEEEE)
                                  : color.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon badge
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.1),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                                child: Icon(_iconForSource(source),
                                    size: 18, color: color),
                              ),
                              const SizedBox(width: 12),

                              // Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            data['title']?.toString() ??
                                                '',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: isRead
                                                  ? FontWeight.w500
                                                  : FontWeight.w700,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _formatTime(data['createdAt']),
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey.shade400),
                                        ),
                                      ],
                                    ),
                                    if (data['body'] != null) ...[
                                      const SizedBox(height: 3),
                                      Text(
                                        data['body'].toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                          height: 1.4,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              // Unread dot
                              if (!isRead) ...[
                                const SizedBox(width: 8),
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(top: 4),
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}