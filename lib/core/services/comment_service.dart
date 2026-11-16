import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/shared/models/user.dart';

class CommentService {
  final _db = FirebaseFirestore.instance.collection('blogs');

  CollectionReference<Map<String, dynamic>> _collectionReference(
    String blogId,
  ) => _db.doc(blogId).collection('comments');

  Future<void> addComment({
    required String blogId,
    required String body,
    required UserModel user,
  }) async {
    final text = body.trim();
    if (text.isEmpty || text.length > 500) return;
    await _collectionReference(blogId).add({
      'authorId': user.authorId,
      'authorName': user.name,
      'photoUrl': user.photoURL ?? '',
      'body': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteComment({
    required String blogId,
    required String id,
  }) async {
    await _collectionReference(blogId).doc(id).delete();
  }
}

final commentServiceProvider = Provider((ref) => CommentService());
