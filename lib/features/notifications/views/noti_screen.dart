import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:node/core/services/notification_service.dart';
import 'package:node/features/notifications/providers/notifiaction_provider.dart';

import 'package:node/shared/models/notif_item.dart';

Map<String, List<NotifItem>> groupByNode(List<NotifItem> items) {
  final groups = <String, List<NotifItem>>{};
  for (final n in items) {
    groups.putIfAbsent(n.nodeId, () => []).add(n); // newest first is preserved
  }
  return groups;
}

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  bool _markedRead = false;

  void _markReadOnce(List<NotifItem> items) {
    if (_markedRead || !items.any((n) => !n.read)) return;
    _markedRead = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await markAllRead(items);
        if (!mounted) return;
        ref.invalidate(unreadCountProvider); // clears the badge
        // notificationsProvider is not invalidated, so the unread dots stay
        // visible during this visit and disappear the next time it opens
      } catch (e) {
        debugPrint('markAllRead failed: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(notificationsProvider),
            child: const Text("Couldn't load notifications. Tap to retry"),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Nothing here yet.'));
          }
          _markReadOnce(items);

          final groups = groupByNode(items).values.toList();
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(notificationsProvider),
            child: ListView.separated(
              itemCount: groups.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) => _NotifGroupTile(group: groups[i]),
            ),
          );
        },
      ),
    );
  }
}

class _NotifGroupTile extends StatelessWidget {
  const _NotifGroupTile({required this.group});

  final List<NotifItem> group; // newest first

  @override
  Widget build(BuildContext context) {
    final latest = group.first;
    final hasUnread = group.any((n) => !n.read);

    final names = group.map((n) => n.actorName).toSet().toList();
    final who = names.length == 1
        ? names.first
        : '${names.first} and ${names.length - 1} other${names.length > 2 ? 's' : ''}';

    return ListTile(
      leading: const CircleAvatar(child: Icon(LucideIcons.messageCircle)),
      title: Text(
        '$who commented on "${latest.nodeTitle}"',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
      subtitle: Text(
        latest.preview,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: hasUnread
          ? Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            )
          : null,
      onTap: () => NotificationService.openPostById(latest.nodeId),
    );
  }
}
