part of '_store.dart';

@Freezed(
  unionKey: 'type',
)
class Store with _$Store {
  /// Use this to read data from Firestore
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
  const factory Store.create({
    required String name,
    @GeoPointConverter() required GeoPoint location,

    // Location is required, so address might not be needed
    String? address,
    String? email,
    String? phone,
    String? ownerId,
    @JsonKey(name: 'photoURL') String? photoURL,
    List<FoodCategory>? category,
  }) = StoreCreate;

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  static StoreData fromFirestore(
          DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      StoreData.fromJson(snapshot.data()!);
}

extension StoreX on Store {
  StoreData? asData() => mapOrNull(
        data: (data) => data,
      )!;

  Map<String, dynamic> toFirestore() => toJson()
    ..putIfAbsent('created_at', FieldValue.serverTimestamp)
    ..putIfAbsent('updated_at', FieldValue.serverTimestamp);
}

/// enums for food category
/// add more as needed
enum FoodCategory {
  @JsonValue('japanese')
  japanese,
}
