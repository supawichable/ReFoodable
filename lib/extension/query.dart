part of 'firebase_extension.dart';

typedef StoreQuery = Query<Store>;

extension StoreQueryX on StoreQuery {
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
  Query<Store> ownedByUser(String id) => where('owner_id', isEqualTo: id);
}
