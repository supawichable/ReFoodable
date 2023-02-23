part of '_store.dart';

@Freezed(unionKey: 'type')
class Store with _$Store {
  const factory Store(
      {required String name,
      @GeoPointConverter() required GeoPoint location,

      // Location is required, so address might not be needed
      String? address,
      String? email,
      String? phone,
      String? ownerId,
      List<FoodCategory>? category}) = _Store;

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  factory Store.fromFirestore(
          DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      Store.fromJson(snapshot.data()!);
}

// enums for food category
// add more as needed
enum FoodCategory {
  @JsonValue('japanese')
  japanese,
}
