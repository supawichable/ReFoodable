part of 'firebase_extension.dart';

typedef StoreReference = DocumentReference<Store>;
typedef StoresReference = CollectionReference<Store>;

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
    final store = Store(
      name: name,
      location: location,
      address: address,
      category: category,
      email: email,
      phone: phone,
      photoURL: photoURL,
    );
    await update(store.toFirestore());
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
    final item = Item(
      name: name,
      price: price,
      photoURL: photoURL,
    );
    await update(item.toFirestore());
  }
}
