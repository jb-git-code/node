import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node/core/services/notifiaction_listener_service.dart';
import 'package:node/features/nodes/providers/current_user_provider.dart';

final notificationListenerProvider = Provider<void>((ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return;

  final service = NotificationListenerService()..start(user.authorId);
  ref.onDispose(service.stop);
});
