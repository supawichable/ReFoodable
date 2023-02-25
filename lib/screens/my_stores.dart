import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:gdsctokyo/routes/router.gr.dart';

class MyStoresPage extends StatelessWidget {
  const MyStoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Stores'),
      ),
      body: FutureBuilder<QuerySnapshot<Store>>(
        future: FirebaseFirestore.instance.stores
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
                  height: 2,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                if (index == snapshot.docs.length) {
                  return ListTile(
                    title: const Text('Just go to the store!'),
                    onTap: () {
                      context.router.push(StoreRoute(
                          store: Store(
                              name: 'Store',
                              location: const GeoPoint(0, 0),
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now())));
                    },
                  );
                }
                final store = snapshot.docs[index + 1].data();
                return ListTile(
                  title: Text(store.name),
                  subtitle: Text(store.address ?? ''),
                  onTap: () {
                    context.router.push(StoreRoute(store: store));
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
