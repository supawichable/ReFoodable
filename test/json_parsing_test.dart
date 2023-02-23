import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gdsctokyo/models/menu/_menu.dart';
import 'package:gdsctokyo/models/store/_store.dart';

void main() {
  group('store', () {
    const store = Store(
        name: 'Store 1',
        location: GeoPoint(50.0, 128.0),
        address: 'test',
        email: 'test@example.com',
        phone: '08080808080',
        ownerId: 'test',
        category: [FoodCategory.japanese]);

    const json = {
      'name': 'Store 1',
      'location': GeoPoint(50.0, 128.0),
      'address': 'test',
      'email': 'test@example.com',
      'phone': '08080808080',
      'owner_id': 'test',
      'category': ['japanese'],
    };

    test('Parse store', () async {
      final storeJ = Store.fromJson(json);
      expect(storeJ, store);
    });

    test('toJson store', () {
      final jsonS = store.toJson();
      expect(jsonS, json);
    });
  });

  group('item', () {
    const json = {
      'name': 'Item 1',
      'price': {
        'amount': 100,
        'compare_at_price': 400,
        'currency': 'jpy',
      },
      'added_by': 'steve',
    };

    const item = Item(
      name: 'Item 1',
      price: Price(
        amount: 100,
        compareAtPrice: 400,
        currency: CurrencySymbol.jpy,
      ),
      addedBy: 'steve',
    );

    test('parse item', () {
      final itemJ = Item.fromJson(json);
      expect(itemJ, item);
    });

    test('toJson item', () {
      final jsonI = item.toJson();
      expect(jsonI, json);
    });
  });
}
