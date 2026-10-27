import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createdPostsCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return 0;

  final AggregateQuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('blogs')
      .where('authorId', isEqualTo: user.uid)
      .count()
      .get();

  return snapshot.count ?? 0;
});

final savedPostsCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return 0;

  final AggregateQuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('blogs')
      .where('isSavedBy', arrayContains: user.uid)
      .count()
      .get();

  return snapshot.count ?? 0;
});

final totalStarsEarnedProvider = FutureProvider.autoDispose<int>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return 0;

  final querySnapshot = await FirebaseFirestore.instance
      .collection('blogs')
      .where('authorId', isEqualTo: user.uid)
      .get();

  int totalStars = 0;

  for (final doc in querySnapshot.docs) {
    final data = doc.data();
    final List<dynamic> starredBy = data['isStarredBy'] ?? [];
    totalStars += starredBy.length;
  }

  return totalStars;
});
