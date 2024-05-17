import 'package:bu_connect/core/common/error_text.dart';
import 'package:bu_connect/core/common/loader.dart';
import 'package:bu_connect/core/utils.dart';
import 'package:bu_connect/features/auth/controller/auth_controller.dart';
import 'package:bu_connect/features/notifications/notification_controller.dart';
import 'package:bu_connect/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  void deleteNotification(NotificationModel notification) {
    ref
        .read(notificationControllerProvider.notifier)
        .removeNotification(notification);
  }

  void navigateToMessage(String uid) {
    Routemaster.of(context).push('/messages/$uid');
  }

  void navigateToCommunity(BuildContext context, String communityName) {
    Routemaster.of(context).push('/r/$communityName');
  }

  void navigateToComments(BuildContext context, String postId) {
    Routemaster.of(context).push('/posts/$postId/comments');
  }

  bool isDeleting = false;
  List<NotificationModel> notisToDelete = [];
  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          isDeleting
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isDeleting = false;
                    });
                    notisToDelete.clear();
                  },
                  icon: const Icon(Icons.cancel))
              : const SizedBox(),
          IconButton(
              onPressed: () {
                if (isDeleting && notisToDelete.isNotEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete Notifications'),
                          content: Text(
                              'Are you sure you want to delete the ${notisToDelete.length} notifications'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel")),
                            TextButton(
                                onPressed: () {
                                  for (final notification in notisToDelete) {
                                    deleteNotification(notification);
                                  }
                                  notisToDelete.clear();
                                  Navigator.pop(context);
                                  setState(() {
                                    isDeleting = false;
                                  });
                                },
                                child: const Text("Delete"))
                          ],
                        );
                      });
                } else {
                  setState(() {
                    isDeleting = true;
                  });
                  showSnackBar(
                      context, 'Select notifications you want to delete');
                }
              },
              icon: Icon(
                Icons.delete,
                color: isDeleting ? Colors.red : null,
              )),
        ],
      ),
      body: Column(
        children: [
          ref.watch(getNotifcationsProvider(user.uid)).when(
                data: (notifications) {
                  return Container(
                    height: 500,
                    padding: const EdgeInsets.only(bottom: 28.0),
                    child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (BuildContext context, int index) {
                        final notification = notifications[index];
                        String sender = ref
                            .read(getUserProfileProvider(notification.senderId))
                            .when(
                              data: (user) {
                                return user.name;
                              },
                              error: (error, stackTrace) {
                                return error.toString();
                              },
                              loading: () => '',
                            );
                        DateTime dateTime = notification.date;
                        String formattedDateTime =
                            DateFormat('dd MMM y, HH:mm').format(dateTime);

                        return GestureDetector(
                          onTap: () {
                            if (isDeleting) {
                              if (notisToDelete.contains(notification)) {
                                setState(() {
                                  notisToDelete.remove(notification);
                                });
                              } else {
                                setState(() {
                                  notisToDelete.add(notification);
                                });
                              }
                            } else {
                              deleteNotification(notification);
                              notification.type == 'message'
                                  ? navigateToMessage(notification.senderId)
                                  : notification.type == 'comment'
                                      ? navigateToComments(
                                          context, notification.path!)
                                      : navigateToCommunity(
                                          context, notification.path!);
                            }
                          },
                          child: ListTile(
                            tileColor: notisToDelete.contains(notification)
                                ? Colors.redAccent
                                : null,
                            leading: notification.type == 'message' ||
                                    notification.type == 'comment'
                                ? const Icon(Icons.message)
                                : notification.type == 'Post'
                                    ? const Icon(Icons.picture_in_picture_sharp)
                                    : null,
                            title: Row(
                              children: [
                                notification.type == 'message'
                                    ? Text('${notification.title} from $sender'
                                                .length <
                                            35
                                        ? '${notification.title} from $sender'
                                        : '${notification.title} from $sender'
                                            .substring(0, 35))
                                    : notification.type == 'Post'
                                        ? Text('${notification.title} by $sender on ${notification.path}'
                                                    .length <
                                                35
                                            ? '${notification.title} by $sender on ${notification.path}'
                                            : '${notification.title} by $sender on ${notification.path}'
                                                .substring(0, 35))
                                        : Text('$sender commented on your post'
                                                    .length <
                                                35
                                            ? '$sender commented on your post'
                                            : '$sender commented on your post'
                                                .substring(0, 35))
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  notification.body,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 0, 0)),
                                ),
                                Text(
                                  formattedDateTime,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 0, 0)),
                                ),
                              ],
                            ),
                          ),
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
        ],
      ),
    );
    // Your widget's build method content
  }
}
