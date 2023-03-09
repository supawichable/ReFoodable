import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/public/_public.dart';

class FirebaseListener {
  late StreamSubscription<User?> _userPublicUpdateListener;

  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;

  /// Include the instance if in tests
  FirebaseListener.initializeListener({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) {
    _auth = auth ?? FirebaseAuth.instance;
    _firestore = firestore ?? FirebaseFirestore.instance;
    runUserPublicUpdate();
  }

  void dispose() {
    _userPublicUpdateListener.cancel();
  }

  /// on user changes, create or update a user_public document depending
  /// the user's changes.
  void runUserPublicUpdate() {
    // one-way sync from user to user_public
    _userPublicUpdateListener =
        _auth.userChanges().distinct((previous, current) {
      if (current == null) {
        return true;
      }
      if (previous == null) {
        return false;
      }
      bool isChanged = previous.displayName != current.displayName ||
          previous.photoURL != current.photoURL;

      return !isChanged;
    }).listen((user) async {
      if (user == null) {
        return;
      }
      await _firestore.usersPublic.doc(user.uid).set(UserPublic(
            displayName: user.displayName,
            photoURL: user.photoURL,
          ));
    });
  }
}
