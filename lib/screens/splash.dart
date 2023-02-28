import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/providers/current_user.dart';
import 'package:gdsctokyo/routes/router.gr.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Splash Screen is for initiating the app
// Originally it was intended to be signInAnonymously-inator but the idea
// was scrapped because we don't want to store unauthenticated user data

class SplashPage extends StatefulHookConsumerWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _redirecting = false;

  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(seconds: 2), () {
    if (!_redirecting) {
      _redirecting = true;
      ref.read(currentUserProvider);
      context.router.replace(const HomeRoute());
    }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('App Name', style: Theme.of(context).textTheme.headlineLarge),
      // const SizedBox(height: 20),
      // if (FirebaseAuth.instance.currentUser == null)
      //   ElevatedButton(
      //       onPressed: () {
      //         FirebaseAuth.instance.signInAnonymously().then((cred) {
      //           context.router.replace(const HomeRoute());
      //         }).onError((FirebaseAuthException error, stackTrace) {
      //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //             content: Text(error.message ?? 'Unknown Error'),
      //           ));
      //         });
      //       },
      //       // make this button bigger
      //       style: ElevatedButton.styleFrom(
      //           padding:
      //               const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      //           textStyle: Theme.of(context).textTheme.headlineSmall),
      //       child: const Text('Get Started')),
    ])));
  }
}
