import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/routes/router.gr.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: const [ProfileCard()]),
    );
  }
}

// Home
// - Scaffold
//  - My Page

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(FirebaseAuth
                          .instance.currentUser?.photoURL ??
                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                ),
                const SizedBox(width: 16),
                if (FirebaseAuth.instance.currentUser?.isAnonymous ?? true)
                  Text('You\'re not signed in.',
                      style: Theme.of(context).textTheme.bodyLarge)
                else
                  Text(
                      FirebaseAuth.instance.currentUser?.displayName ?? 'Guest',
                      style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            if (FirebaseAuth.instance.currentUser?.isAnonymous ?? true)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  softWrap: true,
                  'Sign in to save your favorites and participate in the community!',
                ),
              ),
            StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (BuildContext context, snapshot) {
                final user = snapshot.data;

                if (user?.isAnonymous ?? true) {
                  return ElevatedButton(
                    onPressed: () {
                      context.router.push(const SignInRoute());
                    },
                    child: const Text('Sign In'),
                  );
                } else {
                  return ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: const Text('Sign Out'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
