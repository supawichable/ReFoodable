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
          toFirestore: (store, _) => store.toFirestore());
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
          toFirestore: (item, _) => item.toFirestore());

  /// Update the store document with the new data.
  /// This is to systematically update the store document.
  /// By allowing only certain fields to be updated,
  ///
  /// Example:
  /// ```dart
  /// final store = FirebaseFirestore.instance.store('store_id');
  /// await store.updateStore(name: 'new name');
  /// ```
  Future<void> updateStore({
    String? name,
    GeoPoint? location,
    String? address,
    List<FoodCategory>? category,
    String? email,
    String? phone,
    String? photoURL,
  }) async {
    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(this);
      final store = snapshot.data()!;
      transaction.update(this, {
        'name': name ?? store.name,
        'location': location ?? store.location,
        'address': address ?? store.address,
        'category': category ?? store.category,
        'email': email ?? store.email,
        'phone': phone ?? store.phone,
        'photoURL': photoURL ?? store.photoURL,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }
}

extension StoresReferenceX on StoresReference {
  @Deprecated('Use orignal add() instead')
  Future<StoreReference> addStore(StoreCreate store) async {
    final storeRef = await add(store);
    return storeRef;
  }
}

typedef ItemReference = DocumentReference<Item>;
typedef ItemsReference = CollectionReference<Item>;

extension ItemReferenceX on ItemReference {
  /// Update the item document with the new data.
  /// This is to systematically update the item document.
  /// By allowing only certain fields to be updated,
  ///
  /// Example:
  /// ```dart
  /// final item = FirebaseFirestore.instance.item('store_id', 'item_id');
  /// await item.updateItem(name: 'new name');
  /// ```
  Future<void> updateItem({
    String? name,
    Price? price,
    String? photoURL,
  }) async {
    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(this);
      final item = snapshot.data()!;
      transaction.update(this, {
        'name': name ?? item.name,
        'price': price ?? item.price,
        'photoURL': photoURL ?? item.photoURL,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }
}

extension ItemsReferenceX on ItemsReference {
  @Deprecated('Use orignal add() instead')
  Future<ItemReference> addItem(
    ItemCreate item,
  ) async {
    final itemRef = await add(item);
    return itemRef;
  }
}
