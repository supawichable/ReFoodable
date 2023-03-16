import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/image_upload/_image_upload.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:gdsctokyo/providers/image_upload.dart';
import 'dart:io';

enum ItemBucket {
  today,
  my,
}

final _stores = FirebaseFirestore.instance.stores;

class AddItemDialog extends StatefulWidget {
  final String storeId;
  final String? itemId;

  /// Changed to enum [ItemBucket]
  /// use either [ItemBucket.today] or [ItemBucket.my]
  final ItemBucket bucket;

  const AddItemDialog({
    super.key,
    this.itemId,
    required this.storeId,
    required this.bucket,
  });

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  late final String itemId = widget.itemId ?? _stores.doc().id;
  late final CollectionReference<Item> items = widget.bucket == ItemBucket.today
      ? _stores.doc(widget.storeId).todaysItems
      : _stores.doc(widget.storeId).myItems;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controllerMenuName =
      TextEditingController();
  late final TextEditingController _controllerNormalPrice =
      TextEditingController();
  late final TextEditingController _controllerDiscountedPrice =
      TextEditingController();

  DocumentSnapshot<Item>? _itemSnapshot;
  bool _isLoading = false;
  String? _serverPhotoURL;
  File? _itemPhoto;

  @override
  void initState() {
    super.initState();

    if (widget.itemId != null) {
      setState(() {
        _isLoading = true;
      });
      items.doc(widget.itemId).get().then(
        (snapshot) {
          if (snapshot.exists) {
            _itemSnapshot = snapshot;
            _controllerMenuName.text = snapshot.data()?.name ?? '';
            _controllerNormalPrice.text =
                snapshot.data()?.price?.compareAtPrice?.toString() ?? '';
            _controllerDiscountedPrice.text =
                snapshot.data()?.price?.amount.toString() ?? '';
          }
          setState(() {
            _isLoading = false;
          });
        },
      ).catchError((e) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _controllerMenuName.dispose();
    _controllerNormalPrice.dispose();
    _controllerDiscountedPrice.dispose();

    super.dispose();
  }

  void _setFile(File file) {
    setState(() {
      _itemPhoto = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      contentPadding: const EdgeInsets.all(0),
      titlePadding: const EdgeInsets.symmetric(vertical: 10),
      actionsPadding: const EdgeInsets.all(0),
      title: Container(
        alignment: Alignment.center,
        child: Text(
          widget.bucket == ItemBucket.today
              ? 'Add to today\'s menu'
              : 'Add to my menu',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      content: Form(
        key: _formKey,
        child: Container(
          width: 400,
          color: Theme.of(context).colorScheme.background,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Menu name',
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.outline),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintText: 'menu name',
                        ),
                        controller: _controllerMenuName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter menu name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Normal price',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith()),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            height: 40,
                            child: TextFormField(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outlineVariant),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  hintText: 'normal',
                                ),
                                controller: _controllerNormalPrice,
                                // check if is double
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter normal price';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter valid price';
                                  }
                                  return null;
                                }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Discounted price',
                              style: Theme.of(context).textTheme.labelLarge),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            height: 40,
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outlineVariant),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                hintText: 'discounted',
                              ),
                              controller: _controllerDiscountedPrice,
                              // check if is double
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter discounted price';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter valid price';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Menu name',
                      style:
                          Theme.of(context).textTheme.labelLarge?.copyWith()),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(children: [
                    Flexible(
                      flex: 4,
                      child: Container(
                        height: 50,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 50,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                  ]),
                ]),
              ],
            ],
          ),
        ),
      ),
      actions: [
        Container(
          padding: const EdgeInsets.only(right: 10),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('cancel'),
              ),
              TextButton(
                onPressed: _submit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('submit'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final name = _controllerMenuName.text;
    final compareAtPrice = double.parse(_controllerNormalPrice.text);
    final amount = double.parse(_controllerDiscountedPrice.text);

    if (_formKey.currentState!.validate()) {
      final originalItem = _itemSnapshot?.data() ?? const Item();
      final item = originalItem.copyWith(
          name: name,
          price: Price(
              amount: amount,
              compareAtPrice: compareAtPrice,
              currency: Currency.jpy),
          addedBy: FirebaseAuth.instance.currentUser!.uid,
          updatedAt: null);

      await items.doc(itemId).set(item);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}

class ItemPhoto extends HookConsumerWidget {
  final File? itemPhoto;
  final void Function(File) setFile;
  final String? serverPhotoURL;

  const ItemPhoto({
    super.key,
    required this.itemPhoto,
    required this.setFile,
    this.serverPhotoURL,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox.expand(
      child: Stack(
        children: [
          if (itemPhoto != null)
            Row(
              children: [
                Flexible(
                  flex: 4,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    height: 50,
                    alignment: Alignment.center,
                    child: const Text('Add a menu photo'),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 50,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Image.file(
                      itemPhoto!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          if (itemPhoto == null)
            if (serverPhotoURL != null)
              Row(
                children: [
                  Flexible(
                  flex: 4,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    height: 50,
                    alignment: Alignment.center,
                    child: const Text('Add a menu photo'),
                  ),
                ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 50,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Image.network(
                        serverPhotoURL!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Flexible(
                  flex: 4,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    height: 50,
                    alignment: Alignment.center,
                    child: const Text('Add a menu photo'),
                  ),
                ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 50,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ],
              ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  final imageUpload = await ImageUploader(ref,
                      options: const ImageUploadOptions(
                        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
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

class ItemPhoto extends HookConsumerWidget {
  final File? itemPhoto;
  final void Function(File) setFile;
  final String? serverPhotoURL;

  const ItemPhoto({
    super.key,
    required this.itemPhoto,
    required this.setFile,
    this.serverPhotoURL,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox.expand(
      child: Stack(
        children: [
          if (itemPhoto != null)
            Row(
              children: [
                Flexible(
                  flex: 4,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    height: 50,
                    alignment: Alignment.center,
                    child: const Text('Add a menu photo'),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 50,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Image.file(
                      itemPhoto!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          if (itemPhoto == null)
            if (serverPhotoURL != null)
              Row(
                children: [
                  Flexible(
                  flex: 4,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    height: 50,
                    alignment: Alignment.center,
                    child: const Text('Add a menu photo'),
                  ),
                ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 50,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Image.network(
                        serverPhotoURL!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Flexible(
                  flex: 4,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    height: 50,
                    alignment: Alignment.center,
                    child: const Text('Add a menu photo'),
                  ),
                ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 50,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ],
              ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  final imageUpload = await ImageUploader(ref,
                      options: const ImageUploadOptions(
                        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
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
