import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gdsctokyo/providers/image_upload.dart';
import 'package:gdsctokyo/routes/router.gr.dart';
import 'package:gdsctokyo/widgets/common/or_bar.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';

enum AuthMode { login, register }

extension on AuthMode {
  String get label => this == AuthMode.login ? 'Sign In' : 'Sign Up';
}

// util for creating random string
String randomString(int length) {
  const chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567169';
  final random = Random.secure();
  return List.generate(length, (index) => chars[random.nextInt(chars.length)])
      .join();
}

class SignInPage extends StatefulHookConsumerWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormBuilderState>();

  AuthMode mode = AuthMode.login;

  String placeholderUrlbase = 'https://api.dicebear.com/5.x/thumbs/png?seed=';
  String seed = randomString(10);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(mode.label),
            elevation: 2,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: FormBuilder(
                    key: _formKey,
                    onChanged: () {
                      _formKey.currentState!.save();
                    },
                    autovalidateMode: AutovalidateMode.disabled,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (mode == AuthMode.register) ...[
                            FormBuilderField(
                                name: 'profileImage',
                                builder: (FormFieldState<File> state) {
                                  return Column(
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            seed = randomString(10);
                                          });
                                        },
                                        icon: const Icon(Icons.refresh),
                                        label: const Text('Refresh'),
                                      ),
                                      const SizedBox(height: 16),
                                      GestureDetector(
                                        onTap: () async {
                                          final pickedFile =
                                              await ImageUploader(
                                            ref,
                                            options: const ImageUploadOptions(
                                              aspectRatio: CropAspectRatio(
                                                ratioX: 1,
                                                ratioY: 1,
                                              ),
                                            ),
                                          ).handleImageUpload();

                                          pickedFile.whenOrNull(
                                            cropped: (file) {
                                              state.didChange(File(file.path));
                                            },
                                          );
                                        },
                                        child: CircleAvatar(
                                          radius: 48,
                                          backgroundImage: NetworkImage(
                                              '$placeholderUrlbase$seed'),
                                          // upload icon in the right cornerx
                                          child: const Align(
                                            alignment: Alignment.bottomRight,
                                            child: CircleAvatar(
                                              radius: 12,
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                // upload icon
                                                Icons.camera_alt,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                            const SizedBox(height: 16),
                            FormBuilderTextField(
                              name: 'name',
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'Please enter your name'),
                                FormBuilderValidators.minLength(3,
                                    errorText:
                                        'Name must be at least 3 characters'),
                                FormBuilderValidators.maxLength(32,
                                    errorText:
                                        'Name must be at most 32 characters'),
                              ]),
                              valueTransformer: (value) => value?.trim(),
                            ),
                            const SizedBox(height: 16),
                          ],
                          FormBuilderTextField(
                              name: 'email',
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'Please enter your email'),
                                FormBuilderValidators.email(
                                    errorText: 'Please enter a valid email'),
                              ]),
                              valueTransformer: (value) => value?.trim()),

                          const SizedBox(height: 16),
                          FormBuilderTextField(
                            name: 'password',
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: 'Please enter your password'),
                              FormBuilderValidators.minLength(6,
                                  errorText:
                                      'Password must be at least 6 characters'),
                              FormBuilderValidators.maxLength(20,
                                  errorText:
                                      'Password must be at most 20 characters'),
                            ]),
                          ),
                          const SizedBox(height: 16),
                          if (mode == AuthMode.register) ...[
                            FormBuilderTextField(
                              name: 'confirmPassword',
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Confirm Password',
                                border: OutlineInputBorder(),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'Please confirm your password'),
                                FormBuilderValidators.minLength(6,
                                    errorText:
                                        'Password must be at least 6 characters'),
                                FormBuilderValidators.maxLength(20,
                                    errorText:
                                        'Password must be at most 20 characters'),
                              ]),
                              valueTransformer: (value) => value
                                  ?.trim(), // remove leading and trailing spaces
                            ),
                            const SizedBox(height: 16),
                          ],
                          // sign-in/sign-up/loading
                          AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: _isLoading
                                  ? Container(
                                      height: 60,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      height: 60,
                                      child: ElevatedButton(
                                        onPressed: mode == AuthMode.login
                                            ? _signIn
                                            : _signUp,
                                        child: Text(mode.label),
                                      ),
                                    )),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    mode = mode == AuthMode.login
                                        ? AuthMode.register
                                        : AuthMode.login;

                                    _formKey.currentState!.reset();
                                  });
                                },
                                child: mode == AuthMode.login
                                    ? const Text('Don\'t have an account?')
                                    : const Text('Already have an account?'),
                              ),
                              if (mode == AuthMode.login)
                                TextButton(
                                  onPressed: () {
                                    context.router.push(
                                      const ForgotPasswordRoute(),
                                    );
                                  },
                                  child: const Text('Forgot Password?'),
                                ),
                            ],
                          ),
                          const OrBar(),
                          const SizedBox(
                            height: 16,
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: _isLoading
                                ? Container(
                                    height: 60,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(16),
                                      ),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    height: 60,
                                    child: ElevatedButton.icon(
                                      onPressed: _signInWithGoogle,
                                      icon: const Icon(Icons.g_mobiledata),
                                      label: const Text('Sign In with Google'),
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Future<void> _signIn() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _formKey.currentState!.fields['email']!.value,
          password: _formKey.currentState!.fields['password']!.value,
        );

        if (mounted) {
          context.router.replace(const HomeRoute());
        }
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'user-not-found':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No user found for that email.'),
              ),
            );
            break;
          case 'wrong-password':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Wrong password provided for that user.'),
              ),
            );
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
              ),
            );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _signUp() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _formKey.currentState!.fields['email']!.value,
          password: _formKey.currentState!.fields['password']!.value,
        );
        await FirebaseAuth.instance.currentUser!.sendEmailVerification();
        await FirebaseAuth.instance.currentUser!
            .updateDisplayName(_formKey.currentState!.fields['name']!.value);
        if (_formKey.currentState!.fields['profileImage']!.value != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child(FirebaseAuth.instance.currentUser!.uid)
              .child('profile.jpg');
          await ref
              .putFile(_formKey.currentState!.fields['profileImage']!.value);
          await FirebaseAuth.instance.currentUser!
              .updatePhotoURL(await ref.getDownloadURL());
        } else {
          await FirebaseAuth.instance.currentUser!
              .updatePhotoURL('$placeholderUrlbase$seed');
        }

        if (mounted) {
          context.router.replace(const HomeRoute());
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Trigger the authentication flow
      final googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final googleAuth = await googleUser?.authentication;

      if (googleAuth != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        await FirebaseAuth.instance.signInWithCredential(credential);

        if (mounted) {
          context.router.replace(const HomeRoute());
        }
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.'),
            ),
          );
          break;
        case 'invalid-credential':
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Error occurred while accessing credentials. Try again.'),
            ),
          );
          break;
        case 'operation-not-allowed':
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'This operation is not allowed. You must enable this service in the console.'),
            ),
          );
          break;
        case 'user-disabled':
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'The user account has been disabled by an administrator.'),
            ),
          );
          break;
        case 'user-not-found':
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'No user found corresponding to the given identifier. The user may have been deleted.'),
            ),
          );
          break;
        case 'wrong-password':
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'The password is invalid or the user does not have a password.'),
            ),
          );
          break;
        case 'invalid-verification-code':
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('The verification code is invalid.'),
            ),
          );
          break;
        case 'invalid-verification-id':
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('The verification ID is invalid.'),
            ),
          );
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
