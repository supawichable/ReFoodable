import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/restaurant/_restaurant.dart';
import 'package:gdsctokyo/routes/router.gr.dart';

class MyStoresPage extends StatelessWidget {
  const MyStoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Stores'),
      ),
      body: FutureBuilder<QuerySnapshot<Restaurant>>(
        future: FirebaseFirestore.instance.restaurants
            .ownedByUser(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (BuildContext context, primarySnapshot) {
          if (primarySnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (primarySnapshot.hasData) {
            final snapshot = primarySnapshot.data;
            // if (snapshot!.docs.isEmpty) {
            //   return const Center(
            //     child: Text('Please add more stores!'),
            //   );
            // }
            return ListView.separated(
              itemCount: snapshot!.docs.length + 1,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 1,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                if (index == snapshot.docs.length) {
                  return ListTile(
                    title: const Text('Just go to the store!'),
                    onTap: () {
                      context.router.push(StoreRoute(
                          restaurant: Restaurant(
                              name: 'Restaurant', location: GeoPoint(0, 0))));
                    },
                  );
                }
                final restaurant = snapshot.docs[index + 1].data();
                return ListTile(
                  title: Text(restaurant.name),
                  subtitle: Text(restaurant.address ?? ''),
                  onTap: () {
                    context.router.push(StoreRoute(restaurant: restaurant));
                  },
                );
              },
            );
          }
          return const Center(
            child: Text('Something went wrong!'),
          );
        },
      ),
    );
  }
}
