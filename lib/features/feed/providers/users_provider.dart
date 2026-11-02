import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/shared/models/user.dart';

final userListProvider = StreamProvider<List<UserModel>>((ref) {
  final currUsr = FirebaseAuth.instance.currentUser;
  final snaps = FirebaseFirestore.instance.collection('users').snapshots();
  return snaps.map((snap) {
    return snap.docs
        .where((d) => d.data()['authorId'] != currUsr!.uid)
        .map((e) => UserModel.fromFirestore(e))
        .toList();
  });
});
