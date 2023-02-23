import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/menu/_menu.dart';
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
    test('User add a store', () async {
      // Suppose that this user wrote a form
      // (ownerId and addedBy are implied and not required by the form)

      final store = Store(
          name: 'Store Name',
          location: const GeoPoint(0, 0),
          address: 'test',
          email: 'store@example.com',
          phone: '08080808080',
          ownerId: auth.currentUser!.uid);

      // Add a store by this current user.
      final ref = await firestore.stores.add(store);
      final snapshot = await ref.get();
      final data = snapshot.data();

      expect(data == store, true);
    });

    test('User gets their owned stores', () async {
      // Suppose that this user wrote another
      // (ownerId is implied and not required by the form)
      final store2 = Store(
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
      expect(data[1] == store2, true);
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
      final item = Item(
        name: 'Item Name',
        price: const Price(
            amount: 100, currency: CurrencySymbol.jpy, compareAtPrice: 120),
        addedBy: auth.currentUser!.uid,
      );
      // Add a store by this current user.
      await firestore.stores.doc(storeDoc.id).items.add(item);

      final itemsSnapshot = await firestore.stores.doc(storeDoc.id).items.get();
      final itemsData = itemsSnapshot.docs.map((e) => e.data()).toList();

      expect(itemsData, [item]);
    });
  });
}
