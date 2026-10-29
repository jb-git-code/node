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
}
