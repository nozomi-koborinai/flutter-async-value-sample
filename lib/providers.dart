import 'package:flutter/material.dart';
import 'package:flutter_async_value_sample/loading_notifier.dart';
import 'package:flutter_async_value_sample/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ログイン処理状態
final loginStateProvider = StateProvider<AsyncValue<void>>(
  (_) => const AsyncValue.data(null),
);

/// ログアウト処理状態
final logoutStateProvider = StateProvider<AsyncValue<void>>(
  (_) => const AsyncValue.data(null),
);

/// ユーザーサービスプロバイダー
final userServiceProvider = Provider(
  UserService.new,
);

/// スナックバー表示用のGlobalKey
final scaffoldMessengerKeyProvider = Provider(
  (_) => GlobalKey<ScaffoldMessengerState>(),
);

/// ダイアログ表示用のGlobalKey
final navigatorKeyProvider = Provider(
  (_) => GlobalKey<NavigatorState>(),
);

/// ローディングの表示有無
final loadingProvider = NotifierProvider<LoadingNotifier, bool>(
  LoadingNotifier.new,
);
