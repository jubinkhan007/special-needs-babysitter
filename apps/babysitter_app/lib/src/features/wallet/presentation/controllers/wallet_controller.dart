import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/wallet_balance.dart';
import '../../domain/entities/wallet_withdraw_result.dart';
import '../providers/wallet_dependencies.dart';

class WalletState {
  final bool isLoading;
  final bool isWithdrawing;
  final WalletBalance? balance;
  final Object? error;

  const WalletState({
    this.isLoading = false,
    this.isWithdrawing = false,
    this.balance,
    this.error,
  });

  WalletState copyWith({
    bool? isLoading,
    bool? isWithdrawing,
    WalletBalance? balance,
    Object? error,
    bool clearError = false,
  }) {
    return WalletState(
      isLoading: isLoading ?? this.isLoading,
      isWithdrawing: isWithdrawing ?? this.isWithdrawing,
      balance: balance ?? this.balance,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class WalletController extends Notifier<WalletState> {
  @override
  WalletState build() {
    Future.microtask(loadBalance);
    return const WalletState(isLoading: true);
  }

  Future<void> loadBalance() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final balance = await ref.read(getWalletBalanceUseCaseProvider).call();
      state = state.copyWith(isLoading: false, balance: balance);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> refresh() => loadBalance();

  Future<WalletWithdrawResult> withdraw(int amountCents) async {
    state = state.copyWith(isWithdrawing: true, clearError: true);
    try {
      final result =
          await ref.read(withdrawWalletUseCaseProvider).call(amountCents);
      state = state.copyWith(isWithdrawing: false);
      await loadBalance();
      return result;
    } catch (e) {
      state = state.copyWith(isWithdrawing: false, error: e);
      rethrow;
    }
  }
}
