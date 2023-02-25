import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:gdsctokyo/routes/router.gr.dart';
import 'package:gdsctokyo/util/logger.dart';

class MyStoresPage extends StatelessWidget {
  const MyStoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Stores'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // show dialog of adding store
          // form includes
          // name
          // location (latitude and longitude)
          // and it will automatically fill out
          // updatedAt and createdAt

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AddStoreDialogDebug();
              });
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot<Store>>(
        stream: FirebaseFirestore.instance.stores
            .ownedByUser(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
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
              itemCount: snapshot.docs.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 2,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                final store = snapshot.docs[index].data();
                return ListTile(
                  leading: const Icon(Icons.store),
                  key: ObjectKey(store),
                  title: Text(store.name),
                  subtitle: Text(store.address ?? ''),
                  onTap: () {
                    context.router.push(StoreRoute(store: store));
                  },
                );
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
    );
  }
}

class AddStoreDialogDebug extends StatefulWidget {
  const AddStoreDialogDebug({super.key});

  @override
  State<AddStoreDialogDebug> createState() => _AddStoreDialogDebugState();
}

class _AddStoreDialogDebugState extends State<AddStoreDialogDebug> {
  late final TextEditingController _nameController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Store'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Store Name',
              ),
              controller: _nameController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Latitude',
              ),
              controller: _latitudeController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Longitude',
              ),
              controller: _longitudeController,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // add store to firestore
            final store = Store(
              name: _nameController.text,
              location: GeoPoint(
                double.parse(_latitudeController.text),
                double.parse(_longitudeController.text),
              ),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              ownerId: FirebaseAuth.instance.currentUser!.uid,
            );
            FirebaseFirestore.instance.stores.add(store);

            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
