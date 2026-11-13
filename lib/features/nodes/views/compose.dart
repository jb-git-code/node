import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/themes/app_ui_config.dart';
import 'package:node/core/utils/loading_overlay.dart';
import 'package:node/features/nodes/providers/current_user_provider.dart';
import 'package:node/shared/models/post.dart';
import 'package:node/app.dart';
import 'package:uuid/uuid.dart';

class ComposeBlog extends ConsumerStatefulWidget {
  const ComposeBlog({super.key});

  @override
  ConsumerState<ComposeBlog> createState() => _ComposeBlogState();
}

class _ComposeBlogState extends ConsumerState<ComposeBlog> {
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

  void addNode() async {
    LoadingOverlay.show(context);
    try {
      final psid = Uuid().v4();
      final user = ref.read(currentUserProvider).value;
      if (user == null) {
        LoadingOverlay.hide(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }
      final newPost = Post(
        postId: psid,
        authorId: user.authorId,
        authorName: user.name,
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
      await Future.delayed(Duration(seconds: 2));
      _des.clear();
      _title.clear();
      if (mounted) {
        LoadingOverlay.hide(context);
      }
      if (mounted) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const App()));
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // void _tapAddNode() async {
  //   LoadingOverlay.show(context);
  //   try {
  //     addNode();
  //     Future.delayed(Duration(seconds: 2));
  //     if (context.mounted) {
  //       LoadingOverlay.hide(context);
  //     }

  //     if (context.mounted) {
  //       Navigator.of(
  //         context,
  //       ).push(MaterialPageRoute(builder: (context) => const App()));
  //     }
  //   } catch (e) {
  //     if (context.mounted) {
  //       LoadingOverlay.hide(context);
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text('Error: $e')));
  //     }
  //   }
  // }

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
                style: Theme.of(context).textTheme.displayMedium,
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
                    icon: const Icon(LucideIcons.send),
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
                maxLines: 15,
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
        spacing: 16.0, // Gap between chips horizontally
        runSpacing: 8, // Gap between chips vertically
        children: _categories.map((category) {
          final isSelected = (selectedCategory == category);
          return FilterChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) => _toggleCategory(category),
            labelStyle: TextStyle(
              color: isSelected
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.primary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            backgroundColor: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
            selectedColor: Theme.of(context).colorScheme.primary,
            checkmarkColor: !isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
            showCheckmark: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        }).toList(),
      ),
    );
  }
}
