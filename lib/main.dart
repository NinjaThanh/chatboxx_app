// ignore: unused_import
import 'dart:ui' show lerpDouble;
//import 'package:chatbox_app/page1/Onboarding_page.dart';
//import 'package:chatbox_app/Sign/Sign.dart';
//import 'package:chatbox_app/SignLogin/Login1_page.dart';
//import 'package:chatbox_app/Home/Home1_page.dart';
//import 'package:chatbox_app/SignLogin/login1_page.dart';
//import 'package:chatbox_app/home/home1_page.dart';
//import 'package:chatbox_app/mes/message_page.dart';
//import 'package:chatbox_app/mess2/message_page.dart';
//import 'package:chatbox_app/messteam/messteam_page.dart';
//import 'package:chatbox_app/create_poll/create_poll_page.dart';
//import 'package:chatbox_app/incoming_all/incoming_all_page.dart';
//import 'package:chatbox_app/create_group/create_group_page.dart';
//import 'package:chatbox_app/create_poll/create_poll_page.dart';
//import 'package:chatbox_app/user_profile/user_profile.dart';
//import 'package:chatboxx_app/call/test.dart';
//import 'package:chatboxx_app/call_video/call_video_page.dart';
//import 'package:chatboxx_app/call_video/test.dart';
import 'package:chatboxx_app/group_call/groupcall.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyWidget());
}

extension on double? Function(num? a, num? b, double t) {
  // ignore: unused_element
  bool get isAndroid => false;

  // ignore: unused_element
  bool get isIOS => false;
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Groupcall(),
    );
  }
}
