import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/store/_store.dart';

void main() {
  late final MockFirebaseAuth auth;
  late final FakeFirebaseFirestore firestore;
  late final MockUser currentUser;

  setUpAll(() {
    auth = MockFirebaseAuth();
    firestore = FakeFirebaseFirestore();
    currentUser = MockUser(
      isAnonymous: false,
      uid: 'test_uid',
      email: 'user1@example.com',
      displayName: 'User',
    );
  });

  group('Add and get owned stores', () {
    test('User add a store', () async {
      // Suppose that this user wrote a form
      // (ownerId is implied and not required by the form)
      final store = Store(
          name: 'Store Name',
          location: const GeoPoint(0, 0),
          address: 'test',
          email: 'store@example.com',
          phone: '08080808080',
          ownerId: currentUser.uid);
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
          ownerId: currentUser.uid);

      // Add both stores by this current user.
      await firestore.stores.add(store2);

      // Get the stores owned by this user.
      final snapshots =
          await firestore.stores.ownedByUser(currentUser.uid).get();
      final data = snapshots.docs.map((e) => e.data()).toList();

      expect(data.length, 2);
      expect(data[1] == store2, true);
    });
  });
}
