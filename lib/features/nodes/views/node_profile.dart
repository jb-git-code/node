import 'package:flutter/material.dart';
import 'package:node/shared/models/user.dart';

class NodeProfile extends StatelessWidget {
  const NodeProfile({super.key , required this.usr});
   final UserModel usr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Node User'), centerTitle: true,),
      body: Padding(padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text('name'),
          const SizedBox( height: 20,),
          Text('node ID'),
          const SizedBox( height: 20,),
          Text('nodes created'),
          const SizedBox( height: 20,),
          Text('Stars Earned '),
          const SizedBox( height: 20,),
        ],
      ),),
    );
  }
}