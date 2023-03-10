import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/providers/current_user.dart';
import 'package:gdsctokyo/providers/theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;
    final providers =
        currentUser?.providerData.map((e) => e.providerId).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: ListView(children: [
          if (currentUser != null)
            SettingSection(
              title: 'Account',
              children: [
                if (!currentUser.emailVerified) ...[
                  Card(
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Please verify your email to update account settings',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Flexible(
                                  child: IconButton(
                                      onPressed: () {
                                        currentUser.reload();
                                      },
                                      icon: const Icon(Icons.refresh)),
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                currentUser.sendEmailVerification();
                              },
                              child: const Text('Send Verification Email'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
                if (currentUser.emailVerified) ...[
                  if (providers!.contains('password')) ...[
                    ListTile(
                      leading: const Icon(Icons.password_outlined),
                      title: const Text('Send Password Reset Email'),
                      trailing: const Icon(Icons.send_outlined),
                      onTap: () {
                        FirebaseAuth.instance.sendPasswordResetEmail(
                            email: FirebaseAuth.instance.currentUser!.email!);
                      },
                    ),
                    const Divider(),
                    ListTile(
                        leading: const Icon(Icons.email_outlined),
                        title: const Text('Change Email'),
                        trailing: const Icon(Icons.edit_outlined),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const EmailChangeDialog(),
                          );
                        }),
                    const Divider(),
                  ]
                ],
              ],
            ),
          const SizedBox(height: 16),
          SettingSection(
            title: 'Display',
            children: [
              ListTile(
                leading: const Icon(Icons.dark_mode_outlined),
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (value) {
                    ref.read(themeProvider.notifier).setThemeMode(
                        Theme.of(context).brightness == Brightness.light
                            ? ThemeMode.dark
                            : ThemeMode.light);
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: const Text('Language'),
                onTap: () {},
              ),
              const Divider(),
            ],
          )
        ]),
      ),
    );
  }
}

class EmailChangeDialog extends StatefulWidget {
  const EmailChangeDialog({super.key});

  @override
  State<EmailChangeDialog> createState() => _EmailChangeDialogState();
}

class _EmailChangeDialogState extends State<EmailChangeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Email'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                await FirebaseAuth.instance.currentUser!
                    .reauthenticateWithCredential(
                  EmailAuthProvider.credential(
                    email: FirebaseAuth.instance.currentUser!.email!,
                    password: _passwordController.text,
                  ),
                );
                await FirebaseAuth.instance.currentUser!
                    .updateEmail(_emailController.text);
                await FirebaseAuth.instance.currentUser!
                    .reauthenticateWithCredential(
                  EmailAuthProvider.credential(
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
                );
                await FirebaseAuth.instance.currentUser!
                    .sendEmailVerification();
                if (mounted) {
                  Navigator.of(context).pop();
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                  ),
                );
              }
            }
          },
          child: const Text('Change'),
        ),
      ],
    );
  }
}

class SettingSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const SettingSection(
      {super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const Divider(),
        ...children,
      ],
    );
  }
}
