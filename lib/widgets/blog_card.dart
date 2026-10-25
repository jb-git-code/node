import 'package:amicons/amicons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/models/post.dart';
import 'package:node/services/firebase_service.dart';

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 300,
        width: MediaQuery.of(context).size.width * .80,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xFFA2D788),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title
              Text(
                widget.post.title,
                style: TextStyle(fontSize: 40, color: Colors.black),
              ),
              const SizedBox(height: 20),
              // des
              Text(
                widget.post.description,
                style: TextStyle(fontSize: 16, color: Colors.black),
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
                      color: Colors.black,
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
                                  final bool isStarred = widget.post.isStarredBy
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
                          isStarred
                              ? Amicons.remix_star_fill
                              : Amicons.remix_star,
                        ),
                      ),
                      Text(widget.post.isStarredBy.length.toString()),
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
                      color: isSaved ? Colors.black : Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
