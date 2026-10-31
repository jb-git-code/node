import 'package:amicons/amicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:markdown_live/markdown_live.dart';
import 'package:node/core/themes/app_colors.dart';
import 'package:node/core/themes/app_text_styles.dart';
import 'package:node/core/themes/app_ui_config.dart';
import 'package:node/shared/models/post.dart';
import 'package:node/app.dart';
import 'package:node/features/feed/views/home.dart';
import 'package:uuid/uuid.dart';

class ComposeBlog extends StatefulWidget {
  ComposeBlog({super.key});

  @override
  State<ComposeBlog> createState() => _ComposeBlogState();
}

class _ComposeBlogState extends State<ComposeBlog> {
  final List<String> _categories = ["Tech", "Placement", "Share", "Exp"];
  bool _isEditorReady = false;
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
        authorId: user.uid,
        authorName: user.displayName ?? 'Unknown',
        collegeId: "iiitbh",
        createdAt: DateTime.now(),
        isGlobal: false,
        title: _title.text,
        description: _des.text,
        metaData: {},
        category: selectedCategory!,
        isStarredBy: <String>[],
        isSavedBy: <String>[],
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

  // void _insertMarkdown(String prefix, String suffix) {
  //   final text = _des.text;
  //   final selection = _des.selection;

  //   if (selection.baseOffset == -1) return; // No cursor active

  //   final selectedText = selection.textInside(text);
  //   final newText = text.replaceRange(
  //     selection.start,
  //     selection.end,
  //     '$prefix$selectedText$suffix',
  //   );

  //   _des.value = TextEditingValue(
  //     text: newText,
  //     selection: TextSelection.collapsed(
  //       offset: selection.start + prefix.length + selectedText.length,
  //     ),
  //   );
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   // Initialize the live-rendering controller
  //   _des = MarkdownLiveController(text: '');
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (mounted) {
  //       setState(() {
  //         _isEditorReady = true;
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                    // title
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
              const SizedBox(height: 10),
              buildCategories(context),
              const SizedBox(height: 10),
              // description
              TextField(
                controller: _des,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: AppUI.cardRadius),
                  hintText: 'Description',
                ),
                maxLines: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategories(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Wrap(
        spacing: 12.0, // Gap between chips horizontally
        runSpacing: 8, // Gap between chips vertically
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
                color: isSelected ? Colors.lightGreenAccent : Colors.white24,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
