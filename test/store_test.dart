import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/models/store/_store.dart';

void main() {
  final auth = MockFirebaseAuth();
  final firestore = FakeFirebaseFirestore();

  final user = MockUser(
    isAnonymous: false,
    uid: 'test_uid',
    email: 'user1@example.com',
    displayName: 'User',
  );

  setUpAll(() async {
    // should work
    await auth.createUserWithEmailAndPassword(
        email: user.email!, password: 'p@ssw0rd');
    await auth.currentUser!.updateDisplayName(user.displayName!);
  });

  group('Add and get owned stores', () {
    // Suppose that this user wrote a form
    // (ownerId is implied and not required by the form)
    test('User add a store', () async {
      final store = Store.create(
          name: 'Store Name',
          location: const GeoPoint(0, 0),
          address: 'test',
          email: 'store@example.com',
          phone: '08080808080',
          ownerId: auth.currentUser!.uid);

      // Add a store by this current user.
      final ref = await firestore.stores.add(store);
      final snapshot = await ref.get();
      final data = snapshot.data()!;

      expect(data.name, store.name);
      expect(data.location, store.location);
      expect(data.address, store.address);
      expect(data.email, store.email);
      expect(data.phone, store.phone);
      expect(data.ownerId, store.ownerId);
      expect(data.createdAt, isA<DateTime>());
      expect(data.updatedAt, isA<DateTime>());
    });

    test('User gets their owned stores', () async {
      // Suppose that this user wrote another
      // (ownerId is implied and not required by the form)
      final store2 = Store.create(
          name: 'Store Name 2',
          location: const GeoPoint(0, 0),
          address: 'test',
          email: 'store@example.com',
          phone: '08080808080',
          ownerId: auth.currentUser!.uid);

      // Add both stores by this current user.
      await firestore.stores.add(store2);

      // Get the stores owned by this user.
      final snapshots =
          await firestore.stores.ownedByUser(auth.currentUser!.uid).get();
      final data = snapshots.docs.map((e) => e.data()).toList();

      expect(data.length, 2);
      expect(data[1].name, store2.name);
      expect(data[1].location, store2.location);
      expect(data[1].address, store2.address);
      expect(data[1].email, store2.email);
      expect(data[1].phone, store2.phone);
      expect(data[1].ownerId, store2.ownerId);
      expect(data[1].createdAt, isA<DateTime>());
      expect(data[1].updatedAt, isA<DateTime>());
    });
  });

  group('Add and get items', () {
    late QueryDocumentSnapshot<Store> storeDoc;

    // Suppose that this user wrote a form
    // (addedBy are implied and not required by the form)

    setUpAll(() async {
      // get a store owned by this user
      final snapshot =
          await firestore.stores.ownedByUser(auth.currentUser!.uid).get();
      storeDoc = snapshot.docs.first;
    });

    test('API gives valid path', () async {
      expect(
        firestore.stores.path,
        'stores',
      );
      expect(firestore.stores.doc(storeDoc.id).path, 'stores/${storeDoc.id}');
      expect(firestore.stores.doc(storeDoc.id).items.path,
          'stores/${storeDoc.id}/items');
      expect(firestore.stores.doc(storeDoc.id).items.doc('egg').path,
          'stores/${storeDoc.id}/items/egg');
    });

    test('Get a store owned by this user', () async {
      final snapshot =
          await firestore.stores.ownedByUser(auth.currentUser!.uid).get();
      storeDoc = snapshot.docs.first;
    });

    test('User add an item', () async {
      final item = Item.create(
        name: 'Item Name',
        price: const Price(
            amount: 100, currency: Currency.jpy, compareAtPrice: 120),
        addedBy: auth.currentUser!.uid,
      );
      // Add a store by this current user.
      await firestore.stores.doc(storeDoc.id).items.add(item);

      final itemsSnapshot = await firestore.stores.doc(storeDoc.id).items.get();
      final itemData = itemsSnapshot.docs.map((e) => e.data()).toList().first;

      expect(itemData.name, item.name);
      expect(itemData.price.amount, item.price.amount);
      expect(itemData.price.currency, item.price.currency);
      expect(itemData.price.compareAtPrice, item.price.compareAtPrice);
      expect(itemData.addedBy, item.addedBy);
      expect(itemData.createdAt, isA<DateTime>());
      expect(itemData.updatedAt, isA<DateTime>());
    });
  });
}
