import 'package:cloud_firestore/cloud_firestore.dart';

class Cluster {
  final String clusterId;
  final String clusterName;
  final String description;
  final String tag;
  final int memberCount;
  final String? logo;

  Cluster({
    required this.clusterId,
    required this.clusterName,
    required this.description,
    required this.tag,
    required this.memberCount,
    required this.logo,
  });

  factory Cluster.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Cluster(
      clusterId: data['clusterId'] ?? doc.id,
      clusterName: data['clusterName'] ?? '',
      description: data['description'] ?? '',
      tag: data['tag'] ?? '',
      memberCount: data['memberCount'] ?? 0,
      logo: data['logo'] ?? '',
    );
  }

  static Map<String, dynamic> toFirestore(Cluster usr) {
    return {
      'clusterId': usr.clusterId,
      'clusterName': usr.clusterName,
      'description': usr.description,
      'tag': usr.tag,
      'memberCount': usr.memberCount,
      'logo': usr.logo,
    };
  }
}
