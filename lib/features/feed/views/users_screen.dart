import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/features/feed/providers/users_provider.dart';
import 'package:node/shared/widgets/edges_connection.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.invalidate(userListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(userListProvider);
    final currUsr = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: Text('Connections'), centerTitle: true),
      body: usersAsync.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final userItem = data[index];
              return EdgeConnectionTile(usr: userItem, cu: currUsr!.uid);
            },
          );
        },
        error: ((error, stackTrace) => Text(error.toString())),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
