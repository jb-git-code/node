import 'package:flutter/material.dart';

class ClustersScreen extends StatefulWidget {
  const ClustersScreen({super.key});

  @override
  State<ClustersScreen> createState() => _ClustersScreenState();
}

class _ClustersScreenState extends State<ClustersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edges List')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(10, (index) {
              return ClustersScreen();
            }),
          ],
        ),
      ),
    );
  }
}
