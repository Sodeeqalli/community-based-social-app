import 'package:bu_connect/core/type_defs.dart';
import 'package:bu_connect/core/utils.dart';

import 'package:bu_connect/models/message_model.dart';
import 'package:bu_connect/models/notification_model.dart';

import 'package:bu_connect/features/notifications/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, List<Message>>((ref) {
  final notificationRepository = ref.watch(notificationRepositoryProvider);

  return NotificationController(
    notificationRepository: notificationRepository,
  );
});

final getNotifcationsProvider =
    StreamProvider.family<List<NotificationModel>, String>(
  (ref, userId) {
    final notificationController =
        ref.watch(notificationControllerProvider.notifier);
    return notificationController.fetchNotifications(userId);
  },
);

class NotificationController extends StateNotifier<List<Message>> {
  final NotificationRepository _notificationRepository;

  NotificationController({
    required NotificationRepository notificationRepository,
  })  : _notificationRepository = notificationRepository,
        super([]);

  void addNotification({
    required BuildContext context,
    required String body,
    required String title,
    required String receiverId,
    required String senderId,
    required String type,
    String? path,
  }) async {
    String notificationId = const Uuid().v1();
    NotificationModel notification = NotificationModel(
        id: notificationId,
        title: title,
        body: body,
        date: DateTime.now(),
        type: type,
        receiverId: receiverId,
        senderId: senderId,
        path: path);

    final res = await _notificationRepository.addNotification(notification);

    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  Stream<List<NotificationModel>> fetchNotifications(String userId) {
    return _notificationRepository.getUserNotifications(userId);
  }

  FutureVoid removeNotification(NotificationModel notification) {
    return _notificationRepository.removeNotification(notification);
  }
}
