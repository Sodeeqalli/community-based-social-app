import 'package:bu_connect/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bu_connect/features/message/widget/dm_card.dart';
import 'package:bu_connect/core/common/error_text.dart';
import 'package:bu_connect/core/common/loader.dart';
import 'package:bu_connect/features/auth/controller/auth_controller.dart';
import 'package:bu_connect/features/message/message_controller/message_controller.dart';
import 'package:bu_connect/models/message_model.dart';

import 'package:uuid/v1.dart';
// ... (imports)

class ForwardMessageScreen extends ConsumerStatefulWidget {
  final Message message;
  const ForwardMessageScreen({Key? key, required this.message})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForwardMessageScreenState();
}

class _ForwardMessageScreenState extends ConsumerState<ForwardMessageScreen> {
  Color? color;
  List<UserModel> receivers = [];

  void addUser(UserModel receiver) {
    setState(() {
      receivers.add(receiver);
    });
  }

  void removeUser(UserModel receiver) {
    setState(() {
      receivers.remove(receiver);
    });
  }

  void onForward(List<UserModel> receivers, UserModel currentUser,
      BuildContext context) async {
    final receiversCopy = List<UserModel>.from(receivers);

    for (final receiver in receiversCopy) {
      if (currentUser.blockedUsers!.contains(receiver.uid) ||
          receiver.blockedUsers!.contains(currentUser.uid)) {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Blocked'),
              content: Text('You have been blocked by ${receiver.name}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Okay'),
                )
              ],
            );
          },
        );
      } else {
        ref.read(messageControllerProvider.notifier).addMessage(
            context: context,
            text: widget.message.text,
            receiverId: receiver.uid,
            isForwarded: true,
            viewOnce: false);
      }

      receivers.remove(receiver);
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick User you want to forward'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ref.watch(getUniqueIdsProvider(user.uid)).when(
                  data: (usersIds) {
                    return ListView(
                      children: usersIds.map((userId) {
                        return ref.watch(getUserProfileProvider(userId)).when(
                              data: (userProfile) {
                                return userProfile != user
                                    ? InkWell(
                                        child: DMCard(
                                          onPress: () {
                                            receivers.contains(userProfile)
                                                ? removeUser(userProfile)
                                                : addUser(userProfile);
                                          },
                                          color: receivers.contains(userProfile)
                                              ? Colors.amberAccent
                                              : null,
                                          userName: userProfile.name,
                                          lastMessage: ref
                                              .watch(getMessagesProvider(
                                                  userProfile.uid))
                                              .when(
                                                data: (messages) =>
                                                    messages.first,
                                                error: (error, stackTrace) =>
                                                    Message(
                                                  messageId:
                                                      const UuidV1().toString(),
                                                  timeStamp: DateTime.now(),
                                                  text: error.toString(),
                                                  senderId: 'null',
                                                  receiverId: 'null',
                                                ),
                                                loading: () => Message(
                                                  messageId:
                                                      const UuidV1().toString(),
                                                  timeStamp: DateTime.now(),
                                                  text: 'loading',
                                                  senderId: 'null',
                                                  receiverId: 'null',
                                                ),
                                              ),
                                          profileImageUrl:
                                              userProfile.profilePic,
                                          uid: userProfile.uid,
                                          blocked: user.blockedUsers!
                                              .contains(userProfile.uid),
                                        ),
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
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                onForward(receivers, user, context);
              },
              child: const Text('Forward'),
            ),
          ),
        ],
      ),
    );
  }
}
