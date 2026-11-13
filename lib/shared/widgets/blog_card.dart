import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/shared/models/post.dart';
import 'package:node/core/services/firebase_service.dart';
import 'package:flutter/services.dart';
import 'package:node/shared/widgets/expand_blog_card.dart';

class BlogCard extends ConsumerStatefulWidget {
  final Post post;
  const BlogCard({super.key, required this.post});

  @override
  ConsumerState<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends ConsumerState<BlogCard> {
  bool isUploading = false;

  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final bool isSaved =
        user != null && widget.post.isSavedBy.contains(user.uid);
    final bool isStarred =
        user != null && widget.post.isStarredBy.contains(user.uid);
    return Hero(
      tag: 'post-${widget.post.postId}',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ExpandBlogCard(
                  post: widget.post,
                  heroTag: 'post-${widget.post.postId}',
                ),
              ),
            );
          },
          child: Container(
            height: 300,
            width: MediaQuery.of(context).size.width * .80,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.post.title,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 28,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(text: widget.post.description),
                          );
                        },
                        icon: Icon(
                          LucideIcons.copy,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // des
                  // Example implementation for reading a Node
                  Expanded(
                    child: Text(
                      widget.post.description,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.authorName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          IconButton(
                            onPressed: isUploading || user == null
                                ? null
                                : () async {
                                    setState(() {
                                      isUploading = true;
                                    });
                                    try {
                                      final bool isStarred = widget
                                          .post
                                          .isStarredBy
                                          .contains(user.uid);
                                      await FirebaseService().toggleStars(
                                        widget.post.postId,
                                        isStarred,
                                      );
                                    } finally {
                                      if (mounted) {
                                        setState(() {
                                          isUploading = false;
                                        });
                                      }
                                    }
                                  },
                            icon: Icon(
                              isStarred ? Icons.star : Icons.star_border,
                              color: isStarred
                                  ? Colors.green
                                  : Theme.of(context).colorScheme.primary,
                              size: 28,
                            ),
                          ),
                          Text(
                            widget.post.isStarredBy.length.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: isSaving || user == null
                            ? null
                            : () async {
                                setState(() {
                                  isSaving = true;
                                });
                                try {
                                  await FirebaseService().toggleSave(
                                    widget.post.postId,
                                  );
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      isSaving = false;
                                    });
                                  }
                                }
                              },
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: isSaved
                              ? Colors.green
                              : Theme.of(context).colorScheme.primary,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
