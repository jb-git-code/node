import 'package:flutter/material.dart';
import 'package:node/shared/models/user.dart';

class NodeProfile extends StatelessWidget {
  const NodeProfile({super.key, required this.usr});
  final UserModel usr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Node User'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text(usr.name),
            const SizedBox(height: 20),
            Text(usr.authorId),
            const SizedBox(height: 20),
            Text(usr.nodesCreated.toString()),
            const SizedBox(height: 20),
            Text(usr.starsEarned.toString()),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
