import 'package:cloud_firestore/cloud_firestore.dart';

class ClusterRepo {
  final ref = FirebaseFirestore.instance.collection('users');

  Future<void> joinCluster(String uid, String cid) async {
    try {
      await ref.doc(uid).update({
        'joinedClusters': FieldValue.arrayUnion([cid]),
      });
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> exitCluster(String uid, String cid) async {
    try {
      await ref.doc(uid).update({
        'joinedClusters': FieldValue.arrayRemove([cid]),
      });
    } catch (e) {
      throw e.toString();
    }
  }
}
