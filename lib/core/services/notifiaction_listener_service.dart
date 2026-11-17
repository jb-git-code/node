// features/notifications/notification_listener.dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:node/core/services/notification_service.dart';

class NotificationListenerService {
  StreamSubscription? _sub;
  final Map<String, int> _pendingPerNode = {};
  void start(String uid, {VoidCallback? onNew}) {
    stop(); // never keep two listeners running
    var isFirstSnapshot = true;

    _sub = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .listen((snap) {
          // The first snapshot is existing history. Showing it would fire a
          // popup for every old notification each time the app opens.
          if (isFirstSnapshot) {
            isFirstSnapshot = false;
            return;
          }
          for (final change in snap.docChanges) {
            if (change.type != DocumentChangeType.added) continue;
            final d = change.doc.data();
            if (d == null) continue;
            onNew?.call(); // refresh the badge in any state

            final inForeground =
                WidgetsBinding.instance.lifecycleState ==
                AppLifecycleState.resumed;
            if (inForeground) continue;

            final nodeId = (d['nodeId'] ?? '') as String;
            final count = (_pendingPerNode[nodeId] ?? 0) + 1;
            _pendingPerNode[nodeId] = count;
            // YOUR existing local-notification call goes here:
            NotificationService.showNotification(
              id: nodeId.hashCode, // same post -> replaces the previous popup
              title: count == 1
                  ? '${d['actorName']} commented on your node'
                  : '$count new comments on "${d['nodeTitle']}"',
              body: count == 1 ? (d['preview'] ?? '') : 'Tap to read them',
              payload: nodeId,
            );
          }
        }, onError: (e) => debugPrint('notification listener error: $e'));
  }

  void clearPending() => _pendingPerNode.clear();
  void stop() {
    _sub?.cancel();
    _sub = null;
    _pendingPerNode.clear();
  }
}
