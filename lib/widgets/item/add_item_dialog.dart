import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/image_upload/_image_upload.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/util/logger.dart';
import 'package:gdsctokyo/widgets/item/segmented_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:gdsctokyo/providers/image_upload.dart';
import 'dart:io';

enum ItemBucket { today, my, my2today }

enum FormField {
  name,
  normalPrice,
  discount,
  discountPercent,
  discountPrice,
  image,
}

extension
    on Map<String, FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>> {
  get name => this[FormField.name.name];
  get normalPrice => this[FormField.normalPrice.name];
  get discount => this[FormField.discount.name];
  get discountPercent => this[FormField.discountPercent.name];
  get discountPrice => this[FormField.discountPrice.name];
  get image => this[FormField.image.name];
}

final _stores = FirebaseFirestore.instance.stores;

class AddItemDialog extends StatefulWidget {
  final String storeId;
  final String? itemId;

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
  late final String itemId =
      widget.itemId == null || widget.bucket == ItemBucket.my2today
          ? _stores.doc().id
          : widget.itemId!;
  late final CollectionReference<Item> getCollection;
  late final CollectionReference<Item> addCollection;

  final _formKey = GlobalKey<FormBuilderState>();

  DiscountView currentDiscountView = DiscountView.byPrice;

  void _handleDiscountViewChanged(Set<DiscountView> newView) {
    setState(() {
      currentDiscountView = newView.first;
    });
  }

  DocumentSnapshot<Item>? _itemSnapshot;
  bool _isLoading = true;

  double? getDiscountedPrice(double? normalPrice, double? percent) {
    if (normalPrice == null || percent == null) {
      return null;
    }

    return normalPrice * (1 - percent / 100);
  }

  double? getPercentage(double? normalPrice, double? discountedPrice) {
    if (normalPrice == null || discountedPrice == null) {
      return null;
    }

    return (normalPrice - discountedPrice) / normalPrice * 100;
  }

  @override
  void initState() {
    super.initState();

    switch (widget.bucket) {
      case ItemBucket.today:
        getCollection = _stores.doc(widget.storeId).todaysItems;
        addCollection = _stores.doc(widget.storeId).todaysItems;
        break;
      case ItemBucket.my:
        getCollection = _stores.doc(widget.storeId).myItems;
        addCollection = _stores.doc(widget.storeId).myItems;
        break;
      case ItemBucket.my2today:
        getCollection = _stores.doc(widget.storeId).myItems;
        addCollection = _stores.doc(widget.storeId).todaysItems;
        break;
    }

    if (widget.itemId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    getCollection.doc(widget.itemId).get().then(
      (snapshot) {
        _itemSnapshot = snapshot;
        final item = snapshot.data();

        setState(
          () {
            _isLoading = false;
          },
        );
      },
    ).catchError((e) {
      setState(() {
        _isLoading = false;
      });
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
          widget.bucket == ItemBucket.today ||
                  widget.bucket == ItemBucket.my2today
              ? 'Add to today\'s menu'
              : 'Add to my menu',
          style:
              Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18),
        ),
      ),
      content: FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        autoFocusOnValidationFailure: true,
        onChanged: () => _formKey.currentState?.save(),
        child: Container(
          color: Theme.of(context).colorScheme.background,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
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
                      // debug container with border red full width height 2
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Menu name',
                            ),
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      FormBuilderTextField(
                        initialValue: _itemSnapshot?.data()?.name ?? '',
                        name: FormField.name.name,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        autofocus: true,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(12, 8, 12, 8),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant),
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.outline)),
                        ),
                        valueTransformer: (value) => value?.trim(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (widget.bucket != ItemBucket.my) ...[
                    SingleChoice(
                        onDiscountViewChanged: _handleDiscountViewChanged,
                        discountView: currentDiscountView),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      Flexible(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Normal price',
                                ),
                                if (widget.bucket == ItemBucket.my)
                                  const TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          FormBuilderTextField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              name: FormField.normalPrice.name,
                              initialValue: _itemSnapshot
                                      ?.data()
                                      ?.price
                                      ?.compareAtPrice
                                      ?.toString() ??
                                  '',
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(12, 8, 12, 8),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outlineVariant),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline)),
                              ),
                              validator: FormBuilderValidators.compose([
                                if (widget.bucket == ItemBucket.my)
                                  FormBuilderValidators.required(
                                      errorText: 'Required'),
                                FormBuilderValidators.numeric(
                                    errorText: 'Must be a number'),
                              ]),
                              valueTransformer: (value) =>
                                  double.tryParse(value ?? ''))
                        ],
                      )),
                      if (widget.bucket != ItemBucket.my) ...[
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            child: currentDiscountView == DiscountView.byPrice
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Discounted price',
                                            ),
                                            TextSpan(
                                              text: ' *',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      FormBuilderTextField(
                                        name: FormField.discountPrice.name,
                                        initialValue: _itemSnapshot
                                            ?.data()
                                            ?.price
                                            ?.amount
                                            ?.toString(),
                                        autofocus: true,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        keyboardType: TextInputType.number,
                                        validator:
                                            FormBuilderValidators.compose(
                                          [
                                            FormBuilderValidators.required(
                                                errorText: 'Required'),
                                            FormBuilderValidators.numeric(
                                                errorText: 'Must be a number'),
                                          ],
                                        ),
                                        valueTransformer: (value) =>
                                            double.tryParse(value ?? ''),
                                        onChanged: (_) {
                                          _formKey.currentState?.fields
                                              .discountPercent
                                              ?.didChange(getPercentage(
                                            _formKey.currentState?.fields
                                                .normalPrice?.value,
                                            _formKey.currentState?.fields
                                                .discountPrice?.value,
                                          ));
                                        },
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  12, 8, 12, 8),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outlineVariant),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .outline)),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      const Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Discounted percent',
                                            ),
                                            TextSpan(
                                              text: ' *',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      FormBuilderTextField(
                                        name: FormField.discountPercent.name,
                                        autofocus: true,
                                        keyboardType: TextInputType.number,
                                        valueTransformer: (value) =>
                                            double.tryParse(value ?? ''),
                                        validator:
                                            FormBuilderValidators.compose(
                                          [
                                            FormBuilderValidators.required(
                                                errorText: 'Required'),
                                            FormBuilderValidators.numeric(
                                                errorText: 'Must be a number'),
                                          ],
                                        ),
                                        onChanged: (_) {
                                          _formKey.currentState?.fields
                                              .discountPrice
                                              ?.didChange(getDiscountedPrice(
                                            _formKey.currentState?.fields
                                                .normalPrice?.value,
                                            _formKey.currentState?.fields
                                                .discountPercent?.value,
                                          ));
                                        },
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  12, 8, 12, 8),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outlineVariant),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .outline)),
                                        ),
                                      ),
                                    ],
                                  ))
                      ]
                    ],
                  ),
                  if (widget.bucket != ItemBucket.my) ...[
                    const SizedBox(height: 8),
                    if (currentDiscountView == DiscountView.byPercent)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Discounted Price = ${_formKey.currentState?.fields.discountPrice?.value}',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.outline),
                        ),
                      )
                    else
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Discounted Percent = ${_formKey.currentState?.fields.discountPrice?.value}',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.outline),
                        ),
                      ),
                  ],
                  const SizedBox(height: 8),
                  FormBuilderField(
                    name: FormField.image.name,
                    builder: (FormFieldState<File> field) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Upload photo',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith()),
                          const SizedBox(
                            height: 8,
                          ),
                          ItemPhoto(
                            serverPhotoURL: _itemSnapshot?.data()?.photoURL,
                            itemPhoto: field.value,
                            setFile: (file) => field.didChange(file),
                          ),
                        ]),
                  ),
                ],
              ],
            ),
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
                child: const Text('Cancel'),
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
                    : Text(widget.bucket == ItemBucket.my
                        ? 'Save to My Items'
                        : 'Add to Today\'s List'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String? name = _formKey.currentState?.value[FormField.name.name];
      final double? amount =
          _formKey.currentState?.value[FormField.discountPrice.name];
      final double? compareAtPrice =
          _formKey.currentState?.value[FormField.normalPrice.name];
      final File? image = _formKey.currentState?.value[FormField.image.name];
      final storeId = widget.storeId;

      final snackBar = SnackBar(
        content: widget.bucket == ItemBucket.my
            ? Text('$name was added to My Items')
            : Text('$name was added to Today\'s Items'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            await addCollection.doc(itemId).delete();
          },
        ),
      );

      if (_formKey.currentState!.saveAndValidate()) {
        final originalItem = _itemSnapshot?.data() ?? const Item();
        final item = originalItem.copyWith(
            name: name,
            price: Price(
                amount: amount,
                compareAtPrice: compareAtPrice,
                currency: Currency.jpy),
            addedBy: FirebaseAuth.instance.currentUser!.uid,
            updatedAt: null,
            photoURL: _itemSnapshot?.data()?.photoURL);

        await addCollection.doc(itemId).set(item);

        if (image != null) {
          final itemPhotoRef = FirebaseStorage.instance.ref().child(
              'stores/$storeId/todays_items/${_itemSnapshot?.id}/item_photo.jpg');
          await itemPhotoRef.putFile(image);
          final itemPhotoUrl = await itemPhotoRef.getDownloadURL();
          await addCollection.doc(itemId).updateItem(photoURL: itemPhotoUrl);
        }

        if (mounted) {
          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pop(context);
        }
      }
    } catch (e, stackTrace) {
      logger.e({
        FormField.name.name: _formKey.currentState?.fields.name?.value,
        FormField.normalPrice.name:
            _formKey.currentState?.fields.normalPrice?.value,
        FormField.discountPrice.name:
            _formKey.currentState?.fields.discountPrice?.value,
        FormField.discountPercent.name:
            _formKey.currentState?.fields.discountPercent?.value,
        FormField.image.name: _formKey.currentState?.fields.image?.value,
      }, e, stackTrace);
    } finally {
      setState(() {
        _isLoading = false;
      });
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
    return Stack(
      children: [
        Row(
          children: [
            Flexible(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).colorScheme.primaryContainer,
                height: 72,
                alignment: Alignment.center,
                child: const Text(
                  'Add a menu photo',
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              width: 72,
              height: 72,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: itemPhoto != null
                  ? Image.file(itemPhoto!)
                  : serverPhotoURL != null
                      ? Image.network(serverPhotoURL!)
                      : const SizedBox.shrink(),
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
    );
  }
}
