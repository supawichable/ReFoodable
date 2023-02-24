import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/routes/router.gr.dart';
import 'package:gdsctokyo/widgets/or_bar.dart';

import 'package:google_sign_in/google_sign_in.dart';

// TODO:
// - validator coverage

enum AuthMode { login, register }

extension on AuthMode {
  String get label => this == AuthMode.login ? 'Sign In' : 'Sign Up';
}

// util for creating random string
String randomString(int length) {
  const _chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random.secure();
  return List.generate(length, (index) => _chars[random.nextInt(_chars.length)])
      .join();
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  bool _isLoading = false;
  bool _redirecting = false;

  late final StreamSubscription<User?> _authStateSubscription;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AuthMode mode = AuthMode.login;

  String placeholderUrlbase = 'https://api.dicebear.com/5.x/thumbs/png?seed=';
  String seed = randomString(10);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _authStateSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      if (_redirecting) {
        return;
      }
      if (user != null) {
        _redirecting = true;
        context.router
            .pushAndPopUntil(const HomeRoute(), predicate: (route) => false);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _authStateSubscription.cancel();

    super.dispose();
  }

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
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (mode == AuthMode.register)
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  seed = randomString(10);
                                });
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Refresh'),
                            ),
                          if (mode == AuthMode.register)
                            const SizedBox(height: 16),
                          if (mode == AuthMode.register)
                            CircleAvatar(
                              radius: 48,
                              backgroundImage:
                                  NetworkImage('$placeholderUrlbase$seed'),
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
                          if (mode == AuthMode.register)
                            const SizedBox(height: 16),
                          if (mode == AuthMode.register)
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter your name'
                                  : null,
                            ),
                          if (mode == AuthMode.register)
                            const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value!.isEmpty
                                ? 'Please enter your email'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value!.isEmpty
                                ? 'Please enter your password'
                                : value.contains(' ')
                                    ? 'Password cannot contain spaces'
                                    : null,
                          ),
                          const SizedBox(height: 16),
                          if (mode == AuthMode.register)
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Confirm Password',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter your password'
                                  : _passwordController.text !=
                                          _confirmPasswordController.text
                                      ? 'Passwords do not match'
                                      : value.contains(' ')
                                          ? 'Password cannot contain spaces'
                                          : null,
                            ),
                          if (mode == AuthMode.register)
                            const SizedBox(height: 16),
                          if (mode == AuthMode.login)
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: _isLoading
                                  ? Container(
                                      height: 60,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
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
                                        onPressed: _signIn,
                                        child: const Text('Sign In'),
                                      ),
                                    ),
                            ),
                          if (mode == AuthMode.register)
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: _isLoading
                                  ? Container(
                                      height: 60,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer),
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      height: 60,
                                      child: ElevatedButton(
                                        onPressed: _signUp,
                                        child: const Text('Sign Up'),
                                      ),
                                    ),
                            ),
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
                                    _emailController.clear();
                                    _passwordController.clear();
                                    _confirmPasswordController.clear();
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
                                        Radius.circular(8),
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
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
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
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        await FirebaseAuth.instance.currentUser!.sendEmailVerification();
        await FirebaseAuth.instance.currentUser!
            .updateDisplayName(_nameController.text.trim());
        await FirebaseAuth.instance.currentUser!
            .updatePhotoURL('$placeholderUrlbase$seed');
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
