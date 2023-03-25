import 'dart:io';
import 'dart:math';

import 'package:auto_route/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/image_upload/_image_upload.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:gdsctokyo/providers/image_upload.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';

final _geo = GeoFlutterFire();

enum FormField { name, location, address, email, phone, coverPhoto, category }

extension
    on Map<String, FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>> {
  String? get name => this[FormField.name.name]?.value;

  GeoFirePoint? get location => this[FormField.location.name]?.value;

  String? get address => this[FormField.address.name]?.value;

  String? get email => this[FormField.email.name]?.value;

  String? get phone => this[FormField.phone.name]?.value;

  File? get coverPhoto => this[FormField.coverPhoto.name]?.value;

  List<FoodCategory> get category => this[FormField.category.name]?.value;
}

class StoreFormPage extends StatefulWidget {
  final String? storeId;
  const StoreFormPage({super.key, @PathParam('storeId') this.storeId});

  @override
  State<StoreFormPage> createState() => _StoreFormPageState();
}

class _StoreFormPageState extends State<StoreFormPage> {
  // controller
  final _formKey = GlobalKey<FormBuilderState>();

  // if storeId is not null, then we are editing a store
  DocumentSnapshot<Store>? _originalSnapshot;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    final storeId = widget.storeId;
    if (storeId != null) {
      FirebaseFirestore.instance.stores.doc(storeId).get().then((snapshot) {
        _originalSnapshot = snapshot;
        _formKey.currentState!.patchValue(
          {
            FormField.name.name: snapshot.data()?.name,
            FormField.location.name: snapshot.data()?.location,
            FormField.address.name: snapshot.data()?.address,
            FormField.email.name: snapshot.data()?.email,
            FormField.phone.name: snapshot.data()?.phone,
            FormField.category.name: snapshot.data()?.category,
          },
        );
        final store = snapshot.data();
        if (store != null) {
          setState(() {
            _isLoading = false;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Store'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: FormBuilder(
              key: _formKey,
              // child is a grid view of the fields
              // fields will consist of a label and a text field
              // except the cover photo on the top spanning the whole width
              // the location will be a button that will set the coordinates to
              // GeoPoint(0, 0) for now
              // and the category field which will be a dropdown menu
              child: Column(
                children: [
                  FormBuilderField(
                    name: FormField.coverPhoto.name,
                    autovalidateMode: AutovalidateMode.disabled,
                    builder: (FormFieldState<File> field) => Stack(
                      children: [
                        CoverPhoto(
                          serverPhotoURL: _originalSnapshot?.data()?.photoURL,
                          coverPhoto: field.value,
                          setFile: (file) {
                            field.didChange(file);
                          },
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text.rich(
                          TextSpan(
                            text: 'Store Name',
                            children: [
                              TextSpan(
                                text: ' *',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        FormBuilderTextField(
                          name: FormField.name.name,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          initialValue: _originalSnapshot?.data()?.name,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: 'Required'),
                            FormBuilderValidators.minLength(3,
                                errorText: 'Minimum 3 characters'),
                          ]),
                        ),
                        const SizedBox(height: 12),
                        FormBuilderField(
                          name: FormField.location.name,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          builder: (FormFieldState<GeoFirePoint> field) => Row(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  const centerLat = 35.67;
                                  const centerLon = 139.70;

                                  // around 15 km from this center
                                  final lat = centerLat +
                                      (Random().nextDouble() - 0.5) * 0.1;
                                  final lon = centerLon +
                                      (Random().nextDouble() - 0.5) * 0.1;

                                  // use only 4 significant digits
                                  final location = _geo.point(
                                      latitude:
                                          double.parse(lat.toStringAsFixed(4)),
                                      longitude:
                                          double.parse(lon.toStringAsFixed(4)));

                                  field.didChange(location);
                                },
                                child: const Text('Set Location'),
                              ),
                              const SizedBox(width: 12),
                              if (field.value != null)
                                Text(
                                    '${field.value!.latitude}, ${field.value!.longitude}'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text('Address'),
                        const SizedBox(height: 4),
                        FormBuilderTextField(
                          name: FormField.address.name,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text('Email'),
                        const SizedBox(height: 4),
                        FormBuilderTextField(
                          name: FormField.email.name,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.email(
                                errorText: 'Invalid Email Address'),
                          ]),
                        ),
                        const SizedBox(height: 12),
                        const Text('Phone'),
                        const SizedBox(height: 4),
                        FormBuilderTextField(
                          name: FormField.phone.name,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          // phone number validator
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.match(r'^\+?[0-9]+$',
                                errorText: 'Invalid Phone Number.')
                          ]),
                        ),
                        const SizedBox(height: 12),
                        FormBuilderField(
                          name: FormField.category.name,
                          builder: (FormFieldState<List<FoodCategory>> field) =>
                              Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Category'),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: FoodCategory.values
                                    .map((e) => ChoiceChip(
                                          avatar: field.value?.contains(e) ??
                                                  false
                                              ? null
                                              : CircleAvatar(
                                                  child: Icon(e.icon, size: 12),
                                                ),
                                          label: Text(e.name),
                                          selected:
                                              field.value?.contains(e) ?? false,
                                          onSelected: (selected) {
                                            final categoryList =
                                                field.value ?? <FoodCategory>[];
                                            if (selected) {
                                              categoryList.add(e);
                                            } else {
                                              categoryList.remove(e);
                                            }
                                            field.didChange(categoryList);
                                          },
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_isLoading)
                          const Center(
                            child: CircularProgressIndicator(),
                          )
                        else
                          Center(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.shopping_bag),
                              onPressed: _submit,
                              label: const Text('Create a store'),
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

  Future<void> _submit() async {
    if (_formKey.currentState!.saveAndValidate()) {
      setState(() {
        _isLoading = true;
      });

      final storeRef = _originalSnapshot?.reference ??
          FirebaseFirestore.instance.stores.doc();

      final fields = _formKey.currentState!.fields;

      final store = Store(
          name: fields.name,
          address: fields.address,
          email: fields.email,
          phone: fields.phone,
          location: fields.location,
          category: fields.category,
          photoURL: _originalSnapshot?.data()?.photoURL,
          ownerId: FirebaseAuth.instance.currentUser!.uid,
          createdAt: _originalSnapshot?.data()?.createdAt);

      try {
        await storeRef.set(store);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Error adding store')));
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (fields.coverPhoto != null) {
        final coverPhotoRef = FirebaseStorage.instance
            .ref()
            .child('stores/${storeRef.id}/cover_photo.jpg');
        await coverPhotoRef.putFile(fields.coverPhoto!);
        final coverPhotoUrl = await coverPhotoRef.getDownloadURL();
        await storeRef.updateStore(photoURL: coverPhotoUrl);
      }

      setState(() {
        _isLoading = false;
      });

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
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
    return SizedBox(
      height: MediaQuery.of(context).size.width / 3,
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
