import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/image_upload/_image_upload.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:gdsctokyo/providers/image_upload.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';

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
  File? _coverPhoto;
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

  void _setFile(File file) {
    setState(() {
      _coverPhoto = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Store'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Form(
              key: _formKey,
              // child is a grid view of the fields
              // fields will consist of a label and a text field
              // except the cover photo on the top spanning the whole width
              // the location will be a button that will set the coordinates to
              // GeoPoint(0, 0) for now
              // and the category field which will be a dropdown menu
              child: LayoutGrid(
                areas: '''
                photo             photo
                name_label        name_field
                location_label    location_field
                address_label     address_field
                email_label       email_field
                phone_label       phone_field
                category_label    category_field
                submit_button     submit_button
              ''',
                columnSizes: [100.px, auto],
                rowSizes: [
                  300.px,
                  1.fr,
                  1.fr,
                  1.fr,
                  1.fr,
                  1.fr,
                  1.fr,
                  1.fr,
                ],
                children: [
                  CoverPhoto(
                    coverPhoto: _coverPhoto,
                    setFile: _setFile,
                  ).inGridArea('photo'),
                  const Text('Name').inGridArea('name_label'),
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ).inGridArea('name_field'),
                  const Text('Location').inGridArea('location_label'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _location = const GeoPoint(0, 0);
                      });
                    },
                    child: const Text('Set Location'),
                  ).inGridArea('location_field'),
                  const Text('Address').inGridArea('address_label'),
                  TextFormField(
                    controller: _addressController,
                  ).inGridArea('address_field'),
                  const Text('Email').inGridArea('email_label'),
                  TextFormField(
                    controller: _emailController,
                  ).inGridArea('email_field'),
                  const Text('Phone').inGridArea('phone_label'),
                  TextFormField(
                    controller: _phoneController,
                  ).inGridArea('phone_field'),
                  const Text('Category').inGridArea('category_label'),
                  DropdownButton<FoodCategory>(
                    value: _categoryList.isEmpty ? null : _categoryList.first,
                    items: FoodCategory.values
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _categoryList = [value!];
                      });
                    },
                  ).inGridArea('category_field'),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          _location != null) {
                        final store = Store(
                          name: _nameController.text,
                          location: _location!,
                          address: _addressController.text,
                          email: _emailController.text,
                          phone: _phoneController.text,
                          category: _categoryList,
                          ownerId: FirebaseAuth.instance.currentUser!.uid,
                        );
                        final storeRef =
                            await FirebaseFirestore.instance.stores.add(store);
                        if (_coverPhoto != null) {
                          final coverPhotoRef = FirebaseStorage.instance
                              .ref()
                              .child('stores/${storeRef.id}/cover_photo.jpg');
                          await coverPhotoRef.putFile(_coverPhoto!);
                          final coverPhotoUrl =
                              await coverPhotoRef.getDownloadURL();
                          await storeRef.updateStore(photoURL: coverPhotoUrl);
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Submit'),
                  ).inGridArea('submit_button'),
                ],
              )),
        ),
      ),
    );
  }
}

// cover photo
class CoverPhoto extends HookConsumerWidget {
  final File? coverPhoto;
  final void Function(File) setFile;
  const CoverPhoto({
    super.key,
    required this.coverPhoto,
    required this.setFile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox.expand(
      child: Stack(
        children: [
          if (coverPhoto != null)
            Image.file(
              coverPhoto!,
              fit: BoxFit.cover,
            ),
          if (coverPhoto == null)
            Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: const Center(
                child: Text('Add a cover photo'),
              ),
            ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  final imageUpload = await ImageUploader(ref,
                      options: ImageUploadOptions(
                        aspectRatioPresets: [CropAspectRatioPreset.ratio3x2],
                      )).handleImageUpload();
                  imageUpload.whenOrNull(
                      cropped: (file) => setFile(File(file.path)),
                      error: (error) =>
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(error.message),
                          )));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}