import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/shared/models/notif_item.dart';

CollectionReference<Map<String, dynamic>> _notifCol(String uid) =>
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications');

final notificationsProvider = FutureProvider.autoDispose<List<NotifItem>>((
  ref,
) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return [];
  final snap = await _notifCol(
    uid,
  ).orderBy('createdAt', descending: true).limit(50).get();
  return snap.docs
      .map(
        (d) => NotifItem.fromDoc(d as DocumentSnapshot<Map<String, dynamic>>),
      )
      .toList();
});

// count() is billed as a fraction of a read, far cheaper than loading the docs
final unreadCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return 0;
  final agg = await _notifCol(
    uid,
  ).where('read', isEqualTo: false).count().get();
  return agg.count ?? 0;
});

Future<void> markAllRead(List<NotifItem> items) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;
  final unread = items.where((n) => !n.read).toList();
  if (unread.isEmpty) return;

  final batch = FirebaseFirestore.instance.batch();
  for (final n in unread) {
    batch.update(_notifCol(uid).doc(n.id), {'read': true});
  }
  await batch.commit();
}
