import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/services/comment_service.dart';
import 'package:node/features/feed/providers/comments_provider.dart';
import 'package:node/shared/widgets/comment_tile.dart';

class CommentView extends ConsumerStatefulWidget {
  const CommentView({super.key, required this.blogId});
  final String blogId;

  @override
  ConsumerState<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends ConsumerState<CommentView> {
  Future<void> _delete(String commentId) async {
    try {
      await ref
          .read(commentServiceProvider)
          .deleteComment(blogId: widget.blogId, id: commentId);
      ref.invalidate(commentsProvider(widget.blogId));
    } catch (e) {
      debugPrint('deleteComment failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't delete the comment.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(commentsProvider(widget.blogId));
    final myUid = FirebaseAuth.instance.currentUser?.uid;
    return commentsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => TextButton(
        onPressed: () => ref.invalidate(commentsProvider(widget.blogId)),
        child: const Text("Couldn't load comments. Tap to retry"),
      ),
      data: (comments) {
        if (comments.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('No comments yet. Be the first.'),
          );
        }
        return Column(
          children: comments
              .map(
                (c) => CommentTile(
                  comment: c,
                  canDelete: c.authorId == myUid,
                  onDelete: () => _delete(c.id),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
