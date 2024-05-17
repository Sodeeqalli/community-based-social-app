import 'package:bu_connect/features/message/widget/dm_card.dart';
import 'package:bu_connect/core/common/error_text.dart';
import 'package:bu_connect/core/common/loader.dart';
import 'package:bu_connect/features/auth/controller/auth_controller.dart';
import 'package:bu_connect/features/message/message_controller/message_controller.dart';
import 'package:bu_connect/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/v1.dart';

class MessagesCollection extends ConsumerWidget {
  const MessagesCollection({Key? key}) : super(key: key);

  void navigateToMessage(BuildContext context, String uid) {
    Routemaster.of(context).push('/messages/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider)!;

    return Scaffold(
      body: ref.watch(getUniqueIdsProvider(user.uid)).when(
            data: (usersIds) {
              return Column(
                children: usersIds.map((userId) {
                  return ref.watch(getUserProfileProvider(userId)).when(
                        data: (userProfile) {
                          return userProfile != user
                              ? DMCard(
                                  onPress: () {
                                    navigateToMessage(context, userProfile.uid);
                                  },
                                  userName: userProfile.name,
                                  lastMessage: ref
                                      .watch(
                                          getMessagesProvider(userProfile.uid))
                                      .when(
                                        data: (messages) => messages.first,
                                        error: (error, stackTrace) => Message(
                                            messageId:
                                                const UuidV1().toString(),
                                            timeStamp: DateTime.now(),
                                            text: error.toString(),
                                            senderId: 'null',
                                            receiverId: 'null'),
                                        loading: () => Message(
                                            messageId:
                                                const UuidV1().toString(),
                                            timeStamp: DateTime.now(),
                                            text: 'loading',
                                            senderId: 'null',
                                            receiverId: 'null'),
                                      ),
                                  profileImageUrl: userProfile.profilePic,
                                  uid: userProfile.uid,
                                  blocked: user.blockedUsers!
                                      .contains(userProfile.uid),
                                )
                              : const SizedBox(
                                  height: 0,
                                );
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      );
                }).toList(),
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
