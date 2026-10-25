import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postId;
  final String authorId;
  final String authorName;
  final bool isGlobal;
  final String collegeId;
  final String title;
  final String description;
  final DateTime createdAt;
  final Map<String, dynamic>? metaData;
  final String category;
  final List<String> isStarredBy;
  final List<String> isSavedBy;

  Post({
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.description,
    required this.title,
    required this.collegeId,
    required this.createdAt,
    required this.isGlobal,
    required this.metaData,
    required this.category,
    required this.isStarredBy,
    required this.isSavedBy,
  });

  factory Post.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Post(
      postId: data['postId'] ?? doc.id,
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      collegeId: data['collegeId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isGlobal: data['isGlobal'] ?? false,
      metaData: Map<String, dynamic>.from(data['metaData'] ?? {}),
      category: data['category'],
      isStarredBy: List<String>.from(data['isStarredBy'] ?? []),
      isSavedBy: List<String>.from(data['isSavedBy'] ?? []),
    );
  }

  static Map<String, dynamic> toFirestore(Post post) {
    return {
      'postId': post.postId,
      'authorId': post.authorId,
      'authorName': post.authorName,
      'collegeId': post.collegeId,
      'title': post.title,
      'description': post.description,
      'createdAt': post.createdAt,
      'isGlobal': post.isGlobal,
      'metaData': post.metaData,
      'category': post.category,
      'isStarredBy': post.isStarredBy,
      'isSavedBy': post.isSavedBy,
    };
  }
}
