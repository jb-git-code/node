// features/profile/views/public_profile_screen.dart
import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:node/core/constants/navigation.dart';
import 'package:node/features/nodes/providers/connection_user_provider.dart';
import 'package:node/shared/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class PublicProfileScreen extends ConsumerWidget {
  final String uid;
  const PublicProfileScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userByIdProvider(uid));

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Couldn't load this profile."),
              TextButton(
                onPressed: () => ref.invalidate(userByIdProvider(uid)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('This user no longer exists.'));
          }
          return _ProfileBody(user: user);
        },
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final UserModel user;
  const _ProfileBody({required this.user});

  Future<void> _openUrl(BuildContext context, String url) async {
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open the link')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bio = user.bio?.trim() ?? '';
    final hasPhoto = user.photoURL != null && user.photoURL!.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundImage: hasPhoto
                      ? NetworkImage(user.photoURL!)
                      : null,
                  child: hasPhoto
                      ? null
                      : Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(fontSize: 32),
                        ),
                ),
                const SizedBox(height: 12),
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (user.collegeId.isNotEmpty)
                  Text(
                    user.collegeId,
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Stats
          Row(
            children: [
              _StatTile(label: 'Nodes', value: user.nodesCreated),
              const SizedBox(width: 12),
              _StatTile(label: 'Stars', value: user.starsEarned),
            ],
          ),

          // Bio
          if (bio.isNotEmpty) ...[
            const SizedBox(height: 20),
            const _SectionTitle('About'),
            Text(bio),
          ],

          // Roles
          if (user.primaryRoles.isNotEmpty) ...[
            const SizedBox(height: 20),
            const _SectionTitle('Roles'),
            Wrap(
              spacing: 8,
              children: user.primaryRoles
                  .map((r) => Chip(label: Text(r)))
                  .toList(),
            ),
          ],

          // Skills
          if (user.skills.isNotEmpty) ...[
            const SizedBox(height: 20),
            const _SectionTitle('Skills'),
            Wrap(
              spacing: 6,
              children: user.skills
                  .map(
                    (s) => Chip(
                      label: Text(s, style: const TextStyle(fontSize: 12)),
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(),
            ),
          ],

          // Links
          if (_has(user.github) || _has(user.linkedin)) ...[
            const SizedBox(height: 20),
            const _SectionTitle('Links'),
            if (_has(user.github))
              _LinkRow(
                icon: Amicons.remix_git_branch,
                text: 'Github',
                onPressed: () {
                  _openUrl(context, user.github!);
                },
              ),
            if (_has(user.linkedin))
              _LinkRow(
                icon: LucideIcons.link,
                text: 'Linkedin',
                onPressed: () {
                  _openUrl(context, user.linkedin!);
                },
              ),
          ],

          // Clusters (respects privacy)
          if (user.showClusters && kClustersScreen) ...[
            const SizedBox(height: 20),
            const _SectionTitle('Clusters'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.cuboid, color: scheme.primary),
                  const SizedBox(width: 10),
                  Text('Member of ${user.joinedClusters.length} clusters'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _has(String? s) => s != null && s.trim().isNotEmpty;
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}

class _StatTile extends StatelessWidget {
  final String label;
  final int value;
  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text('$value', style: Theme.of(context).textTheme.titleLarge),
          Text(label),
        ],
      ),
    ),
  );
}

class _LinkRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function() onPressed;
  const _LinkRow({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: onPressed,
            child: Text(text, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    ),
  );
}
