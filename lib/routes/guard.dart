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
