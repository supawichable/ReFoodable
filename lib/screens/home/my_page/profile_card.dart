import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/providers/current_user.dart';
import 'package:gdsctokyo/providers/image_upload.dart';
import 'package:gdsctokyo/routes/router.gr.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Instead of `StatelessWidget` we use `HookConsumerWidget` to access `ref`
class ProfileCard extends HookConsumerWidget {
  const ProfileCard({super.key});

  // Include ref in the build method
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // CTRL + click on `currentUserProvider` to see the definition
    final user = ref.watch(currentUserProvider).value;
    final isAuthenticated = user != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isAuthenticated ? const LoggedIn() : const NotLoggedIn(),
      ),
    );
  }
}

class NotLoggedIn extends StatelessWidget {
  const NotLoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
            ),
            const SizedBox(width: 16),
            Text('You\'re not signed in.',
                style: Theme.of(context).textTheme.bodyLarge)
          ],
        ),
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
            ElevatedButton(
              onPressed: () {
                context.router.push(const SignInRoute());
              },
              child: const Text('Sign In'),
            )
          ],
        )
      ],
    );
  }
}

// Here is Stateful example
// How to use ImageUploadProvider
// 1. Use either `StatefulHookConsumerWidget` or `HookConsumerWidget`
class LoggedIn extends StatefulHookConsumerWidget {
  const LoggedIn({super.key});

  @override
  ConsumerState<LoggedIn> createState() => _LoggedInState();
}

class _LoggedInState extends ConsumerState<LoggedIn> {
  late TextEditingController _nameController;
  // CANNOT CALL `ref` IN THE INITIALIZER
  // final user = ref.watch(currentUserProvider).value!; // WRONG

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
    // In Stateful, we can call the `ref` directly in any lifecycle
    // But NOT IN THE INITIALIZER
    final user = ref.watch(currentUserProvider).value!;

    // How to use ImageUploadProvider
    // 2. Create a new instance of the provider with the context
    final localProvider =
        imageUploadProvider(ImageUploadOptions(context: context));

    return Column(children: [
      Row(
        children: [
          GestureDetector(
            onTap: () async {
              // How to use ImageUploadProvider
              // 3. Call the `handleImagePickFlow` method and grab final state
              // Optionally you can just `await`
              // then use ref.read(localProvider).state
              final imageUploadState =
                  await ref.read(localProvider.notifier).handleImagePickFlow();

              // 4. It returns `ImageUploadState` which has `croppedFile`
              // (or not. you don't know. so check.)
              if (imageUploadState.croppedFile != null) {
                // 5. Do whatever you want with the file
                // Typically File(imageUploadState.croppedFile!.path)
                // is your best friend.
                final ref = FirebaseStorage.instance
                    .ref('users/${user.uid}/profile.jpg');
                final task = await ref.putFile(
                    File(imageUploadState.croppedFile!.path),
                    SettableMetadata(contentType: 'image/jpeg'));

                final url = await ref.getDownloadURL();
                await user.updatePhotoURL(url);
              }
            },
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.photoURL ??
                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
              child: const Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.upload,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
              FirebaseAuth.instance.currentUser?.displayName ??
                  '(Profile Not Completed)',
              style: Theme.of(context).textTheme.bodyLarge),
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
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    FirebaseAuth.instance.currentUser!
                                        .updateDisplayName(
                                            _nameController.text);
                                  },
                                  child: const Text('Save'),
                                ),
                              ],
                            )
                          ],
                        ),
                      ));
            },
            icon: const Icon(Icons.edit),
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // show dialog to confirm sign out
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Sign Out'),
                        content:
                            const Text('Are you sure you want to sign out?'),
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
    ]);
  }
}
