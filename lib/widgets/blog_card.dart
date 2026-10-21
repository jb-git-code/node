import 'package:flutter/material.dart';
import 'package:node/models/post.dart';

class BlogCard extends StatefulWidget {
  final Post post;
  const BlogCard({super.key, required this.post});

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
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
              const SizedBox(height: 20),
              Text(
                widget.post.authorName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
