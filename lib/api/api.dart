import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdsctokyo/models/restaurant/_restaurant.dart';

part 'me.dart';
part 'restaurant.dart';

class FirebaseApi {
  final _me = Me();
  final _restaurants = Restaurants();

  FirebaseApi();

  Me get me => _me;
  Restaurants get restaurants => _restaurants;
}
