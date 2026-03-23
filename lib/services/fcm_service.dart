// lib/services/fcm_service.dart
//
// Handles:
//   1. Requesting notification permission
//   2. Getting + saving FCM token to Firestore (riders/{uid}.fcmToken)
//   3. Foreground message handler → shows in-app job request sheet
//   4. Background/terminated tap handler → navigates to correct screen

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

// Must be top-level for Firebase background handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background messages are handled by onMessageOpenedApp when user taps
  // No UI work here — just log
  debugPrint('[FCM Background] ${message.data}');
}

class FcmService {
  static final FcmService _instance = FcmService._();
  factory FcmService() => _instance;
  FcmService._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  // Callback set by RiderProvider to show job request sheet
  Function(Map<String, dynamic> data)? onDispatchJob;

  // ── Init (call once from main.dart after Firebase.initializeApp) ──────────
  Future<void> init() async {
    // 1. Request permission
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2. Init local notifications (for foreground display on Android)
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    await _localNotif.initialize(
      const InitializationSettings(
          android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: (details) {
        // User tapped local notification
        if (details.payload != null) {
          _handlePayload(details.payload!);
        }
      },
    );

    // High-priority channel for dispatch jobs (Android)
    await _localNotif
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          'dispatch_channel',
          'Dispatch Requests',
          description: 'Incoming delivery job requests',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        ));

    // 3. Register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 4. Foreground messages
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // 5. App opened from notification tap (background → foreground)
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageTap);

    // 6. App launched from terminated state via notification tap
    final initial = await _fcm.getInitialMessage();
    if (initial != null) _onMessageTap(initial);

    // 7. Save token
    await _saveToken();

    // Token refresh
    _fcm.onTokenRefresh.listen((token) async {
      await _persistToken(token);
    });
  }

  // ── Save token to Firestore + Cloud Function ──────────────────────────────
  Future<void> _saveToken() async {
    final token = await _fcm.getToken();
    if (token == null) return;
    await _persistToken(token);
  }

  Future<void> _persistToken(String token) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      // Use Cloud Function (saveFcmToken) — validates auth server-side
      await FirebaseFunctions.instance
          .httpsCallable('saveFcmToken')
          .call({'token': token});
    } catch (_) {
      // Fallback: write directly (acceptable if security rules allow)
      await FirebaseFirestore.instance
          .collection('riders')
          .doc(uid)
          .set({'fcmToken': token}, SetOptions(merge: true));
    }
  }

  // ── Foreground message handler ────────────────────────────────────────────
  void _onForegroundMessage(RemoteMessage message) {
    final data = message.data;
    debugPrint('[FCM Foreground] type=${data['type']}');

    if (data['type'] == 'DISPATCH_JOB') {
      // Trigger the in-app job request sheet immediately
      onDispatchJob?.call(data);
    }

    // Also show a local notification so rider sees it even if app is open
    _showLocalNotification(message);
  }

  // ── Notification tap handler ──────────────────────────────────────────────
  void _onMessageTap(RemoteMessage message) {
    final data = message.data;
    if (data['type'] == 'DISPATCH_JOB') {
      onDispatchJob?.call(data);
    }
  }

  void _handlePayload(String payload) {
    // payload is type string from local notification
    if (payload == 'DISPATCH_JOB') {
      // RiderProvider will already have the pending job loaded via Firestore
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'dispatch_channel',
      'Dispatch Requests',
      channelDescription: 'Incoming delivery job requests',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true, // Shows even on lock screen
    );

    await _localNotif.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      ),
      payload: message.data['type'],
    );
  }
}
