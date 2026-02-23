import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babysitter_app/src/packages/auth/auth.dart';

import 'package:babysitter_app/src/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:babysitter_app/src/features/wallet/data/services/wallet_api_service.dart';
import 'package:babysitter_app/src/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:babysitter_app/src/features/wallet/domain/usecases/get_wallet_balance.dart';
import 'package:babysitter_app/src/features/wallet/domain/usecases/withdraw_wallet.dart';

final walletApiServiceProvider = Provider<WalletApiService>((ref) {
  final dio = ref.watch(authDioProvider);
  return WalletApiService(dio);
});

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  final service = ref.watch(walletApiServiceProvider);
  return WalletRepositoryImpl(service);
});

final getWalletBalanceUseCaseProvider = Provider<GetWalletBalanceUseCase>((ref) {
  return GetWalletBalanceUseCase(ref.watch(walletRepositoryProvider));
});

final withdrawWalletUseCaseProvider = Provider<WithdrawWalletUseCase>((ref) {
  return WithdrawWalletUseCase(ref.watch(walletRepositoryProvider));
});
