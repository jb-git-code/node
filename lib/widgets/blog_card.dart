import 'package:amicons/amicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:node/models/post.dart';

class BlogCard extends StatefulWidget {
  final Post post;
  const BlogCard({super.key, required this.post});

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  void _toggleStars(String psid, bool isStarred) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final postRef = FirebaseFirestore.instance.collection('blogs').doc(psid);
    try {
      if (isStarred) {
        await postRef.update({
          'stars': FieldValue.increment(-1),
          'isStarredBy': FieldValue.arrayRemove([user.uid]),
        });
      } else {
        await postRef.update({
          'stars': FieldValue.increment(1),
          'isStarredBy': FieldValue.arrayUnion([user.uid]),
        });
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        onPressed: () {
                          final user = FirebaseAuth.instance.currentUser;
                          final isStarred =
                              user != null &&
                              widget.post.isStarredBy.contains(user.uid);
                          _toggleStars(widget.post.postId, isStarred);
                        },
                        icon: Icon(Amicons.iconly_star_2_sharp_fill),
                      ),

                      Text(widget.post.stars.toString()),
                    ],
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Amicons.lucide_square_chevron_down),
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
