part of 'firebase_extension.dart';

typedef StoreQuery = Query<Store>;
typedef ItemQuery = Query<Item>;

extension StoreQueryX on StoreQuery {
  /// [Query] object for the stores with null-safety.
  /// Must be used to query stores with necessary fields.
  /// Necessary fields are:
  /// - name
  /// - location
  Query<Store> get safe =>
      where('name', isNull: false).where('location', isNull: false);

  /// [Query] object for the stores owned by the user with [id].
  ///
  /// Example:
  /// ```dart
  /// final user = FirebaseAuth.instance.currentUser;
  /// final snapshots = await FirebaseFirestore.instance
  ///                   .stores
  ///                   .ownedByUser(user.uid)
  ///                   .get();
  /// ```
  Query<Store> ownedByUser(String id) => safe.where('owner_id', isEqualTo: id);
}

extension ItemQueryX on ItemQuery {
  /// [Query] object for the items with null-safety.
  /// Must be used to query items with necessary fields.
  /// Necessary fields are:
  /// - name
  /// - price
  /// - added_by
  Query<Item> get safe => where('name', isNull: false)
      .where('price', isNull: false)
      .where('added_by', isNull: false);

  /// [Query] object for the items added by the user with [id].
  /// (It is not often used, but it is useful for debugging.)
  ///
  /// Example:
  /// ```dart
  /// final user = FirebaseAuth.instance.currentUser;
  /// final snapshots = await FirebaseFirestore.instance
  ///                  .items
  ///                  .addedByUser(user.uid)
  ///                  .get();
  /// ```
  Query<Item> addedByUser(String id) => safe.where('added_by', isEqualTo: id);
}
