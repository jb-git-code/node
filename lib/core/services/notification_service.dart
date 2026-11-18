import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:node/core/constants/navigation.dart';
import 'package:node/core/services/post_repo.dart';
import 'package:node/features/feed/views/expand_blog_card.dart';
import 'package:node/shared/models/post.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      defaultPresentBanner: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) async {
        final nodeId = response.payload;
        if (nodeId == null) return;
        final ref = await FirebaseFirestore.instance
            .collection('blogs')
            .doc(nodeId)
            .get();
        if (!ref.exists) return;
        final post = Post.fromFirestore(ref);
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => ExpandBlogCard(post: post)),
        );
      },
    );

    final launch = await _plugin.getNotificationAppLaunchDetails();
    final response = launch?.notificationResponse;
    if ((launch?.didNotificationLaunchApp ?? false) && response != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _onNotificationTap(response),
      );
    }

    // Request Android 13+ permission
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
    required String payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'in_app_triggers',
      'In-App Triggers',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentBanner: true,
      ),
    );

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  static Future<void> openPostById(
    String nodeId, {
    required NavigatorState navigator,
  }) async {
    // 1. Try local first
    var post = await PostRepo.getPostById(nodeId);

    // 2. Fall back to remote
    if (post == null) {
      debugPrint('openPostById: not found locally, fetching remotely...');
      try {
        final doc = await FirebaseFirestore.instance
            .collection('nodes')
            .doc(nodeId)
            .get();
        debugPrint('openPostById: nodeId=$nodeId exists=${doc.exists}');
        if (!doc.exists || doc.data() == null) return;

        post = Post.fromFirestore(doc);
      } catch (e, st) {
        debugPrint('openPostById failed: $e\n$st');
      } // or a Supabase/Firestore query
    }

    if (post == null) {
      debugPrint('openPostById: post not found anywhere: $nodeId');
      // optionally show a SnackBar: "Post no longer available"
      return;
    }

    navigator.push(
      MaterialPageRoute(builder: (_) => ExpandBlogCard(post: post!)),
    );
  }

  static Future<void> _onNotificationTap(NotificationResponse response) async {
    final nodeId = response.payload;
    debugPrint('nodeId > $nodeId');
    if (nodeId == null || nodeId.isEmpty) return;

    final navigator = navigatorKey.currentState;
    if (navigator == null) return;

    await openPostById(nodeId, navigator: navigator);
  }
}
