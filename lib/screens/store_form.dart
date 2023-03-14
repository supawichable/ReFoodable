import 'dart:io';
import 'dart:math';

import 'package:auto_route/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/image_upload/_image_upload.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:gdsctokyo/providers/image_upload.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';

class StoreFormPage extends StatefulWidget {
  final String? storeId;
  const StoreFormPage({super.key, @PathParam('storeId') this.storeId});

  @override
  State<StoreFormPage> createState() => _StoreFormPageState();
}

class _StoreFormPageState extends State<StoreFormPage> {
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
  Location? _location;
  late final TextEditingController _addressController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  File? _coverPhoto;
  List<FoodCategory> _categoryList = [];

  // if storeId is not null, then we are editing a store
  String? _targetStoreId;
  bool _isLoading = true;
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
      FirebaseFirestore.instance.stores.doc(storeId).get().then((value) {
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
            _isLoading = false;
            _targetStoreId = storeId;
          });
        }
      }).catchError((e) {});
    } else {
      setState(() {
        _isLoading = false;
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 148,
                      child: CoverPhoto(
                        serverPhotoURL: _serverPhotoURL,
                        coverPhoto: _coverPhoto,
                        setFile: _setFile,
                      ),
                    ),
                    const Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
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
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Name'),
                      const SizedBox(height: 12),
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
                      ),
                      const SizedBox(height: 12),
                      const Text('Location'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                // latitude and longitude to random number in valid range
                                final lat = Random().nextInt(180) - 90;
                                final lon = Random().nextInt(360) - 180;
                                _location = Location.fromGeoPoint(
                                    GeoPoint(lat.toDouble(), lon.toDouble()));
                              });
                            },
                            child: const Text('Set Location'),
                          ),
                          const SizedBox(width: 12),
                          Text(_location?.geoPoint != null
                              ? '${_location!.geoPoint!.latitude}, ${_location!.geoPoint!.longitude}'
                              : 'No location set'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('Address'),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Email'),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Phone'),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Category'),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<FoodCategory>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        value:
                            _categoryList.isEmpty ? null : _categoryList.first,
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
                      ),
                      const SizedBox(height: 12),
                      if (_isLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        )
                      else
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  _location != null) {
                                setState(() {
                                  _isLoading = true;
                                });

                                late final DocumentReference<Store> storeRef;
                                if (_targetStoreId == null) {
                                  final store = Store(
                                    name: _nameController.text,
                                    location: _location!,
                                    address: _addressController.text,
                                    email: _emailController.text,
                                    phone: _phoneController.text,
                                    category: _categoryList,
                                    ownerId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                  );
                                  storeRef = await FirebaseFirestore
                                      .instance.stores
                                      .add(store);

                                  _targetStoreId = storeRef.id;
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
                                  final coverPhotoRef = FirebaseStorage.instance
                                      .ref()
                                      .child(
                                          'stores/${storeRef.id}/cover_photo.jpg');
                                  await coverPhotoRef.putFile(_coverPhoto!);
                                  final coverPhotoUrl =
                                      await coverPhotoRef.getDownloadURL();
                                  await storeRef.updateStore(
                                      photoURL: coverPhotoUrl);
                                }

                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            )),
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
                      options: const ImageUploadOptions(
                        aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 1),
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
