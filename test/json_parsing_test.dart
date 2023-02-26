import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/models/store/_store.dart';

void main() {
  group('store', () {
    final store = Store.data(
        name: 'Store 1',
        location: const GeoPoint(50.0, 128.0),
        createdAt: DateTime(2021, 1, 1),
        updatedAt: DateTime(2021, 1, 1),
        address: 'test',
        email: 'test@example.com',
        phone: '08080808080',
        ownerId: 'test',
        category: [FoodCategory.japanese]);

    final json = {
      'type': 'data',
      'name': 'Store 1',
      'location': const GeoPoint(50.0, 128.0),
      'created_at': Timestamp.fromDate(DateTime(2021, 1, 1)),
      'updated_at': Timestamp.fromDate(DateTime(2021, 1, 1)),
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
    final json = {
      'type': 'data',
      'name': 'Item 1',
      'price': {
        'amount': 100,
        'compare_at_price': 400,
        'currency': 'jpy',
      },
      'added_by': 'steve',
      'created_at': Timestamp.fromDate(DateTime(2021, 1, 1)),
      'updated_at': Timestamp.fromDate(DateTime(2021, 1, 1)),
    };

    final item = Item.data(
      name: 'Item 1',
      price: const Price(
        amount: 100,
        compareAtPrice: 400,
        currency: Currency.jpy,
      ),
      addedBy: 'steve',
      createdAt: DateTime(2021, 1, 1),
      updatedAt: DateTime(2021, 1, 1),
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
