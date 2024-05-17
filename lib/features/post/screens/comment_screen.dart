import 'package:bu_connect/core/common/error_text.dart';
import 'package:bu_connect/core/common/loader.dart';
import 'package:bu_connect/features/auth/controller/auth_controller.dart';
import 'package:bu_connect/features/notifications/notification_controller.dart';
import 'package:bu_connect/features/post/widget/post_card.dart';
import 'package:bu_connect/features/post/controller/post_controller.dart';
import 'package:bu_connect/features/post/widget/comment_card.dart';
import 'package:bu_connect/models/post_model.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );

    setState(() {
      commentController.text = '';
    });
  }

  void addNotification(String message, Post post) {
    final currentUser = ref.read(userProvider)!;
    ref.read(notificationControllerProvider.notifier).addNotification(
        context: context,
        body: message,
        title: 'Comment',
        receiverId: post.uid,
        senderId: currentUser.uid,
        type: 'comment',
        path: post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (post) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    PostCard(post: post),
                    TextField(
                      onSubmitted: (val) {
                        addNotification(commentController.text, post);
                        addComment(post);
                      },
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: 'What are your thoughts',
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                    ref.watch(getPostCommentsProvider(widget.postId)).when(
                          data: (data) {
                            return ListView.builder(
                              shrinkWrap:
                                  true, // Ensure the ListView doesn't take more space than needed
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                final comment = data[index];
                                return CommentCard(
                                  comment: comment,
                                  post: post,
                                );
                              },
                            );
                          },
                          error: (error, stackTrace) {
                            return ErrorText(error: error.toString());
                          },
                          loading: () => const Loader(),
                        )
                  ],
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
