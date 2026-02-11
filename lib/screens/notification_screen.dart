import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/unified_app_bar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> markAllNotificationsAsRead() async {    
    QuerySnapshot unreadDocs = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("notifications")
        .where("isRead", isEqualTo: false)
        .get();
    if (unreadDocs.docs.isEmpty) return;

    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (DocumentSnapshot doc in unreadDocs.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  Future<void> markSingleAsRead(String notificationId) async {
    await FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("notifications")
      .doc(notificationId)
      .update({'isRead': true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UnifiedAppBar(
        title: "Notifications",
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new, 
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      body: userId == null
          ? const Center(child: Text("Please login to see notifications"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(userId)
                  .collection("notifications")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return circularProgress();
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No notifications yet."),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    
                    // Format the timestamp
                    DateTime date = (data['timestamp'] as Timestamp).toDate();
                    String formattedDate = DateFormat('dd MMM, hh:mm a').format(date);

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        onTap: () => markSingleAsRead(snapshot.data!.docs[index].id),
                        leading: CircleAvatar(
                          child: data['isRead'] == false 
                            ? Icon(Icons.notifications_active) 
                            : Icon(Icons.notifications_none, color: Colors.green),
                        ),
                        title: Text(
                          data['title'] ?? "Notification",
                          style: TextStyle(
                            fontWeight: data['isRead'] == false ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['body'] ?? ""),
                            const SizedBox(height: 5),
                            Text(
                              formattedDate,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}