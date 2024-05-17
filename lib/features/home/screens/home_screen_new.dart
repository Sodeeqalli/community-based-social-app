// ignore_for_file: deprecated_member_use

import 'package:bu_connect/core/constants/constants.dart';
import 'package:bu_connect/features/auth/controller/auth_controller.dart';
import 'package:bu_connect/features/home/delegates/search_community_delegate.dart';
import 'package:bu_connect/features/home/drawers/community_list_drawer.dart';
import 'package:bu_connect/features/home/drawers/profile_drawer.dart';
import 'package:bu_connect/features/showcase_view/showcase_view.dart';
import 'package:bu_connect/theme/pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeScreenNew extends ConsumerStatefulWidget {
  const HomeScreenNew({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends ConsumerState<HomeScreenNew> {
  final GlobalKey globalKeyOne = GlobalKey();
  final GlobalKey globalKeyTwo = GlobalKey();
  final GlobalKey globalKeyThree = GlobalKey();
  final GlobalKey globalKeyFour = GlobalKey();

  int _page = 0;

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  String _getPageTitle(int page) {
    if (page == 0) {
      return 'Home';
    } else if (page == 1) {
      return 'Add Post';
    } else if (page == 2) {
      return 'Discover';
    } else if (page == 3) {
      return 'Messages';
    } else {
      return ''; // Handle other cases if needed
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        ShowCaseWidget.of(context).startShowCase(
            [globalKeyOne, globalKeyTwo, globalKeyThree, globalKeyFour]));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(_getPageTitle(_page)),
        centerTitle: false,
        leading: Builder(builder: (context) {
          return ShowCaseView(
            globalKey: globalKeyTwo,
            title: 'View Communities',
            description: 'Manage communities you are a part of',
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => displayDrawer(context),
            ),
          );
        }),
        actions: [
          ShowCaseView(
            globalKey: globalKeyOne,
            title: 'Search Communities',
            description:
                'Explore vast amount of communities within Babcock University',
            child: IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: SearchCommunityDelegate(ref));
                },
                icon: const Icon(Icons.search)),
          ),
          Builder(builder: (context) {
            return ShowCaseView(
              globalKey: globalKeyThree,
              title: 'Your Profile',
              description: 'View and manage your profile',
              child: IconButton(
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                ),
                onPressed: () => displayEndDrawer(context),
              ),
            );
          })
        ],
      ),
      body: Constants.tabWidgets[_page],
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: currentTheme.iconTheme.color,
        backgroundColor: currentTheme.backgroundColor,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
              ),
              label: 'Add Post'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.accessibility_new,
              ),
              label: 'Discover'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.message_rounded,
              ),
              label: 'Messages')
        ],
        onTap: onPageChanged,
        currentIndex: _page,
      ),
    );
  }
}
