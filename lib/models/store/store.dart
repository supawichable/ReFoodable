part of '_store.dart';

@Freezed(
  unionKey: 'type',
)
class Store with _$Store {
  /// Use this to parse data from Firestore \
  /// **This is for internal use only.** \
  /// The only part you need is `asData()`
  const factory Store.data({
    required String name,
    @GeoPointConverter() required GeoPoint location,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,

    // Location is required, so address might not be needed
    String? address,
    String? email,
    String? phone,
    String? ownerId,
    @JsonKey(name: 'photoURL') String? photoURL,
    List<FoodCategory>? category,
  }) = StoreData;

  /// Use this to generate payload to Firestore when creating a new store
  ///
  /// Example:
  /// ```dart
  /// final store = Store.create(
  ///  name: 'My Store',
  ///  location: GeoPoint(0, 0),
  ///  address: 'My Address',
  ///  email: 'My Email',
  ///  phone: 'My Phone',
  ///  ownerId: 'My Owner ID',
  ///  photoURL: 'My Photo URL',
  ///  category: [FoodCategory.japanese],
  /// );
  ///
  /// final storeRef = FirebaseFirestore.instance.stores.add(store);
  const factory Store.create({
    required String name,
    @GeoPointConverter() required GeoPoint location,

    // Location is required, so address might not be needed
    String? address,
    String? email,
    String? phone,
    String? ownerId,
    String? photoURL,
    List<FoodCategory>? category,
  }) = StoreCreate;

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  static StoreData fromFirestore(
          DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      StoreData.fromJson(snapshot.data()!);
}

extension StoreX on Store {
  /// Convert [Store] to [StoreData] \
  /// This is to show `createdAt` and `updatedAt` \
  /// by making sure that you intend to read as data. \
  /// and not to create a new store.
  ///
  /// Example:
  /// ```dart
  /// final snapshot = await FirebaseFirestore.instance
  ///                    .stores.doc(storeId)
  ///                    .get();
  /// final store = snapshot.data()!.asData()!;
  /// ```
  @Deprecated('You can get createdAt and updatedAt from Store directly')
  StoreData? asData() => mapOrNull(
        data: (data) => data,
      )!;

  DateTime? get createdAt => mapOrNull(
        data: (data) => data.createdAt,
      );

  DateTime? get updatedAt => mapOrNull(
        data: (data) => data.updatedAt,
      );

  Map<String, dynamic> toFirestore() => toJson()
    ..remove('type')
    ..putIfAbsent('created_at', FieldValue.serverTimestamp)
    ..update('updated_at', (_) => FieldValue.serverTimestamp(),
        ifAbsent: FieldValue.serverTimestamp);
}

/// enums for food category
/// add more as needed
enum FoodCategory {
  @JsonValue('japanese')
  japanese,
}
