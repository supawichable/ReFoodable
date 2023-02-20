import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/routes/router.gr.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/restaurant/_restaurant.dart';
import '../screens/restaurant_my_page.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          final user = snapshot.data;

          if (user == null) {
            return const NotLoggedIn();
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

class LoggedIn extends StatefulWidget {
  const LoggedIn({super.key});

  @override
  State<LoggedIn> createState() => _LoggedInState();
}

class _LoggedInState extends State<LoggedIn> {
  final _restaurantRef = FirebaseFirestore.instance
      // choose collection
      .collection('restaurants')
      // snapshot.data() will not contain the id field so we implemented our own version
      .withConverter<Restaurant>(
        // ctrl + click on fromFirestore to see how it's implemented
        fromFirestore: (snapshot, _) => Restaurant.fromFirestore(snapshot),
        // might need toFirestore in the future
        toFirestore: (restaurant, _) => restaurant.toJson(),
      );

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      // sign in page button
      ElevatedButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RestaurantMyPage()));
        },
        child: const Text('Go to Restaurant'),
      ),
      ElevatedButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
        child: const Text('Sign Out'),
      ),

      // StreamBuilder with a snapshot of type QuerySnapshot<Restaurant>
      StreamBuilder<QuerySnapshot<Restaurant>>(
        stream: _restaurantRef
            // query
            .where('owner_id',
                isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            // get snapshot
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            // docs = list of documents
            final restaurants = snapshot.data!.docs;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: restaurants.length,
              itemBuilder: (BuildContext context, int index) {
                final restaurant = restaurants[index];
                return ListTile(title: Text(restaurant.data().name));
              },
            );
          } else {
            return const Text('No data');
          }
        },
      ),
    ]);
  }
}
