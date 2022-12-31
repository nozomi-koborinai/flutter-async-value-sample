import 'package:flutter/material.dart';
import 'package:flutter_async_value_sample/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AsyncValue Sample'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => ref.read(userServiceProvider).login(),
              child: const Text('ログイン'),
            ),
          ],
        ),
      ),
    );
  }
}
