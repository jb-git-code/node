import 'package:amicons/amicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:node/models/post.dart';
import 'package:node/screens/app.dart';
import 'package:node/screens/home.dart';
import 'package:uuid/uuid.dart';

class ComposeBlog extends StatefulWidget {
  ComposeBlog({super.key});

  @override
  State<ComposeBlog> createState() => _ComposeBlogState();
}

class _ComposeBlogState extends State<ComposeBlog> {
  final List<String> _categories = ["Tech", "Placement", "Share", "Exp"];

  void _toggleCategory(String cat) {
    setState(() {
      if (selectedCategory == cat) {
        selectedCategory = null;
      } else {
        selectedCategory = cat;
      }
    });
  }

  final TextEditingController _title = TextEditingController();
  final TextEditingController _des = TextEditingController();

  bool isUploading = false;

  void addNode() async {
    try {
      final psid = Uuid().v4();
      final user = FirebaseAuth.instance.currentUser;
      isUploading = true;
      Future.delayed(Duration(microseconds: 1000));
      if (user == null) return;
      final newPost = Post(
        postId: psid,
        authorId: 'jayanshub18@gmail.com',
        authorName: 'Jayanshu',
        collegeId: "iiitbh",
        createdAt: DateTime.now(),
        isGlobal: false,
        title: _title.text,
        description: _des.text,
        metaData: {},
        category: selectedCategory!,
        stars: 0,
        isStarredBy: <String>[],
      );

      await FirebaseFirestore.instance
          .collection('blogs')
          .doc(psid)
          .set((Post.toFirestore(newPost)));
      setState(() {
        isUploading = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => App()));
      print('post Added');
    } catch (e) {
      throw e.toString();
    }
  }

  String? selectedCategory;

  @override
  void dispose() {
    super.dispose();
    _title.dispose();
    _des.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Share Experience, Connect a node',
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      // maxLength: 40,
                      controller: _title,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Title',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton.icon(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.lightGreenAccent,
                      ),
                      foregroundColor: WidgetStatePropertyAll(Colors.black),
                    ),
                    onPressed: addNode,
                    label: Text('Node'),
                    icon: (!isUploading)
                        ? Icon(Amicons.flaticon_navigation_rounded_fill)
                        : CircularProgressIndicator(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _des,
                maxLines: 15,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Description',
                ),
              ),
              const SizedBox(height: 20),
              buildCategories(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategories(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Categories',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8.0, // Gap between chips horizontally
            runSpacing: 10.0, // Gap between chips vertically
            children: _categories.map((category) {
              final isSelected = (selectedCategory == category);
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (_) => _toggleCategory(category),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.black : Colors.white70,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                backgroundColor: const Color(0xFF1E1E1E),
                selectedColor: Colors.lightGreenAccent,
                checkmarkColor: Colors.black,
                showCheckmark: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? Colors.lightGreenAccent
                        : Colors.white24,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
