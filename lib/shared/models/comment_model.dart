import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorPhotoURL;
  final String body;
  final DateTime? createdAt;

  CommentModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorPhotoURL,
    required this.body,
    this.createdAt,
  });

  factory CommentModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return CommentModel(
      id: doc.id,
      authorId: d['authorId'] ?? '',
      authorName: d['authorName'] ?? '',
      authorPhotoURL: d['authorPhotoURL'],
      body: d['body'] ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
