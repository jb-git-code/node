import 'package:flutter/material.dart';
import 'package:node/features/nodes/views/connection_profile.dart';
import 'package:node/shared/models/comment_model.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    required this.comment,
    required this.canDelete,
    required this.onDelete,
  });

  final CommentModel comment;
  final bool canDelete;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = comment.authorPhotoURL?.isNotEmpty ?? false;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PublicProfileScreen(uid: comment.authorId),
          ),
        ),
        child: CircleAvatar(
          backgroundImage: hasPhoto
              ? NetworkImage(comment.authorPhotoURL!)
              : null,
          child: hasPhoto
              ? null
              : Text(
                  comment.authorName.isNotEmpty
                      ? comment.authorName[0].toUpperCase()
                      : '?',
                ),
        ),
      ),
      title: Text(comment.authorName),
      subtitle: Text(comment.body),
      trailing: canDelete
          ? IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            )
          : null,
    );
  }
}
