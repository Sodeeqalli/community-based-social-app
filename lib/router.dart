import 'package:bu_connect/features/community/screens/add_mods_screen.dart';
import 'package:bu_connect/features/community/screens/community_screen.dart';
import 'package:bu_connect/features/community/screens/create_community_screen.dart';
import 'package:bu_connect/features/community/screens/edit_community_screen.dart';
import 'package:bu_connect/features/community/screens/mod_tool_screen.dart';
import 'package:bu_connect/features/community/screens/remove_users.dart';
import 'package:bu_connect/features/message/screen/message_screen.dart';
import 'package:bu_connect/features/post/screens/add_post_type_screen.dart';
import 'package:bu_connect/features/post/screens/comment_screen.dart';
import 'package:bu_connect/features/report/report.dart';
import 'package:bu_connect/features/showcase_view/loggin_in_page.dart';
import 'package:bu_connect/features/showcase_view/logging_out_page.dart';
import 'package:bu_connect/features/notifications/notification_screen.dart';
import 'package:bu_connect/features/terms_and_conditions/terms_and_conditions.dart';
import 'package:bu_connect/features/user_profile/screens/edit_profile_screen.dart';
import 'package:bu_connect/features/user_profile/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: LoggingOutPage(),
        ),
  },
);

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoggingInPage()),
  '/create-community': (_) =>
      const MaterialPage(child: CreateCommunityScreen()),
  '/r/:name': (route) => MaterialPage(
        child: CommunityScreen(name: route.pathParameters['name']!),
      ),
  '/mod-tools/:name': (routeData) => MaterialPage(
        child: ModToolsScreen(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/remove-users/:name': (routeData) => MaterialPage(
        child: RemoveUsers(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/edit-community/:name': (routeData) => MaterialPage(
        child: EditCommunityScreen(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/add-mods/:name': (routeData) => MaterialPage(
        child: AddModsScreen(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/u/:uid': (routeData) => MaterialPage(
        child: UserProfileScreen(
          uid: routeData.pathParameters['uid']!,
        ),
      ),
  '/edit-profile/:uid': (routeData) => MaterialPage(
        child: EditProfileScreen(
          uid: routeData.pathParameters['uid']!,
        ),
      ),
  '/add-post/:type': (routeData) => MaterialPage(
        child: AddPostTypeScreen(
          type: routeData.pathParameters['type']!,
        ),
      ),
  '/posts/:postId/comments': (route) => MaterialPage(
        child: CommentsScreen(
          postId: route.pathParameters['postId']!,
        ),
      ),
  '/messages/:receiverId': (route) => MaterialPage(
        child: MessageScreen(
          receiverId: route.pathParameters['receiverId']!,
        ),
      ),
  '/terms-and-conditions': (_) =>
      const MaterialPage(child: TermsAndConditionsScreen()),
  '/notifications-screen': (_) =>
      const MaterialPage(child: NotificationScreen()),
  '/report-page': (_) => const MaterialPage(child: ReportPage()),
});
