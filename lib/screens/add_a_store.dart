import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/models/store/_store.dart';

class AddAStorePage extends StatefulWidget {
  const AddAStorePage({super.key});

  @override
  State<AddAStorePage> createState() => _AddAStorePageState();
}

class _AddAStorePageState extends State<AddAStorePage> {
  // To add a store, we need these fields:
  // - photo (optional)
  // - name (required)
  // - location (will use a map to get the coordinates, but the map is not
  //   ready, so this will be a placeholder button that will just set
  //   the coordinates to GeoPoint(0, 0) for now)
  // - address (optional)
  // - phone number (optional)
  // - email (optional)
  // - category (optional) will be a dropdown menu with a list of categories
  //   from FoodCategory enum
  // - owner (will be set to Firebase.auth.currentUser!.uid)

  // controller
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  GeoPoint? _location;
  late final TextEditingController _addressController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  String? _photoURL;
  List<FoodCategory> _categoryList = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Store'),
      ),
      body: Column(
        children: [
          // a rectangular area to display the photo
          // if photoURL is null, display a dotted border with
          // "Upload a cover photo" text and an upload icon in the middle
          // if photoURL is not null, display the photoURL
          Container(
            height: 200,
            width: double.infinity,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: _photoURL == null
                ? const Center(
                    child: Text('Upload a cover photo'),
                  )
                : Image.network(_photoURL!),
          ),
          // form
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Store Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  // location
                  ElevatedButton.icon(
                      onPressed: () {
                        _location = const GeoPoint(0, 0);
                      },
                      icon: const Icon(Icons.location_on),
                      label: const Text('Set Location')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
