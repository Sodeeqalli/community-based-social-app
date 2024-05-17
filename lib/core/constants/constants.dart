import 'package:bu_connect/features/discover/screens/discover_screen.dart';
import 'package:bu_connect/features/feed/feed_screen.dart';
import 'package:bu_connect/features/message/screen/messages_collection_screen.dart';
import 'package:bu_connect/features/post/screens/add_post_screen.dart';

import 'package:flutter/material.dart';

class Constants {
  static const logoPath = 'assets/images/babcock.png';
  static const emotePath = 'assets/images/emote.png';
  static const introPath = 'assets/images/intro.png';
  static const googlePath = 'assets/images/google.png';
  static const communityPath = 'assets/images/community.png';
  static const connectPath = 'assets/images/connect.png';
  static const growPath = 'assets/images/grow.png';

  static const bannerDefault =
      'https://thumbs.dreamstime.com/b/abstract-stained-pattern-rectangle-background-blue-sky-over-fiery-red-orange-color-modern-painting-art-watercolor-effe-texture-123047399.jpg';
  static const avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';

  static const tabWidgets = [
    FeedScreen(),
    AddPostsScreen(),
    DiscoverScreen(),
    MessagesCollection(),
  ];

  static const IconData up =
      IconData(0xe800, fontFamily: 'MyFlutterApp', fontPackage: null);
  static const IconData down =
      IconData(0xe801, fontFamily: 'MyFlutterApp', fontPackage: null);

  static const awardsPath = 'assets/images/awards';

  static const awards = {
    'awesomeAns': '${Constants.awardsPath}/awesomeanswer.png',
    'gold': '${Constants.awardsPath}/gold.png',
    'platinum': '${Constants.awardsPath}/platinum.png',
    'helpful': '${Constants.awardsPath}/helpful.png',
    'plusone': '${Constants.awardsPath}/plusone.png',
    'rocket': '${Constants.awardsPath}/rocket.png',
    'thankyou': '${Constants.awardsPath}/thankyou.png',
    'til': '${Constants.awardsPath}/til.png',
  };
}
