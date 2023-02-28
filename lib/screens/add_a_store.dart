import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
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
      body: Form(
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
            columnSizes: [200.px, auto],
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
            ],
          )),
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
    return DottedBorder(
      borderType: BorderType.RRect,
      child: SizedBox.expand(
        child: Stack(
          children: [
            if (coverPhoto != null)
              Image.file(
                coverPhoto!,
                fit: BoxFit.cover,
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
      ),
    );
  }
}
