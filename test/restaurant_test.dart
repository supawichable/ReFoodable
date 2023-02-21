import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/restaurant/_restaurant.dart';

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

  group('Add and get owned restaurants', () {
    test('User add a restaurant', () async {
      // Suppose that this user wrote a form
      // (ownerId is implied and not required by the form)
      final restaurant = Restaurant(
          name: 'Restaurant Name',
          location: const GeoPoint(0, 0),
          address: 'test',
          email: 'restaurant@example.com',
          phone: '08080808080',
          ownerId: currentUser.uid);
      // Add a restaurant by this current user.
      final ref = await firestore.restaurants.add(restaurant);
      final snapshot = await ref.get();
      final data = snapshot.data();

      expect(data == restaurant, true);
    });

    test('User gets their owned restaurants', () async {
      // Suppose that this user wrote another
      // (ownerId is implied and not required by the form)
      final restaurant2 = Restaurant(
          name: 'Restaurant Name 2',
          location: const GeoPoint(0, 0),
          address: 'test',
          email: 'restaurant@example.com',
          phone: '08080808080',
          ownerId: currentUser.uid);

      // Add both restaurants by this current user.
      await firestore.restaurants.add(restaurant2);

      // Get the restaurants owned by this user.
      final snapshots =
          await firestore.restaurants.ownedByUser(currentUser.uid).get();
      final data = snapshots.docs.map((e) => e.data()).toList();

      expect(data.length, 2);
      expect(data[1] == restaurant2, true);
    });
  });
}
