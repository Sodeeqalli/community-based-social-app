import 'package:bu_connect/core/common/error_text.dart';
import 'package:bu_connect/core/common/loader.dart';
import 'package:bu_connect/features/auth/controller/auth_controller.dart';
import 'package:bu_connect/features/post/controller/post_controller.dart';
import 'package:bu_connect/models/comments_model.dart';
import 'package:bu_connect/models/post_model.dart';
import 'package:bu_connect/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentCard extends ConsumerStatefulWidget {
  final Comment comment;
  final Post? post;
  const CommentCard({Key? key, required this.comment, this.post})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends ConsumerState<CommentCard> {
  bool isReplying = false;
  bool showReplies = false;
  final TextEditingController replyController = TextEditingController();

  void toggleReply() {
    setState(() {
      isReplying = !isReplying;
    });
  }

  void toggleShowReplies() {
    setState(() {
      showReplies = !showReplies;
    });
  }

  void deleteComment() {
    widget.post!.commentCount--;
    ref
        .read(postControllerProvider.notifier)
        .deleteComment(widget.comment, context);
  }

  void addReply(Comment comment) {
    ref.read(postControllerProvider.notifier).addComment(
        context: context,
        text: replyController.text.trim(),
        previousComment: comment);

    setState(() {
      isReplying = false;
      replyController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = ref.read(userProvider)!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.comment.profilePic),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.comment.username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.comment.text,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: toggleReply,
                icon: const Icon(Icons.reply),
              ),
              const Text('Reply'),
              IconButton(
                onPressed: toggleShowReplies,
                icon: const Icon(Icons.visibility),
              ),
              const Text('Show Replies'),
              user.uid == widget.comment.userId
                  ? IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: const Text('Delete Comment'),
                                content: const Text(
                                    'Are you sure you want to delete this comment?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      deleteComment();
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ]);
                          },
                        );
                      },
                      icon: const Icon(Icons.delete),
                    )
                  : const SizedBox(),
            ],
          ),
          if (isReplying)
            Container(
              constraints: const BoxConstraints(
                  maxHeight:
                      200), // Set a maximum height or use a specific constraint
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: replyController,
                    decoration: const InputDecoration(
                      hintText: 'Your reply...',
                    ),
                    onSubmitted: (String replyText) {
                      addReply(widget.comment);
                    },
                  ),
                ],
              ),
            ),
          if (showReplies)
            ref.watch(getCommentsRepliesProvider(widget.comment.id)).when(
                  data: (data) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final reply = data[index];
                        return Container(
                            padding: const EdgeInsets.only(left: 28),
                            child: CommentCard(
                              comment: reply,
                            ));
                      },
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
  }
}
