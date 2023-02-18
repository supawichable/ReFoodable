import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/routes/router.gr.dart';

// What's debug.dart?
// We currently have no Home page.
// So, we use debug.dart as a Home page for now.
// You can use it to link to your route for testing.
// See my example below:

class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug'),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                context.router.push(const SignInRoute());
              },
              child: const Text('Sign In Page')),
          ElevatedButton(
              onPressed: () {
                context.router.push(const ForgotPasswordRoute());
              },
              child: const Text('Forgot Password Page')),
          ElevatedButton(
              onPressed: () {
                context.router.push(const ResetPasswordRoute());
              },
              child: const Text('Reset Password Page')),
        ],
      )),
    );
  }
}
