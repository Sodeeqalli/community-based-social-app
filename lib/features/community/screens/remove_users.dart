import 'package:bu_connect/core/common/loader.dart';
import 'package:bu_connect/features/auth/controller/auth_controller.dart';
import 'package:bu_connect/features/community/controller/community_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RemoveUsers extends ConsumerStatefulWidget {
  final String name;
  const RemoveUsers({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RemoveUsersState();
}

class _RemoveUsersState extends ConsumerState<RemoveUsers> {
  void removeMember(String uid) {
    ref
        .read(communityControllerProvider.notifier)
        .removeUser(widget.name, uid, context);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider)!;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: ref.watch(getCommunityByNameProvider(widget.name)).when(
              data: (community) {
                return ListView.builder(
                    itemCount: community.members.length,
                    itemBuilder: (context, index) {
                      final memberId = community.members[index];
                      return ref.watch(getUserProfileProvider(memberId)).when(
                          data: (member) {
                            return member.uid == user.uid ||
                                    community.mods.contains(member.uid)
                                ? const SizedBox()
                                : ListTile(
                                    title: Text(member.name),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Are you sure you want to remove user'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        removeMember(memberId);
                                                      },
                                                      child: const Text(
                                                          'Remove User')),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text('Cancel')),
                                                ],
                                              );
                                            });
                                      },
                                    ),
                                  );
                          },
                          error: (error, stackTrace) {
                            return Text(error.toString());
                          },
                          loading: () => AppBar(
                                title: const Loader(),
                              ));
                    });
              },
              error: (error, stackTrace) {
                return Text(error.toString());
              },
              loading: () => AppBar(
                title: const Loader(),
              ),
            ));
  }
}
