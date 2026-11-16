import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/services/comment_service.dart';
import 'package:node/features/feed/providers/comments_provider.dart';
import 'package:node/features/nodes/views/connection_profile.dart';
import 'package:node/shared/models/post.dart';
import 'package:node/features/nodes/providers/current_user_provider.dart';
import 'package:node/shared/models/user.dart';
import 'package:node/shared/widgets/comment_view.dart';

class ExpandBlogCard extends ConsumerStatefulWidget {
  const ExpandBlogCard({super.key, required this.post, this.heroTag});

  final Post post;
  final Object? heroTag;

  @override
  ConsumerState<ExpandBlogCard> createState() => _ExpandBlogCardState();
}

class _ExpandBlogCardState extends ConsumerState<ExpandBlogCard> {
  final _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send(UserModel user) async {
    if (_sending || _controller.text.trim().isEmpty) return;
    setState(() => _sending = true);
    try {
      await ref
          .read(commentServiceProvider)
          .addComment(
            blogId: widget.post.postId,
            body: _controller.text,
            user: user,
          );
      _controller.clear();
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      ref.invalidate(commentsProvider(widget.post.postId));
    } catch (e) {
      debugPrint('addComment failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't post your comment.")),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final author = widget.post.authorName;
    final user = ref.watch(currentUserProvider).value;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          // Everything above the input scrolls together
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Title
                Text(
                  widget.post.title,
                  style: text.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),

                // Author
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: colors.surfaceContainerHigh,
                      child: Text(
                        author.isNotEmpty ? author[0].toUpperCase() : '?',
                        style: text.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PublicProfileScreen(uid: widget.post.authorId),
                          ),
                        ),
                        child: Text(
                          author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),

                // Description
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: widget.post.description[0]
                            .toUpperCase(), // Or: myParagraph[0].toUpperCase()
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      TextSpan(
                        text: widget.post.description.substring(1),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(),
                Text('Comments', style: text.titleMedium),
                const SizedBox(height: 8),

                // Comments
                CommentView(blogId: widget.post.postId),
              ],
            ),
          ),

          // Comment input, pinned below the comments
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLength: 500,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Share your view',
                        counterText: '',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: _sending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                    onPressed: user == null || _sending
                        ? null
                        : () => _send(user),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
