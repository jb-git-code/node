// features/notifications/notification_listener.dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:node/core/services/notification_service.dart';

class NotificationListenerService {
  StreamSubscription? _sub;

  void start(String uid) {
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

            // YOUR existing local-notification call goes here:
            NotificationService.showNotification(
              id: change.doc.id.hashCode,
              title: '${d['actorName']} commented on your node',
              body: d['preview'] ?? '',
              payload: d['nodeId'], // used to open the post on tap
            );
          }
        }, onError: (e) => debugPrint('notification listener error: $e'));
  }

  void stop() {
    _sub?.cancel();
    _sub = null;
  }
}
