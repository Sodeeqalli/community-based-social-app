import 'package:bu_connect/features/message/message_controller/message_controller.dart';
import 'package:bu_connect/features/message/screen/forward_message_screen.dart';

import 'package:bu_connect/models/message_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MessageBubble extends ConsumerWidget {
  final Message message;
  final bool isMe;
  final bool isForwarded;
  final bool viewOnce;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.isForwarded,
    required this.viewOnce,
  }) : super(key: key);

  void deleteMessage(Message message, WidgetRef ref) {
    ref.read(messageControllerProvider.notifier).removeMessage(message);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime dateTime = message.timeStamp;
    String formattedDateTime = DateFormat('dd MMM y, HH:mm').format(dateTime);

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onLongPress: () {
            isMe
                ? showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Message'),
                        content: const Text(
                            'Are you sure you want to delete this message?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteMessage(message, ref);
                              Navigator.pop(context);
                            },
                            child: const Text('Delete'),
                          ),
                          if (!viewOnce)
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForwardMessageScreen(
                                      message: message,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Forward'),
                            )
                        ],
                      );
                    },
                  )
                : showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Message'),
                        content: viewOnce
                            ? _buildViewOnceContent()
                            : const Text('Do you want to forward this message'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: const Text('Cancel'),
                          ),
                          if (!viewOnce)
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForwardMessageScreen(
                                      message: message,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Forward'),
                            )
                        ],
                      );
                    },
                  );
          },
          child: Container(
            constraints: const BoxConstraints(maxWidth: 200),
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  isMe ? Colors.blue : const Color.fromARGB(255, 255, 40, 129),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (viewOnce)
                  IconButton(
                    icon: const Icon(Icons.play_circle_filled),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              actions: [
                                isMe
                                    ? TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('okay'))
                                    : TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          deleteMessage(message, ref);
                                        },
                                        child: const Text('read'))
                              ],
                              title: const Text('View Once'),
                              content: Text(message.text),
                            );
                          });
                    },
                  )
                else if (isForwarded)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(
                      'Forwarded',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                viewOnce
                    ? const SizedBox(
                        height: 0,
                      )
                    : Text(
                        message.text,
                        style: const TextStyle(color: Colors.white),
                      ),
              ],
            ),
          ),
        ),
        Text(
          formattedDateTime,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildViewOnceContent() {
    // You can customize the view once content as needed
    return const Column(
      children: [
        Text('This message can only be viewed once.'),
        Text('Are you sure you want to continue?'),
      ],
    );
  }
}
