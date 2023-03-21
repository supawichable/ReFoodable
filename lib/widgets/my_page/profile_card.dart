import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/models/image_upload/_image_upload.dart';
import 'package:gdsctokyo/providers/current_user.dart';
import 'package:gdsctokyo/providers/image_upload.dart';
import 'package:gdsctokyo/routes/router.gr.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';

const kplaceholderImage =
    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';

// Instead of `StatelessWidget` we use `HookConsumerWidget` to access `ref`
class ProfileCard extends HookConsumerWidget {
  const ProfileCard({super.key});

  // Include ref in the build method
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // CTRL + click on `currentUserProvider` to see the definition
    final user = ref.watch(currentUserProvider);

    return Card(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: user.when(
              data: (user) => ProfileData(user: user),
              error: (error, _) => Container(),
              loading: () => const CircularProgressIndicator())),
    );
  }
}

class ProfileData extends StatelessWidget {
  final User? user;
  const ProfileData({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (user == null)
              const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(kplaceholderImage),
              ),
            if (user != null) UploadableProfileImage(user!),
            const SizedBox(width: 16),
            if (user != null)
              Text(user?.displayName ?? '(Profile not completed)',
                  style: Theme.of(context).textTheme.bodyLarge)
            else
              Text('You\'re not signed in.',
                  style: Theme.of(context).textTheme.bodyLarge),
            if (user != null) DisplayNameEditor(user: user!)
          ],
        ),
        if (user == null)
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
            if (user == null)
              ElevatedButton(
                onPressed: () {
                  context.router.push(const SignInRoute());
                },
                child: const Text('Sign In'),
              )
            else
              // signout
              ElevatedButton(
                onPressed: () async {
                  // signout confirmation dialog
                  final shouldSignOut = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Sign Out'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Sign Out'),
                        ),
                      ],
                    ),
                  );

                  if (shouldSignOut == true) {
                    await FirebaseAuth.instance.signOut();
                  }
                },
                child: const Text('Sign Out'),
              ),
          ],
        )
      ],
    );
  }
}

class DisplayNameEditor extends StatefulWidget {
  final User user;

  const DisplayNameEditor({super.key, required this.user});

  @override
  State<DisplayNameEditor> createState() => _DisplayNameEditorState();
}

class _DisplayNameEditorState extends State<DisplayNameEditor> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.displayName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    // an IconButton that will pop up a dialog
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () async {
        final newName = await showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Edit Display Name'),
            content: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Display Name',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(_nameController.text),
                child: const Text('Save'),
              ),
            ],
          ),
        );

        if (newName != null) {
          await widget.user.updateDisplayName(newName).then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Display name updated')));
          });
        }
      },
    );
  }
}

class UploadableProfileImage extends HookConsumerWidget {
  final User user;

  const UploadableProfileImage(this.user, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        final imageUploadState = await ImageUploader(
          ref,
          options: const ImageUploadOptions(
            aspectRatio: CropAspectRatio(
              ratioX: 1,
              ratioY: 1,
            ),
          ),
        ).handleImageUpload();

        await imageUploadState.whenOrNull(error: (error) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error.message)));
        }, cropped: (croppedFile) async {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('users')
              .child(user.uid)
              .child('profile.jpg');

          await storageRef.putFile(File(croppedFile.path),
              SettableMetadata(contentType: 'image/jpeg'));
          final url = await storageRef.getDownloadURL();

          await user.updatePhotoURL(url).then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile image updated')));
          });
        });
      },
      child: CircleAvatar(
        radius: 30,
        backgroundImage: user.photoURL != null
            ? NetworkImage(user.photoURL!)
            : const NetworkImage(kplaceholderImage),
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
    );
  }
}

// class NotLoggedIn extends StatelessWidget {
//   const NotLoggedIn({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             const CircleAvatar(
//               radius: 30,
//               backgroundImage: NetworkImage(
//                   'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
//             ),
//             const SizedBox(width: 16),
//             Text('You\'re not signed in.',
//                 style: Theme.of(context).textTheme.bodyLarge)
//           ],
//         ),
//         const Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Text(
//             softWrap: true,
//             'Sign in to save your favorites and participate in the community!',
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 context.router.push(const SignInRoute());
//               },
//               child: const Text('Sign In'),
//             )
//           ],
//         )
//       ],
//     );
//   }
// }

// // Here is Stateful example
// // How to use ImageUploadProvider
// // 1. Use either `StatefulHookConsumerWidget` or `HookConsumerWidget`
// class LoggedIn extends StatefulHookConsumerWidget {
//   const LoggedIn({super.key});

//   @override
//   ConsumerState<LoggedIn> createState() => _LoggedInState();
// }

// class _LoggedInState extends ConsumerState<LoggedIn> {
//   late TextEditingController _nameController;
//   // CANNOT CALL `ref` IN THE INITIALIZER
//   // final user = ref.watch(currentUserProvider).value!; // WRONG

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(
//       text: FirebaseAuth.instance.currentUser?.displayName,
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // In Stateful, we can call the `ref` directly in any lifecycle
//     // But NOT IN THE INITIALIZER
//     final user = ref.watch(currentUserProvider);
//     // How to use ImageUploadProvider
//     // 2. Create a new instance of the provider with the context
//     final localProvider =
//         imageUploadProvider(ImageUploadOptions(context: context));

//     return Column(children: [
//       Row(
//         children: [
//           GestureDetector(
//             onTap: () async {
//               // How to use ImageUploadProvider
//               // 3. Call the `handleImagePickFlow` method and grab final state
//               // Optionally you can just `await`
//               // then use ref.read(localProvider).state
//               final imageUploadState =
//                   await ref.read(localProvider.notifier).handleImagePickFlow();

//               // 4. It returns `ImageUploadState` which has `croppedFile`
//               // (or not. you don't know. so check.)
//               if (imageUploadState.croppedFile != null) {
//                 // 5. Do whatever you want with the file
//                 // Typically File(imageUploadState.croppedFile!.path)
//                 // is your best friend.
//                 final ref = FirebaseStorage.instance
//                     .ref('users/${user.uid}/profile.jpg');
//                 final task = await ref.putFile(
//                     File(imageUploadState.croppedFile!.path),
//                     SettableMetadata(contentType: 'image/jpeg'));

//                 final url = await ref.getDownloadURL();
//                 await user.updatePhotoURL(url);
//               }
//             },
//             child: CircleAvatar(
//               radius: 30,
//               backgroundImage: NetworkImage(user.photoURL ??
//                   'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
//               child: const Align(
//                 alignment: Alignment.bottomRight,
//                 child: CircleAvatar(
//                   radius: 12,
//                   backgroundColor: Colors.white,
//                   child: Icon(
//                     Icons.upload,
//                     size: 16,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Text(
//               FirebaseAuth.instance.currentUser?.displayName ??
//                   '(Profile Not Completed)',
//               style: Theme.of(context).textTheme.bodyLarge),
//           IconButton(
//             onPressed: () {
//               // show edit profile dialog
//               showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                         title: const Text('Edit Profile'),
//                         content: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             TextFormField(
//                               controller: _nameController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Name',
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             Row(
//                               children: [
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: const Text('Cancel'),
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                     FirebaseAuth.instance.currentUser!
//                                         .updateDisplayName(
//                                             _nameController.text);
//                                   },
//                                   child: const Text('Save'),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ));
//             },
//             icon: const Icon(Icons.edit),
//           )
//         ],
//       ),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               // show dialog to confirm sign out
//               showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                         title: const Text('Sign Out'),
//                         content:
//                             const Text('Are you sure you want to sign out?'),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                             child: const Text('Cancel'),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               FirebaseAuth.instance.signOut();
//                               Navigator.of(context).pop();
//                             },
//                             child: const Text('Sign Out'),
//                           ),
//                         ],
//                       ));
//             },
//             child: const Text('Sign Out'),
//           )
//         ],
//       )
//     ]);
//   }
// }
