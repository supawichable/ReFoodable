import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:gdsctokyo/extension/user.dart';
import 'package:gdsctokyo/models/restaurant/_restaurant.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    FirebaseFirestore.instance.settings = const Settings(
      host: 'localhost:8080',
      sslEnabled: false,
      persistenceEnabled: false,
    );

    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  });

  final user = MockUser(
    isAnonymous: false,
    uid: 'test_uid',
    email: 'user1@example.com',
    displayName: 'User',
  );

  // Suppose that this user wrote a form
  const restaurant = Restaurant(
    name: 'Restaurant Name',
    location: GeoPoint(0, 0),
    address: 'test',
    email: 'restaurant@example.com',
    phone: '08080808080',
  );

  group('Add and get owned restaurants', () {
    test('User add a restaurant', () async {
      // Add a restaurant by this current user.
      final ref = await user.addRestaurant(restaurant);
      final snapshot = await ref.get();
      final data = snapshot.data();

      expect(data!.name, restaurant.name);
      expect(data.location.latitude, restaurant.location.latitude);
      expect(data.location.longitude, restaurant.location.longitude);
      expect(data.address, restaurant.address);
      expect(data.email, restaurant.email);
      expect(data.phone, restaurant.phone);
      expect(data.ownerId, user.uid);
    });
  });
}
