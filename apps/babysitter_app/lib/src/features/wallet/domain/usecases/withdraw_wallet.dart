import '../entities/wallet_withdraw_result.dart';
import '../repositories/wallet_repository.dart';

class WithdrawWalletUseCase {
  final WalletRepository _repository;

  WithdrawWalletUseCase(this._repository);

  Future<WalletWithdrawResult> call(int amountCents) {
    return _repository.withdraw(amountCents);
  }
}
