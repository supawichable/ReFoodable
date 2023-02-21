import 'package:flutter_test/flutter_test.dart';
import 'package:gdsctokyo/models/restaurant/_restaurant.dart';

void main() {
  group('restaurant', () {
    test('Parse restaurant', () async {
      final json = {
        "name": "Restaurant 1",
        "location": {
          "latitude": 50.0,
          "longitude": 128.0,
        },
        "updated_at": "2021-08-01T00:00:00.000Z",
        "created_at": "2021-08-01T00:00:00.000Z",
        "address": "test",
        "email": "test@example.com",
        "phone": "08080808080",
        "owner_id": "test",
        "category": ["japanese"],
      };

      final restaurant = Restaurant.fromJson(json);
      expect(restaurant.name, "Restaurant 1");
      expect(restaurant.location.latitude, 50.0);
      expect(restaurant.location.longitude, 128.0);
      expect(restaurant.address, "test");
      expect(restaurant.email, "test@example.com");
      expect(restaurant.phone, "08080808080");
      expect(restaurant.ownerId, "test");
      expect(restaurant.category, [FoodCategory.japanese]);
    });
  });
}
