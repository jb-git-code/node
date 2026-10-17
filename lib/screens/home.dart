import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/providers/theme_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Future<void> addPost() async {
    try {
      await FirebaseFirestore.instance.collection('blogs').add({
        "postId": "1",
        "authorName": "Jayanshu",
        "authorId": "1",
        "isGlobal": false,
        "collegeId": "iiitbh",
        "createdAt": DateTime.now(),
        "metaData": {
          "title": "Node",
          "description": "This is the first post message",
        },
      });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeValue = ref.watch(darkThemeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Node'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(darkThemeProvider.notifier).state = !themeValue;
            },
            icon: (themeValue) ? Icon(Icons.dark_mode) : Icon(Icons.light_mode),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                ...List.generate(10, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepPurpleAccent,
                      ),
                      height: 300,
                      width: 350,
                      child: Center(
                        child: Text(
                          'Post $index',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        label: Text('Add'),
        onPressed: () {
          print('data is sending');
          addPost();
          print('Data sent');
        },
        icon: Icon(Icons.add, size: 30),
      ),
    );
  }
}
