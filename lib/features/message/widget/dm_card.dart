import 'package:bu_connect/models/message_model.dart';
import 'package:bu_connect/theme/pallete.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DMCard extends ConsumerWidget {
  final String userName;
  final Message lastMessage;
  final String profileImageUrl;
  final String uid;
  final bool blocked;
  final Color? color;
  final void Function() onPress;

  const DMCard(
      {Key? key,
      required this.userName,
      required this.lastMessage,
      required this.profileImageUrl,
      required this.uid,
      required this.blocked,
      this.color,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = ref.watch(themeNotifierProvider);
    DateTime dateTime = lastMessage.timeStamp;
    String formattedDateTime = DateFormat('dd MMM y, HH:mm').format(dateTime);

    return GestureDetector(
      onTap: onPress,
      child: Card(
        color: color ?? themeData.dialogBackgroundColor,
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(blocked
                        ? 'https://www.shutterstock.com/image-vector/block-dismiss-user-260nw-795805543.jpg'
                        : profileImageUrl),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      lastMessage.viewOnce
                          ? const Icon(Icons.play_circle_filled)
                          : Text(
                              lastMessage.text.length > 30
                                  ? lastMessage.text.substring(1, 30)
                                  : lastMessage.text,
                              style: TextStyle(
                                fontSize: 14,
                                color: themeData.textTheme.bodyLarge!.color,
                              ),
                            ),
                    ],
                  ),
                ],
              ),
              blocked
                  ? const Positioned(
                      bottom: 0,
                      right: 0,
                      child: Text(
                        'Blocked',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Positioned(
                      bottom: 0,
                      right: 0,
                      child: Text(
                        formattedDateTime,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
