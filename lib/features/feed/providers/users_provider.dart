import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:node/shared/models/user.dart';

final connectionProvider = StreamProvider<List<UserModel>>((ref) {
  final currUsr = FirebaseAuth.instance.currentUser;
  final snaps = FirebaseFirestore.instance.collection('users').snapshots();
  return snaps.map((snap) {
    return snap.docs
        .where((d) => d.data()['authorId'] != currUsr!.uid)
        .map((e) => UserModel.fromFirestore(e))
        .toList();
  });
});

final connectionQueryProvider = StateProvider<String?>((ref) => null);

final filterConnectionProvider = Provider<AsyncValue<List<UserModel>>>((ref) {
  final connectionsAsync = ref.watch(connectionProvider);
  final connectionQuery = ref.watch(connectionQueryProvider);
  return connectionsAsync.whenData((connection) {
    if (connectionQuery == null) return connection;
    return connection
        .where(
          (con) =>
              con.name.toLowerCase().contains(connectionQuery.toLowerCase()),
        )
        .toList();
  });
});
