import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/routes/router.gr.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/restaurant/_restaurant.dart';

class MyPage extends StatelessWidget {
  MyPage({super.key});
  final restaurantRef = FirebaseFirestore.instance
      .collection('restaurants')
      .withConverter<Restaurant>(
        fromFirestore: (snapshots, _) => Restaurant.fromJson(snapshots.data()!),
        toFirestore: (restaurant, _) => restaurant.toJson(),
      );

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          final user = snapshot.data;

          if (user == null) {
            return NotLoggedIn();
          } else {
            return const LoggedIn();
          }
        },
      ),

      // menu
    ]);
  }
}

// Home
// - Scaffold
//  - My Page

class NotLoggedIn extends StatelessWidget {
  const NotLoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // sign in page button
      ElevatedButton(
        onPressed: () {
          context.router.push(const SignInRoute());
        },
        child: const Text('Sign In'),
      ),
    ]);
  }
}

class LoggedIn extends StatelessWidget {
  const LoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // sign in page button
      ElevatedButton(
        onPressed: () {},
        child: const Text('Query Restaurant'),
      ),
      ElevatedButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
        child: const Text('Sign Out'),
      ),
    ]);
  }
}
