part of '_restaurant.dart';

@freezed
class Restaurant with _$Restaurant {
  const factory Restaurant(
      {required String id,
      required String name,
      required Location location,
      required DateTime updatedAt,
      required DateTime createdAt,

      // Location is required, so address might not be needed
      String? address,
      String? email,
      String? phone,
      String? ownerId,
      List<FoodCategory>? category}) = _Restaurant;

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);
}

// enums for food category
// add more as needed
enum FoodCategory {
  @JsonValue('japanese')
  japanese,
}
