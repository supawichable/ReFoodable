import 'package:flutter_test/flutter_test.dart';
import 'package:gdsctokyo/models/store/_store.dart';

void main() {
  group('store', () {
    test('Parse store', () async {
      final json = {
        "name": "Store 1",
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

      final store = Store.fromJson(json);
      expect(store.name, "Store 1");
      expect(store.location.latitude, 50.0);
      expect(store.location.longitude, 128.0);
      expect(store.address, "test");
      expect(store.email, "test@example.com");
      expect(store.phone, "08080808080");
      expect(store.ownerId, "test");
      expect(store.category, [FoodCategory.japanese]);
    });
  });
}
