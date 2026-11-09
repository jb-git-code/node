import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/shared/models/clusters.dart';

final clusterProvider = StreamProvider<List<Cluster>>((ref) {
  final ref = FirebaseFirestore.instance.collection('clusters').snapshots();
  return ref.map((snap) {
    return snap.docs.map((e) => Cluster.fromFirestore(e)).toList();
  });
});
