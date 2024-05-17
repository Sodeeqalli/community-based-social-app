import 'package:bu_connect/core/common/error_text.dart';
import 'package:bu_connect/core/common/loader.dart';
import 'package:bu_connect/core/providers/notifs_service.dart';
import 'package:bu_connect/features/auth/controller/auth_controller.dart';
import 'package:bu_connect/features/message/message_controller/message_controller.dart';
import 'package:bu_connect/features/message/widget/message_bubble.dart';
import 'package:bu_connect/features/notifications/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class MessageScreen extends ConsumerStatefulWidget {
  final String receiverId;

  const MessageScreen({
    required this.receiverId,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  final messageController = TextEditingController();
  bool viewOnce = false;
  final notificationService = NotficationService();
  void addMessage(String message) async {
    ref.read(messageControllerProvider.notifier).addMessage(
        context: context,
        text: message,
        receiverId: widget.receiverId,
        isForwarded: false,
        viewOnce: viewOnce);

    setState(() {
      messageController.text = '';
    });
  }

  void addNotification(String message) {
    final currentUser = ref.read(userProvider)!;
    ref.read(notificationControllerProvider.notifier).addNotification(
        context: context,
        body: message,
        title: 'Message Received',
        receiverId: widget.receiverId,
        senderId: currentUser.uid,
        type: 'message');
  }

  void navigateToUserProfile(BuildContext context, String userId) {
    Routemaster.of(context).push('/u/$userId');
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: ref.watch(getUserProfileProvider(widget.receiverId)).when(
          data: (userProfile) {
            return AppBar(
              title: GestureDetector(
                onTap: () {
                  navigateToUserProfile(context, userProfile.uid);
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(userProfile.profilePic),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      userProfile.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) {
            return AppBar(
              title: Text(error.toString()),
            );
          },
          loading: () => AppBar(
                title: const Loader(),
              )),
      body: Column(
        children: [
          Expanded(
            child: ref.watch(getMessagesProvider(widget.receiverId)).when(
                  data: (messages) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 28.0),
                      child: ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          final message = messages[index];

                          return MessageBubble(
                            message: message,
                            isMe: message.receiverId == widget.receiverId,
                            isForwarded: message.isForwarded,
                            viewOnce: message.viewOnce,
                          );
                        },
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return ErrorText(error: error.toString());
                  },
                  loading: () => const Loader(),
                ),
          ),
          ref.watch(getUserProfileProvider(widget.receiverId)).when(
                data: (receiver) {
                  if (receiver.blockedUsers!.contains(user.uid)) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('You have been blocked'),
                    );
                  } else if (user.blockedUsers!.contains(receiver.uid)) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 40.0),
                      child: Text('You have blocked this user'),
                    );
                  } else {
                    return _buildInputArea();
                  }
                },
                error: (error, stackTrace) {
                  return ErrorText(error: error.toString());
                },
                loading: () => const Loader(),
              )
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onSubmitted: (val) {
                addMessage(val);
              },
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              addNotification(messageController.text);
              addMessage(messageController.text);
            },
            child: const Text('Send'),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  viewOnce == false ? viewOnce = true : viewOnce = false;
                });
              },
              icon: Icon(
                Icons.offline_bolt,
                color: viewOnce ? Colors.blue : Colors.white,
              ))
        ],
      ),
    );
  }
}
