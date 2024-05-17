import 'package:bu_connect/core/type_defs.dart';
import 'package:bu_connect/core/utils.dart';
import 'package:bu_connect/features/auth/controller/auth_controller.dart';
import 'package:bu_connect/features/message/message_repository/message_repository.dart';

import 'package:bu_connect/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final messageControllerProvider =
    StateNotifierProvider<MessageController, List<Message>>((ref) {
  final messageRepository = ref.watch(messageRepositoryProvider);

  return MessageController(
    messageRepository: messageRepository,
    ref: ref,
  );
});

final getMessagesProvider = StreamProvider.family<List<Message>, String>(
  (ref, receiverId) {
    final messageController = ref.watch(messageControllerProvider.notifier);
    final user = ref.read(userProvider)!;
    return messageController.fetchMessages(user.uid, receiverId);
  },
);

final getUniqueIdsProvider = StreamProvider.family<List<String>, String>(
  (ref, userId) {
    final messageController = ref.watch(messageControllerProvider.notifier);

    return messageController.getUniqueUserIds(userId);
  },
);

class MessageController extends StateNotifier<List<Message>> {
  final MessageRepository _messageRepository;
  final Ref _ref;

  MessageController({
    required MessageRepository messageRepository,
    required Ref ref,
  })  : _messageRepository = messageRepository,
        _ref = ref,
        super([]);

  void addMessage({
    required BuildContext context,
    required String text,
    required String receiverId,
    required bool isForwarded,
    required bool viewOnce,
  }) async {
    final user = _ref.read(userProvider)!;
    String messageId = const Uuid().v1();
    Message message = Message(
        messageId: messageId,
        timeStamp: DateTime.now(),
        text: text,
        senderId: user.uid,
        receiverId: receiverId,
        isForwarded: isForwarded,
        viewOnce: viewOnce);

    final res = await _messageRepository.addMessage(message);

    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  Stream<List<Message>> fetchMessages(String senderId, String receiverId) {
    return _messageRepository.getFilteredMessages(
        senderId: senderId, receiverId: receiverId);
  }

  FutureVoid removeMessage(Message message) {
    return _messageRepository.removeMessage(message);
  }

  Stream<List<String>> getUniqueUserIds(String userId) {
    return _messageRepository.getUniqueUserIds(userId);
  }
}
