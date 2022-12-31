import 'package:flutter/material.dart';
import 'package:flutter_async_value_sample/home_page.dart';
import 'package:flutter_async_value_sample/login_page.dart';
import 'package:flutter_async_value_sample/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'error_dialog.dart';

void main() {
  runApp(const ProviderScope(
    child: App(),
  ));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ログイン結果をハンドリングする
    ref.handleAsyncValue<void>(
      loginStateProvider,
      completeMessage: 'ログインしました！',
      complete: (context, _) async {
        // ログインできたらホーム画面に遷移する
        await Navigator.of(context).push<void>(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      },
    );

    // ログアウト結果をハンドリングする
    ref.handleAsyncValue<void>(
      logoutStateProvider,
      completeMessage: 'ログアウトしました！',
      complete: (context, _) {
        // ログアウトしたらログイン画面に戻る
        Navigator.of(context).pop();
      },
    );

    return MaterialApp(
      scaffoldMessengerKey: ref.watch(scaffoldMessengerKeyProvider),
      navigatorKey: ref.watch(navigatorKeyProvider),
      title: 'AsyncValue Sample',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const LoginPage(),
      builder: (context, child) {
        return Consumer(builder: (context, ref, _) {
          final isLoading = ref.watch(loadingProvider);
          return Stack(
            children: [
              child!,
              // ローディング表示
              isLoading
                  ? const ColoredBox(
                      color: Colors.black26,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container()
            ],
          );
        });
      },
    );
  }
}

extension WidgetRefEx on WidgetRef {
  /// AsyncValueを良い感じにハンドリングする
  void handleAsyncValue<T>(
    ProviderListenable<AsyncValue<T>> asyncValueProvider, {
    void Function(BuildContext context, T data)? complete,
    String? completeMessage,
  }) {
    listen<AsyncValue<T>>(
      asyncValueProvider,
      (_, next) async {
        final loadingNotifier = read(loadingProvider.notifier);
        if (next.isLoading) {
          loadingNotifier.show();
          return;
        }

        next.when(
          data: (data) async {
            loadingNotifier.hide();

            // 完了メッセージがあればスナックバーを表示する
            if (completeMessage != null) {
              final messengerState =
                  read(scaffoldMessengerKeyProvider).currentState;
              messengerState?.showSnackBar(
                SnackBar(
                  content: Text(completeMessage),
                ),
              );
            }
            complete?.call(read(navigatorKeyProvider).currentContext!, data);
          },
          error: (e, s) async {
            loadingNotifier.hide();

            // エラーが発生したらエラーダイアログを表示する
            await showDialog<void>(
              context: read(navigatorKeyProvider).currentContext!,
              builder: (context) => ErrorDialog(error: e),
            );
          },
          loading: loadingNotifier.show,
        );
      },
    );
  }
}
