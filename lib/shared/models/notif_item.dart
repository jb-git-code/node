import 'package:cloud_firestore/cloud_firestore.dart';

class NotifItem {
  final String id;
  final String type;
  final String actorId;
  final String actorName;
  final String nodeId;
  final String nodeTitle;
  final String commentId;
  final String preview;
  final bool read;
  final DateTime? createdAt;

  NotifItem({
    required this.id,
    this.type = 'comment',
    this.actorId = '',
    this.actorName = '',
    required this.nodeId,
    this.nodeTitle = '',
    this.commentId = '',
    this.preview = '',
    this.read = false,
    this.createdAt,
  });

  factory NotifItem.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return NotifItem(
      id: doc.id,
      type: d['type'] ?? 'comment',
      actorId: d['actorId'] ?? '',
      actorName: d['actorName'] ?? '',
      nodeId: d['nodeId'] ?? '',
      nodeTitle: d['nodeTitle'] ?? '',
      commentId: d['commentId'] ?? '',
      preview: d['preview'] ?? '',
      read: d['read'] ?? false,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
