import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/routes/router.gr.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: FirebaseAuth.instance.currentUser?.displayName,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, snapshot) {
            final user = snapshot.data;
            final isAuthenticated = user != null;

            return Column(
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
                    if (!isAuthenticated)
                      Text('You\'re not signed in.',
                          style: Theme.of(context).textTheme.bodyLarge)
                    else
                      Text(
                          FirebaseAuth.instance.currentUser?.displayName ??
                              '(Profile Not Completed)',
                          style: Theme.of(context).textTheme.bodyLarge),
                    if (isAuthenticated)
                      IconButton(
                        onPressed: () {
                          // show edit profile dialog
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('Edit Profile'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          decoration: const InputDecoration(
                                            labelText: 'Display Name',
                                          ),
                                          controller: _nameController,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          FirebaseAuth.instance.currentUser
                                              ?.updateDisplayName(
                                                  _nameController.text)
                                              .then((_) {
                                            Navigator.of(context).pop();

                                            setState(() {});
                                          });
                                        },
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  ));
                        },
                        icon: const Icon(Icons.edit),
                      )
                  ],
                ),
                if (!isAuthenticated)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      softWrap: true,
                      'Sign in to save your favorites and participate in the community!',
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isAuthenticated)
                      ElevatedButton(
                        onPressed: () {
                          context.router.push(const SignInRoute());
                        },
                        child: const Text('Sign In'),
                      )
                    else
                      ElevatedButton(
                        onPressed: () {
                          // show dialog to confirm sign out
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('Sign Out'),
                                    content: const Text(
                                        'Are you sure you want to sign out?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          FirebaseAuth.instance.signOut();
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Sign Out'),
                                      ),
                                    ],
                                  ));
                        },
                        child: const Text('Sign Out'),
                      )
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
