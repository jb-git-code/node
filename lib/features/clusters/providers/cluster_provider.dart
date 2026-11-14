import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:node/shared/models/clusters.dart';

final clusterProvider = StreamProvider<List<Cluster>>((ref) {
  final ref = FirebaseFirestore.instance.collection('clusters').snapshots();
  return ref.map((snap) {
    return snap.docs.map((e) => Cluster.fromFirestore(e)).toList();
  });
});

final clusterQueryProvider = StateProvider<String?>((ref) => null);

final filterClusterProvider = Provider<AsyncValue<List<Cluster>>>((ref) {
  final clusterAsync = ref.watch(clusterProvider);
  final clusterQuery = ref.watch(clusterQueryProvider);

  return clusterAsync.whenData((clusters) {
    if (clusterQuery == null) return clusters;
    return clusters
        .where(
          (c) =>
              c.clusterName.toLowerCase().contains(
                clusterQuery.toLowerCase(),
              ) ||
              c.description.toLowerCase().contains(clusterQuery.toLowerCase()),
        )
        .toList();
  });
});
