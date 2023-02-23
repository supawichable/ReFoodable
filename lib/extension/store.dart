part of 'firebase_extension.dart';

typedef StoreReference = DocumentReference<Store>;
typedef StoresReference = CollectionReference<Store>;

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
          toFirestore: (store, _) => store.toJson());
}

extension StoreReferenceX on StoreReference {
  /// Get a collection reference of items in a store document.
  ///
  /// Example (gets, get, add):
  /// ```dart
  /// final store = FirebaseFirestore.instance.store('store_id');
  /// final itemsRef = store.items;
  ///
  /// // get all items in the store
  /// final snapshots = await itemsRef.get();
  /// final items = snapshots.docs.map((e) => e.data()).toList();
  ///
  /// // get a specific item in the store
  /// final itemRef = items.doc('item_id');
  /// final snapshot = await itemRef.get();
  /// final item = snapshot.data();
  ///
  /// // add an item to the store
  /// final newItem = Item(name: 'new item',
  ///                      price: Price(
  ///                         amount: 100,
  ///                         currency: CurrencySymbol.jpy),
  ///                         addedBy: 'user_id');
  ///
  /// final newItemRef = await itemsRef.add(newItem);
  /// ```
  CollectionReference<Item> get items =>
      collection(ApiPath.items.name).withConverter(
          fromFirestore: (snapshot, _) => Item.fromFirestore(snapshot),
          toFirestore: (item, _) => item.toJson());
}
