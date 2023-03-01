import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // the navigation is paused until resolver.next() is called with either
    // true to resume/continue navigation or false to abort navigation
    if (FirebaseAuth.instance.currentUser != null) {
      // if user is authenticated we continue
      resolver.next(true);
    } else {
      router.pop();
    }
  }
}

class StoreOwnerGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // this is for the path: */**/:storeId
    // 1. get the storeId from the path
    // 2. fetch it on the firestore to check the owner id
    // 3. compare it with the current user id
    // 4. if it's the same, continue
    final String? storeId = router.current.pathParams.get('storeId', null);
    if (storeId == null) {
      router.pop();
    }
    FirebaseFirestore.instance.stores.doc(storeId).get().then((snapshot) {
      if (snapshot.data()?.ownerId == FirebaseAuth.instance.currentUser?.uid) {
        resolver.next(true);
      } else {
        router.pop();
      }
    });
  }
}
