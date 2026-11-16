import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String authorId;
  final String collegeId;
  final String email;
  final int nodesCreated;
  final int starsEarned;
  final List<String> joinedClusters;
  final List<String> primaryRoles;
  final List<String> skills;
  final bool showClusters;
  final bool showSavedPosts;
  final String? photoURL;
  final String? github;
  final String? linkedin;
  final String? bio;

  UserModel({
    required this.name,
    required this.authorId,
    required this.collegeId,
    required this.email,
    required this.nodesCreated,
    required this.starsEarned,
    this.joinedClusters = const [],
    this.photoURL,
    this.primaryRoles = const [],
    this.showClusters = true,
    this.showSavedPosts = false,
    this.skills = const [],
    this.github,
    this.linkedin,
    this.bio,
  });

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final privacy = data['privacy'] ?? {};
    final links = data['links'] ?? {};
    return UserModel(
      name: data['name'] ?? doc.id,
      authorId: data['authorId'] ?? '',
      collegeId: data['collegeId'] ?? '',
      email: data['email'] ?? '',
      nodesCreated: data['nodesCreated'] ?? 0,
      starsEarned: data['starsEarned'] ?? 0,
      joinedClusters: List<String>.from(data['joinedClusters'] ?? []),
      photoURL: data['photoURL'],
      primaryRoles: List<String>.from(data['primaryRoles'] ?? []),
      showClusters: privacy['showClusters'] ?? true,
      showSavedPosts: privacy['showSavedPosts'] ?? false,
      skills: List<String>.from(data['skills'] ?? []),
      github: links['github'] ?? '',
      linkedin: links['linkedin'] ?? '',
      bio: data['bio'] ?? '',
    );
  }

  static Map<String, dynamic> toFirestore(UserModel usr) {
    return {
      'name': usr.name,
      'authorId': usr.authorId,
      'collegeId': usr.collegeId,
      'email': usr.email,
      'nodesCreated': usr.nodesCreated,
      'starsEarned': usr.starsEarned,
      'joinedClusters': usr.joinedClusters,
      'photoURL': usr.photoURL,
      'primaryRoles': usr.primaryRoles,
      'showClusters': usr.showClusters,
      'showSavedPosts': usr.showSavedPosts,
      'skills': usr.skills,
      'github': usr.github,
      'linkedin': usr.linkedin,
      'bio': usr.bio,
    };
  }
}
