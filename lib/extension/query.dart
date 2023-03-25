part of 'firebase_extension.dart';

typedef StoreQuery = Query<Store>;
typedef ItemQuery = Query<Item>;

final _geo = GeoFlutterFire();

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

  /// [Stream] of [QuerySnapshot] of the stores within the [radius] of [center].
  /// The [radius] is in meters.
  ///
  /// /// Warning: this makes you lose the type cast so you have to cast it manually.
  /// ```
  Stream<List<DocumentSnapshot<Object?>>> withinAsSingleStreamSubscription(
      GeoFirePoint center, double radius) {
    return _geo
        .collection(collectionRef: firestore.collection(ApiPath.stores))
        .withinAsSingleStreamSubscription(
            center: center, radius: radius, field: 'location');
  }
}

extension ItemQueryX on ItemQuery {
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
  Query<Item> addedByUser(String id) => where('added_by', isEqualTo: id);
}
