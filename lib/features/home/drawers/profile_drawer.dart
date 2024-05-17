import 'package:bu_connect/features/auth/controller/auth_controller.dart';
import 'package:bu_connect/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref, BuildContext context) {
    Navigator.of(context).pop();
    ref.read(authControllerProvider.notifier).logOut();
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/u/$uid');
  }

  void navigateToTermsAndConditions(BuildContext context) {
    Routemaster.of(context).push('/terms-and-conditions');
  }

  void navigateToReportPage(BuildContext context) {
    Routemaster.of(context).push('/report-page');
  }

  void navigateToNotifications(BuildContext context) {
    Routemaster.of(context).push('/notifications-screen');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.profilePic),
            radius: 70,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          ListTile(
            title: const Text('Notifications'),
            leading: const Icon(Icons.notifications),
            onTap: () => navigateToNotifications(context),
          ),
          ListTile(
            title: const Text('My profile'),
            leading: const Icon(Icons.person),
            onTap: () => navigateToUserProfile(context, user.uid),
          ),
          ListTile(
            title: const Text('Read Terms and Conditions'),
            leading: const Icon(Icons.read_more),
            onTap: () => navigateToTermsAndConditions(context),
          ),
          ListTile(
            title: const Text('Report User or Community'),
            leading: const Icon(Icons.report),
            onTap: () => navigateToReportPage(context),
          ),
          ListTile(
            title: const Text('Log Out'),
            leading: Icon(
              Icons.logout,
              color: Pallete.redColor,
            ),
            onTap: () => logOut(ref, context),
          ),
          Switch.adaptive(
            value: ref.watch(themeNotifierProvider.notifier).mode ==
                ThemeMode.dark,
            onChanged: (val) => toggleTheme(ref),
          ),
        ],
      )),
    );
  }
}
