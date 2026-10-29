import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String authorId;
  final String collegeId;
  final String nodeId;
  final String email;
  final int nodesCreated;
  final int starsEarned;
  final List<String> joinedClusters;

  UserModel({
    required this.name,
    required this.authorId,
    required this.collegeId,
    required this.email,
    required this.nodeId,
    required this.nodesCreated,
    required this.starsEarned,
    required this.joinedClusters,
  });

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserModel(
      name: data['name'] ?? doc.id,
      authorId: data['authorId'] ?? '',
      collegeId: data['collegeId'] ?? '',
      email: data['email'] ?? '',
      nodeId: data['nodeId'] ?? '',
      nodesCreated: data['nodesCreated'] ?? 0,
      starsEarned: data['starsEarned'] ?? 0,
      joinedClusters: data['joinedClusters'] ?? [],
    );
  }

  static Map<String, dynamic> toFirestore(UserModel usr) {
    return {
      'name': usr.name,
      'authorId': usr.authorId,
      'collegeId': usr.collegeId,
      'email': usr.email,
      'nodeId': usr.nodeId,
      'nodesCreated': usr.nodesCreated,
      'starsEarned': usr.starsEarned,
      'joinedClusters': usr.joinedClusters,
    };
  }
}
