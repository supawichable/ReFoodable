import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/models/private/_private.dart';
import 'package:gdsctokyo/models/public/_public.dart';
import 'package:gdsctokyo/models/store/_store.dart';

part 'query.dart';
part 'store.dart';
part 'user.dart';

enum ApiPath {
  stores,
  todays,
  myItems,
  usersPrivate,
  usersPublic;
}

/// For field rename ApiPath to snake_case on the name property
extension ApiPathExtension on ApiPath {
  String get name {
    switch (this) {
      case ApiPath.stores:
        return 'stores';
      case ApiPath.todays:
        return 'todays_items';
      case ApiPath.myItems:
        return 'my_items';
      case ApiPath.usersPrivate:
        return 'users_private';
      case ApiPath.usersPublic:
        return 'users_public';
    }
  }
}

extension FirestoreX on FirebaseFirestore {
  /// Get a reference to a stores collection
  /// which can be used to query the stores.
  ///
  /// Example:
  /// ```dart
  /// final storesRef = FirebaseFirestore.instance.stores;
  /// final snapshots = await storesRef.get();
  /// final stores = snapshots.docs.map((e) => e.data()).toList();
  /// ```
  CollectionReference<Store> get stores =>
      collection(ApiPath.stores.name).withConverter(
          fromFirestore: (snapshot, _) => Store.fromFirestore(snapshot),
          toFirestore: (store, _) => store.toFirestore());

  /// Get a reference to a users_private collection
  /// which can be used to query users' private information.
  /// This is only accessible by the user themselves.
  ///
  /// Only `get` method is allowed
  ///
  /// Example:
  /// ```dart
  /// final usersPrivateRef = FirebaseFirestore.instance.usersPrivate;
  /// final snapshots = await usersPrivateRef.get(); //❌ This is not allowed
  /// final currrentUser = FirebaseAuth.instance.currentUser!;
  /// final currentUserPrivateRef = usersPrivateRef.doc(currentUser.uid);
  /// final currentUserPrivateSnapshot = await currentUserPrivateRef.get();
  /// final currentUserPrivate = currentUserPrivateSnapshot.data();
  /// // ✅ Yes you can do this
  /// ```
  CollectionReference<UserPrivate> get usersPrivate =>
      collection(ApiPath.usersPrivate.name).withConverter(
          fromFirestore: (snapshot, _) => UserPrivate.fromFirestore(snapshot),
          toFirestore: (userPrivate, _) => userPrivate.toFirestore());

  /// Get a reference to a users_public collection
  /// which can be used to query users' public information.
  /// This is accessible by anyone.
  /// This is used to display user information in the app.
  ///
  /// Only `get` method is allowed
  ///
  /// Example:
  /// ```dart
  /// final usersPublicRef = FirebaseFirestore.instance.usersPublic;
  /// final snapshots = await usersPublicRef.get(); //❌ This is not allowed
  /// final item = Item(name: 'item name',
  ///                  price: Price(amount: 100, currency: CurrencySymbol.jpy),
  ///                 addedBy: 'user_id');
  /// final anyUserPublicRef = usersPublicRef.doc(item.addedBy.uid);
  /// final anyUserPublicSnapshot = await anyUserPublicRef.get();
  /// final anyUserPublic = anyUserPublicSnapshot.data();
  /// // ✅ Yes you can do this
  /// ```
  CollectionReference<UserPublic> get usersPublic =>
      collection(ApiPath.usersPublic.name).withConverter(
          fromFirestore: (snapshot, _) => UserPublic.fromFirestore(snapshot),
          toFirestore: (userPublic, _) => userPublic.toFirestore());
}
