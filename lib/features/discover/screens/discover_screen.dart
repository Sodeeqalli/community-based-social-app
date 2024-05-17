import 'package:bu_connect/core/common/error_text.dart';
import 'package:bu_connect/core/common/loader.dart';
import 'package:bu_connect/core/common/user_card.dart';
import 'package:bu_connect/features/auth/controller/auth_controller.dart';
import 'package:bu_connect/features/community/controller/community_controller.dart';
import 'package:bu_connect/features/message/message_controller/message_controller.dart';
import 'package:bu_connect/models/community_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    final user = ref.read(userProvider)!;
    List<String> friends = ref.watch(getUniqueIdsProvider(user.uid)).when(
        data: (data) => data,
        error: (error, stackTrace) => [],
        loading: () => []);

    Set<String> seenUserIds = {}; // Set to track unique user IDs

    ref.watch(userCommunitiesProvider(user.uid)).when(
      data: (communities) {
        for (final community in communities) {
          for (final userId in community.members) {
            if (!friends.contains(userId) &&
                !seenUserIds.contains(userId) &&
                user.uid != userId) {
              ref.watch(getUserProfileProvider(userId)).when(
                data: (users) {
                  seenUserIds.add(users.uid);
                  ref.watch(userCommunitiesProvider(userId)).when(
                      data: (joinedcommunities) {
                        widgets.add(UserCard(
                          userId: users.uid,
                          userName: users.name,
                          profileImageUrl: users.profilePic,
                          communities:
                              ref.watch(userCommunitiesProvider(user.uid)).when(
                                  data: (usercommunities) {
                                    List<Community> communityList = [];
                                    for (final community in usercommunities) {
                                      joinedcommunities.contains(community)
                                          ? communityList.add(community)
                                          : null;
                                    }
                                    return communityList;
                                  },
                                  error: (error, stackTrace) => [],
                                  loading: () => []),
                        ));
                      },
                      error: (error, stackTrace) => Text(error.toString()),
                      loading: () =>
                          const Loader()); // Add the user ID to the set to mark it as seen
                },
                error: (error, stackTrace) {
                  widgets.add(ErrorText(error: error.toString()));
                },
                loading: () {
                  widgets.add(const Loader());
                },
              );
            }
          }
        }
      },
      error: (error, stackTrace) {
        widgets.add(ErrorText(error: error.toString()));
      },
      loading: () {
        widgets.add(const Loader());
      },
    );

    return Scaffold(
      body: Column(
        children: widgets,
      ),
    );
  }
}
