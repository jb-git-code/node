import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postId;
  final String authorId;
  final String authorName;
  final bool isGlobal;
  final String collegeId;
  final DateTime createdAt;
  final Map<String, dynamic> metaData;

  Post({
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.collegeId,
    required this.createdAt,
    required this.isGlobal,
    required this.metaData,
  });

  factory Post.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Post(
      postId: data['postId'] ?? doc.id,
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      collegeId: data['collegeId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isGlobal: data['isGlobal'] ?? false,
      metaData: Map<String, dynamic>.from(data['metaData'] ?? {}),
    );
  }
}
