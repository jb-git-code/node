import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:node/shared/widgets/edges_card.dart';

class EdgeScreen extends StatefulWidget {
  const EdgeScreen({super.key});

  @override
  State<EdgeScreen> createState() => _EdgeScreenState();
}

class _EdgeScreenState extends State<EdgeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edges List')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(10, (index) {
              return EdgeConnectionTile(
                studentName: 'Jayanshu',
                college: 'iiitbh',
                onDisconnect: () {},
              );
            }),
          ],
        ),
      ),
    );
  }
}
