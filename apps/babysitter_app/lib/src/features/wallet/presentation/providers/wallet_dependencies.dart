import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:auth/auth.dart';

import '../../data/repositories/wallet_repository_impl.dart';
import '../../data/services/wallet_api_service.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../domain/usecases/get_wallet_balance.dart';
import '../../domain/usecases/withdraw_wallet.dart';

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
