import 'package:flutter/material.dart';
import 'package:flutter_async_value_sample/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'error_dialog.dart';
import 'home_page.dart';

/// まずはConsumerStatefulWidgetでローディング表示を実現してみる
class LoginPageStateful extends ConsumerStatefulWidget {
  const LoginPageStateful({super.key});

  @override
  ConsumerState<LoginPageStateful> createState() => _LoginPageStatefulState();
}

class _LoginPageStatefulState extends ConsumerState<LoginPageStateful> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AsyncValue Sample'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // ローディング表示
                setState(() {
                  isLoading = true;
                });

                try {
                  // ログイン実行
                  await ref.read(userServiceProvider).login();

                  // ログインできたらスナックバーでメッセージを表示してホーム画面に遷移
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ログインしました'),
                    ),
                  );

                  await Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                } catch (e) {
                  // エラーが発生したらエラーダイアログを表示する
                  await showDialog<void>(
                    context: context,
                    builder: (context) => ErrorDialog(error: e),
                  );
                } finally {
                  // ローディングを非表示にする
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: const Text('ログイン'),
            ),
          ],
        ),
      ),
    );
  }
}
