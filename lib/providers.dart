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
