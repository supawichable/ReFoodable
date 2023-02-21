part of '_restaurant.dart';

@freezed
class Restaurant with _$Restaurant {
  const factory Restaurant(
      {required String id,
      required String name,
      @GeoPointConverter() required GeoPoint location,
      @TimestampConverter() required DateTime updatedAt,
      @TimestampConverter() required DateTime createdAt,

      // Location is required, so address might not be needed
      String? address,
      String? email,
      String? phone,
      String? ownerId,
      String? addedBy,
      List<FoodCategory>? category}) = _Restaurant;

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  factory Restaurant.fromFirestore(
          DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      Restaurant.fromJson({"id": snapshot.id, ...snapshot.data()!});

  static Map<String, dynamic> toFirestore(Restaurant data) =>
      data.toJson().remove('id');
}

// enums for food category
// add more as needed
enum FoodCategory {
  @JsonValue('japanese')
  japanese,
}
