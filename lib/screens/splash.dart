import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/routes/router.gr.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      context.router.replace(const HomeRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('App Name', style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 20),
      if (FirebaseAuth.instance.currentUser == null)
        ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signInAnonymously().then((cred) {
                context.router.replace(const HomeRoute());
              }).onError((FirebaseAuthException error, stackTrace) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(error.message ?? 'Unknown Error'),
                ));
              });
            },
            // make this button bigger
            style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                textStyle: Theme.of(context).textTheme.headlineSmall),
            child: const Text('Get Started')),
    ])));
  }
}
