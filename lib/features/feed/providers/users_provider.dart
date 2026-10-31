import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/shared/models/user.dart';

final userListProvider = StreamProvider<List<UserModel>>((ref) {
  final snaps = FirebaseFirestore.instance.collection('users').snapshots();
  return snaps.map((snap) {
    return snap.docs.map((e) => UserModel.fromFirestore(e)).toList();
  });
});
