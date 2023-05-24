import 'package:auto_route/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/widgets/my_page/my_stores.dart';
import 'package:gdsctokyo/widgets/my_page/profile_card.dart';

@RoutePage()
class MypagePage extends StatelessWidget {
  const MypagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          return Column(children: [
            const ProfileCard(),
            if (FirebaseAuth.instance.currentUser != null) const MyStoresCard()
          ]);
        },
      ),
    );
  }
}
