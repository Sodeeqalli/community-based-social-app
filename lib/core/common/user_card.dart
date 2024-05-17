import 'package:bu_connect/models/community_model.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class UserCard extends StatelessWidget {
  final String userName;
  final String userId;
  final String profileImageUrl;
  final List<Community> communities;

  const UserCard({
    Key? key,
    required this.userId,
    required this.userName,
    required this.profileImageUrl,
    required this.communities,
  }) : super(key: key);

  void navigateToUserProfile(BuildContext context, String userId) {
    // ignore: unnecessary_brace_in_string_interps
    Routemaster.of(context).push('/u/${userId}');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateToUserProfile(context, userId);
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(profileImageUrl),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: communities
                            .map((community) => Text(
                                  "${community.name}   ",
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))
                            .toList(),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
