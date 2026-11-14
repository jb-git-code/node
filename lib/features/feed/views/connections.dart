import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
    // ref.invalidate(connectionProvider);
  }

  @override
  Widget build(BuildContext context) {
    final filterConnectionAsync = ref.watch(filterConnectionProvider);
    final currUsr = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: Text('Connections'), centerTitle: false),
      body: filterConnectionAsync.when(
        data: (data) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                  child: TextField(
                    onChanged: (value) {
                      ref.read(connectionQueryProvider.notifier).state = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Users',
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(LucideIcons.search),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final userItem = data[index];
                    return EdgeConnectionTile(usr: userItem, cu: currUsr!.uid);
                  },
                ),
              ),
            ],
          );
        },
        error: ((error, stackTrace) => Text(error.toString())),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
