import 'package:bu_connect/core/constants/firebase_constants.dart';
import 'package:bu_connect/core/failure.dart';
import 'package:bu_connect/core/providers/firebase_providers.dart';
import 'package:bu_connect/core/type_defs.dart';

import 'package:bu_connect/models/notification_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final notificationRepositoryProvider = Provider((ref) {
  return NotificationRepository(firestore: ref.watch(firestoreProvider));
});

class NotificationRepository {
  final FirebaseFirestore _firestore;
  NotificationRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _notifications =>
      _firestore.collection(FirebaseConstants.notificationsCollection);

  FutureVoid addNotification(NotificationModel notification) async {
    try {
      var result =
          await _notifications.doc(notification.id).set(notification.toMap());

      return right(result);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid removeNotification(NotificationModel notification) async {
    try {
      var result = await _notifications.doc(notification.id).delete();

      return right(result);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<NotificationModel>> getUserNotifications(String uid) {
    return _notifications
        .where('receiverId', isEqualTo: uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => NotificationModel.fromMap(
                e.data() as Map<String, dynamic>,
              ),
            )
            .toList());
  }
}
