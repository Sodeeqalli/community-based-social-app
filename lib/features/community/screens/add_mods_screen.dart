import 'package:bu_connect/core/common/error_text.dart';
import 'package:bu_connect/core/common/loader.dart';
import 'package:bu_connect/features/auth/controller/auth_controller.dart';
import 'package:bu_connect/features/community/controller/community_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModsScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> uids = {};

  @override
  void initState() {
    super.initState();
    // Initialization moved to initState to ensure it happens once
    // and properly sets up before the widget builds.
    // You might need to adjust this part based on how you fetch your community data.
    // For example, if fetching community data is asynchronous, consider using a FutureBuilder
    // or similar to fetch the data before attempting to access community.mods.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final community =
          await ref.read(getCommunityByNameProvider(widget.name).future);
      setState(() {
        uids.addAll(community.mods);
      });
    });
  }

  void addUid(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveMods() {
    ref
        .read(communityControllerProvider.notifier)
        .addMods(widget.name, uids.toList(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveMods,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => ListView.builder(
              itemCount: community.members.length,
              itemBuilder: (BuildContext context, int index) {
                final member = community.members[index];
                return ref.watch(getUserProfileProvider(member)).when(
                    data: (user) => CheckboxListTile(
                          value: uids.contains(user.uid),
                          onChanged: (val) {
                            if (val!) {
                              addUid(user.uid);
                            } else {
                              removeUid(user.uid);
                            }
                            setState(
                                () {}); // This ensures the UI updates with the change
                          },
                          title: Text(user.name),
                        ),
                    error: (error, stackTrace) =>
                        ErrorText(error: error.toString()),
                    loading: () => const Loader());
              }),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
