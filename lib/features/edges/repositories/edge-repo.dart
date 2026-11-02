import 'package:cloud_firestore/cloud_firestore.dart';

class EdgeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _generateEdgeId(String uid1, String uid2) {
    List<String> ids = [uid1, uid2];
    ids.sort(); 
    return '${ids[0]}_${ids[1]}';
  }

  Future<void> sendEdgeRequest({required String currentUserId, required String targetUserId}) async {
    final edgeId = _generateEdgeId(currentUserId, targetUserId);
    
    await _firestore.collection('edges').doc(edgeId).set({
      'participants': [currentUserId, targetUserId], 
      'senderId': currentUserId,
      'receiverId': targetUserId,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> acceptEdgeRequest(String edgeId) async {
    await _firestore.collection('edges').doc(edgeId).update({
      'status': 'connected',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteEdge(String currentUserId, String targetUserId) async {
    final edgeId = _generateEdgeId(currentUserId, targetUserId);
    await _firestore.collection('edges').doc(edgeId).delete();
  }
}