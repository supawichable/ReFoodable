import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/image_upload/_image_upload.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:gdsctokyo/providers/current_user.dart';
import 'package:gdsctokyo/providers/image_upload.dart';
import 'package:gdsctokyo/providers/store_in_view.dart';
import 'package:gdsctokyo/util/logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';

class StoreFormPage extends StatefulHookConsumerWidget {
  final String? storeId;
  const StoreFormPage({super.key, @PathParam('storeId') this.storeId});

  @override
  ConsumerState<StoreFormPage> createState() => _StoreFormPageState();
}

class _StoreFormPageState extends ConsumerState<StoreFormPage> {
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

  // if storeId is not null, then we are editing a store
  String? _targetStoreId;
  bool isLoading = true;
  String? _serverPhotoURL;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();

    final storeId = widget.storeId;
    if (storeId != null) {
      ref.read(storeInViewProvider(storeId).future).then((value) {
        final store = value.data();
        if (store != null) {
          _nameController.text = store.name ?? '';
          _addressController.text = store.address ?? '';
          _emailController.text = store.email ?? '';
          _phoneController.text = store.phone ?? '';
          _categoryList = store.category ?? [];
          _location = store.location;
          _serverPhotoURL = store.photoURL;
          setState(() {
            isLoading = false;
            _targetStoreId = storeId;
          });
        }
      }).catchError((e) {});
    } else {
      setState(() {
        isLoading = false;
      });
    }
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
          // height: MediaQuery.of(context).size.height,
          child: Form(
              key: _formKey,
              // child is a grid view of the fields
              // fields will consist of a label and a text field
              // except the cover photo on the top spanning the whole width
              // the location will be a button that will set the coordinates to
              // GeoPoint(0, 0) for now
              // and the category field which will be a dropdown menu
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 148,
                        child: CoverPhoto(
                          serverPhotoURL: _serverPhotoURL,
                          coverPhoto: _coverPhoto,
                          setFile: _setFile,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.upload,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: LayoutGrid(
                      rowGap: 12,
                      areas: '''
                  
                      name_label
                      name_field
                      location_label
                      location_field
                      address_label
                      address_field
                      email_label
                      email_field
                      phone_label
                      phone_field
                      category_label
                      category_field
                      submit_button
                      submit_button
                    ''',
                      columnSizes: [auto],
                      rowSizes: [
                        16.px,
                        56.px,
                        16.px,
                        56.px,
                        16.px,
                        56.px,
                        16.px,
                        56.px,
                        16.px,
                        56.px,
                        16.px,
                        56.px,
                        36.px,
                        56.px,
                      ],
                      children: [
                        const Text('Name').inGridArea('name_label'),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
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
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ).inGridArea('address_field'),
                        const Text('Email').inGridArea('email_label'),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ).inGridArea('email_field'),
                        const Text('Phone').inGridArea('phone_label'),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ).inGridArea('phone_field'),
                        const Text('Category').inGridArea('category_label'),
                        DropdownButtonFormField<FoodCategory>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          value: _categoryList.isEmpty
                              ? null
                              : _categoryList.first,
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
                        Center(
                          child: SizedBox(
                            width: 120,
                            height: 300,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate() &&
                                    _location != null) {
                                  late final DocumentReference<Store> storeRef;
                                  if (_targetStoreId == null) {
                                    final store = Store(
                                      name: _nameController.text,
                                      location: _location!,
                                      address: _addressController.text,
                                      email: _emailController.text,
                                      phone: _phoneController.text,
                                      category: _categoryList,
                                      ownerId: FirebaseAuth
                                          .instance.currentUser!.uid,
                                    );
                                    storeRef = await FirebaseFirestore
                                        .instance.stores
                                        .add(store);
                                  } else {
                                    storeRef = FirebaseFirestore.instance.stores
                                        .doc(_targetStoreId);
                                    await storeRef.updateStore(
                                      name: _nameController.text,
                                      location: _location!,
                                      address: _addressController.text,
                                      email: _emailController.text,
                                      phone: _phoneController.text,
                                      category: _categoryList,
                                    );
                                  }
                                  if (_coverPhoto != null) {
                                    final coverPhotoRef =
                                        FirebaseStorage.instance.ref().child(
                                            'stores/${storeRef.id}/cover_photo.jpg');
                                    await coverPhotoRef.putFile(_coverPhoto!);
                                    final coverPhotoUrl =
                                        await coverPhotoRef.getDownloadURL();
                                    await storeRef.updateStore(
                                        photoURL: coverPhotoUrl);
                                  }

                                  ref.invalidate(
                                      storeInViewProvider(_targetStoreId!));
                                  ref.invalidate(ownedStoresProvider);
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text('Submit'),
                            ).inGridArea('submit_button'),
                          ),
                        ),
                      ],
                    ),
                  ),
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
  final String? serverPhotoURL;

  const CoverPhoto({
    super.key,
    required this.coverPhoto,
    required this.setFile,
    this.serverPhotoURL,
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
            if (serverPhotoURL != null)
              Image.network(
                serverPhotoURL!,
                fit: BoxFit.cover,
              )
            else
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
