import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String profilePic;
  final String banner;
  final String uid;
  final bool isAuthenticated;
  final int karma;
  final List<String> award;
  final List<String>? blockedUsers;
  final bool
      isNew; // Added new boolean property, renamed to isNew to avoid naming conflict

  UserModel({
    required this.name,
    required this.profilePic,
    required this.banner,
    required this.uid,
    required this.isAuthenticated,
    required this.karma,
    required this.award,
    this.blockedUsers,
    required this.isNew, // Initialize the new boolean property
  });

  UserModel copyWith({
    String? name,
    String? profilePic,
    String? banner,
    String? uid,
    bool? isAuthenticated,
    int? karma,
    List<String>? award,
    List<String>? blockedUsers,
    bool? isNew, // Added parameter to copyWith
  }) {
    return UserModel(
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      banner: banner ?? this.banner,
      uid: uid ?? this.uid,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      karma: karma ?? this.karma,
      award: award ?? this.award,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      isNew: isNew ?? this.isNew, // Updated copyWith
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'banner': banner,
      'uid': uid,
      'isAuthenticated': isAuthenticated,
      'karma': karma,
      'award': award,
      'blockedUsers': blockedUsers,
      'isNew': isNew, // Added toMap
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      banner: map['banner'] as String,
      uid: map['uid'] as String,
      isAuthenticated: map['isAuthenticated'] as bool,
      karma: map['karma'] as int,
      award: List<String>.from((map['award'] as List<dynamic>).cast<String>()),
      blockedUsers: List<String>.from(
          (map['blockedUsers'] as List<dynamic>?)?.cast<String>() ?? []),
      isNew: map['isNew'] as bool, // Initialize fromMap with isNew
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, profilePic: $profilePic, banner: $banner, uid: $uid, isAuthenticated: $isAuthenticated, karma: $karma, award: $award, blockedUsers: $blockedUsers, isNew: $isNew)'; // Updated toString
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.profilePic == profilePic &&
        other.banner == banner &&
        other.uid == uid &&
        other.isAuthenticated == isAuthenticated &&
        other.karma == karma &&
        listEquals(other.award, award) &&
        listEquals(other.blockedUsers, blockedUsers) &&
        other.isNew == isNew; // Updated equality check
  }

  @override
  int get hashCode {
    return name.hashCode ^
        profilePic.hashCode ^
        banner.hashCode ^
        uid.hashCode ^
        isAuthenticated.hashCode ^
        karma.hashCode ^
        award.hashCode ^
        blockedUsers.hashCode ^
        isNew.hashCode; // Updated hashCode
  }
}
