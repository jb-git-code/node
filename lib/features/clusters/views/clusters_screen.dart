import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:node/features/auth/login.dart';
import 'package:node/features/clusters/providers/cluster_provider.dart';
import 'package:node/features/nodes/providers/current_user_provider.dart';
import 'package:node/shared/widgets/cluster_card.dart';

class ClustersScreen extends ConsumerStatefulWidget {
  const ClustersScreen({super.key});

  @override
  ConsumerState<ClustersScreen> createState() => _ClustersScreenState();
}

class _ClustersScreenState extends ConsumerState<ClustersScreen> {
  @override
  Widget build(BuildContext context) {
    final filterClusterAsync = ref.watch(filterClusterProvider);
    final currUserAsync = ref.watch(currentUserProvider);
    return currUserAsync.when(
      data: (data) {
        // not signed in or user doc missing: don't build the list
        if (data == null) {
          // not signed in or user doc missing: don't build the list
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  Text('Please sign in again.'),
                  SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      });
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: filterClusterAsync.when(
            data: (data2) {
              return Column(
                children: [
                  const SizedBox(height: 10),
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
                          ref.read(clusterQueryProvider.notifier).state = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Search Clusters',
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
                      itemCount: data2.length,
                      itemBuilder: (context, index) {
                        final clusterItem = data2[index];

                        return Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: ClusterCard(
                            clusterId: clusterItem.clusterId,
                            clusterName: clusterItem.clusterName,
                            description: clusterItem.description,
                            tag: clusterItem.tag,
                            memberCount: clusterItem.memberCount,
                            usr: data,
                          ),
                        );
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
      },
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Couldn't load your profile."),
              TextButton(
                onPressed: () => ref.invalidate(currentUserProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
