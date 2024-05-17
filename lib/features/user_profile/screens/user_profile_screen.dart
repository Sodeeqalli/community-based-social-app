import 'package:bu_connect/core/common/error_text.dart';
import 'package:bu_connect/core/common/loader.dart';
import 'package:bu_connect/features/post/widget/post_card.dart';
import 'package:bu_connect/features/auth/controller/auth_controller.dart';
import 'package:bu_connect/features/user_profile/controller/user_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({super.key, required this.uid});

  void navigateToEditUser(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  void navigateToMessage(BuildContext context) {
    Routemaster.of(context).push('/messages/$uid');
  }

  void blockUser(String uid, WidgetRef ref) {
    ref.read(userProfileControllerProvider.notifier).addBlockedUser(uid);
  }

  void unblockUser(String uid, WidgetRef ref) {
    ref.read(userProfileControllerProvider.notifier).removeBlockedUser(uid);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.read(userProvider)!;

    return Scaffold(
      body: ref.watch(getUserProfileProvider(uid)).when(
          data: (user) {
            if (currentUser.blockedUsers!.contains(user.uid)) {
              return Column(
                children: [
                  AppBar(),
                  const Center(
                    child: Text('User Blocked'),
                  ),
                  ElevatedButton(
                      onPressed: () => unblockUser(uid, ref),
                      child: const Text('Unblock'))
                ],
              );
            } else if (user.blockedUsers!.contains(currentUser.uid)) {
              return Column(
                children: [
                  AppBar(),
                  const Center(
                    child: Text(' Blocked you'),
                  ),
                  ElevatedButton(onPressed: () {}, child: const Text('Unblock'))
                ],
              );
            } else {
              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 250,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              user.banner,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding:
                                const EdgeInsets.all(20).copyWith(bottom: 70),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(user.profilePic),
                              radius: 45,
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.all(20),
                            child: OutlinedButton(
                              onPressed: () => currentUser.uid == uid
                                  ? navigateToEditUser(context)
                                  : navigateToMessage(context),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                              ),
                              child: Text(currentUser.uid == uid
                                  ? 'Edit Profile'
                                  : 'Message'),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            padding: const EdgeInsets.all(20),
                            child: OutlinedButton(
                              onPressed: () => currentUser.uid == uid
                                  ? null
                                  : blockUser(uid, ref),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                              ),
                              child: currentUser.uid == uid
                                  ? const SizedBox(
                                      height: 0,
                                    )
                                  : const Text('Block User'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(top: 10),
                              child: Text('${user.karma} star'),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                          ],
                        ),
                      ),
                    )
                  ];
                },
                body: ref.watch(getuserPostsProvider(uid)).when(
                    data: (data) {
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final post = data[index];
                            return PostCard(post: post);
                          });
                    },
                    error: (error, stackTrace) {
                      return ErrorText(error: error.toString());
                    },
                    loading: () => const Loader()),
              );
            }
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
