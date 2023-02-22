import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/screens/home/my_page/my_stores.dart';
import 'package:gdsctokyo/screens/home/my_page/profile_card.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        const ProfileCard(),
        if (FirebaseAuth.instance.currentUser != null) const MyStoresCard()
      ]),
    );
  }
}
