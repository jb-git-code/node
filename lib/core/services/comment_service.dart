import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/shared/models/user.dart';

class CommentService {
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collectionReference(
    String blogId,
  ) => _db.collection('blogs').doc(blogId).collection('comments');

  Future<void> addComment({
    required String blogId,
    required String nodeAuthorId,
    required String nodeTitle,
    required String body,
    required UserModel user,
  }) async {
    final text = body.trim();
    if (text.isEmpty || text.length > 500) return;

    final commentRef = _collectionReference(
      blogId,
    ).doc(); // ID known before writing
    final batch = _db.batch();

    batch.set(commentRef, {
      'authorId': user.authorId,
      'authorName': user.name,
      'authorPhotoURL': user.photoURL,
      'body': text,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // don't notify people about their own comments
    if (nodeAuthorId != user.authorId) {
      final notifRef = _db
          .collection('users')
          .doc(nodeAuthorId)
          .collection('notifications')
          .doc();
      batch.set(notifRef, {
        'type': 'comment',
        'actorId': user.authorId,
        'actorName': user.name,
        'nodeId': blogId,
        'nodeTitle': nodeTitle,
        'commentId': commentRef.id,
        'preview': text.length > 80 ? '${text.substring(0, 80)}…' : text,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
        'expireAt': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 60)),
        ), // for a TTL policy
      });
    }
    await batch.commit();
  }

  Future<void> deleteComment({
    required String blogId,
    required String id,
  }) async {
    await _collectionReference(blogId).doc(id).delete();
  }
}

final commentServiceProvider = Provider((ref) => CommentService());
