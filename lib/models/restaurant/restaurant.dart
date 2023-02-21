part of '_restaurant.dart';

@Freezed(unionKey: 'type')
class Restaurant with _$Restaurant {
  const factory Restaurant(
      {required String name,
      @GeoPointConverter() required GeoPoint location,

      // Location is required, so address might not be needed
      String? address,
      String? email,
      String? phone,
      String? ownerId,
      List<FoodCategory>? category}) = _Restaurant;

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  factory Restaurant.fromFirestore(
          DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      Restaurant.fromJson({...snapshot.data()!});
}

// enums for food category
// add more as needed
enum FoodCategory {
  @JsonValue('japanese')
  japanese,
}
