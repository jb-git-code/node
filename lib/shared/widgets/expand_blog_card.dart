import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:node/shared/models/post.dart';

class ExpandBlogCard extends StatefulWidget {
  const ExpandBlogCard({super.key, required this.post});
  final Post post;

  @override
  State<ExpandBlogCard> createState() => _ExpandBlogCardState();
}

class _ExpandBlogCardState extends State<ExpandBlogCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * .90,
          width: MediaQuery.of(context).size.width * .96,

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
                Expanded(
                  child: Text(
                    widget.post.description,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),

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
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Amicons.iconly_star_2_sharp_fill),
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
      ),
    );
  }
}
