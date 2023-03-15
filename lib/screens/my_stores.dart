import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:gdsctokyo/routes/router.gr.dart';
import 'package:gdsctokyo/util/logger.dart';
import 'package:gdsctokyo/widgets/store_card.dart';

class MyStoresPage extends StatefulWidget {
  const MyStoresPage({super.key});

  @override
  State<MyStoresPage> createState() => _MyStoresPageState();
}

class _MyStoresPageState extends State<MyStoresPage> {
  late Stream<QuerySnapshot<Store>> _storesStream;

  @override
  void initState() {
    super.initState();
    _storesStream = FirebaseFirestore.instance.stores
        .ownedByUser(
          FirebaseAuth.instance.currentUser!.uid,
        )
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Stores'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.router.push(StoreFormRoute());
        },
        child: const Icon(Icons.add),
      ),
      body: SizedBox(
        width: double.infinity,
        // screen height - app bar height
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<QuerySnapshot<Store>>(
          stream: _storesStream,
          builder: (BuildContext context, primarySnapshot) {
            if (primarySnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (primarySnapshot.hasData) {
              final snapshot = primarySnapshot.data;
              if (snapshot!.docs.isEmpty) {
                return const Center(
                  child: Text('Please add more stores!'),
                );
              }
              return ListView.separated(
                itemCount: snapshot.docs.length + 1,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  if (index == snapshot.docs.length) {
                    return const SizedBox(
                      height: 80,
                    );
                  }
                  return StoreCard(
                      snapshot.docs[index].id, snapshot.docs[index].data());
                },
              );
            }
            if (primarySnapshot.hasError) {
              return const Center(
                child: Text('Something went wrong!'),
              );
            }
            return const Center(
              child: Text('Something went wronger!'),
            );
          },
        ),
      ),
    );
  }
}
