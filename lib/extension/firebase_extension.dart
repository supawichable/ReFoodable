import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:gdsctokyo/models/user/_user.dart';

part 'query.dart';
part 'store.dart';
part 'user.dart';

class ApiPath {
  static const stores = 'stores';
  static const users = 'users';
  static const myItems = 'my_items';
  static const todaysItems = 'todays_items';
  static const bookmarks = 'bookmarks';
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
      collection(ApiPath.stores).withConverter(
          fromFirestore: (snapshot, _) => Store.fromFirestore(snapshot),
          toFirestore: (store, _) => store.toFirestore());

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
  CollectionReference<UserPublic> get users =>
      collection(ApiPath.users).withConverter(
          fromFirestore: (snapshot, _) => UserPublic.fromFirestore(snapshot),
          toFirestore: (userPublic, _) => userPublic.toFirestore());
}
