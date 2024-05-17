import 'package:bu_connect/core/constants/firebase_constants.dart';
import 'package:bu_connect/core/failure.dart';
import 'package:bu_connect/core/providers/firebase_providers.dart';
import 'package:bu_connect/core/type_defs.dart';
import 'package:bu_connect/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final discoverRepositoryProvider = Provider((ref) {
  return DiscoverRepository(firestore: ref.watch(firestoreProvider));
});

class DiscoverRepository {
  final FirebaseFirestore _firestore;
  DiscoverRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _messages =>
      _firestore.collection(FirebaseConstants.messagesCollection);

  FutureVoid addMessage(Message message) async {
    try {
      var result = await _messages.doc(message.messageId).set(message.toMap());

      return right(result);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Message>> getMessagesBetweenUsers(
      {required String senderId, required String receiverId}) {
    return _messages
        .where('senderId', whereIn: [senderId, receiverId])
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => Message.fromMap(
                e.data() as Map<String, dynamic>,
              ),
            )
            .toList());
  }

  Stream<List<String>> getUniqueUserIds(String userId) {
    return _messages
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map((event) {
      final messages = event.docs
          .map(
            (e) => Message.fromMap(
              e.data() as Map<String, dynamic>,
            ),
          )
          .where((message) =>
              message.receiverId == userId || message.senderId == userId)
          .toList();

      final uniqueUserIds = messages
          .map((message) => [message.receiverId, message.senderId])
          .expand((ids) => ids)
          .toSet()
          .toList();

      return uniqueUserIds;
    });
  }

  Stream<List<Message>> getFilteredMessages(
      {required String senderId, required String receiverId}) {
    return getMessagesBetweenUsers(senderId: senderId, receiverId: receiverId)
        .map((messages) => messages
            .where((message) =>
                message.receiverId == senderId ||
                message.receiverId == receiverId)
            .toList());
  }
}
