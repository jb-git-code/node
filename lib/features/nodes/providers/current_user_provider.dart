import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/shared/models/user.dart';

final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final curr = FirebaseAuth.instance.currentUser;
  if (curr == null) {
    return Stream.value(null);
  }
  return FirebaseFirestore.instance
      .collection('users')
      .where('authorId', isEqualTo: curr.uid)
      .limit(1)
      .snapshots()
      .map((snap) {
        if (snap.docs.isEmpty) return null;
        return UserModel.fromFirestore(snap.docs.first);
      });
});
