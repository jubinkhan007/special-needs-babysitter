import 'package:babysitter_app/src/features/wallet/domain/entities/wallet_withdraw_result.dart';
import 'package:babysitter_app/src/features/wallet/domain/repositories/wallet_repository.dart';

class WithdrawWalletUseCase {
  final WalletRepository _repository;

  WithdrawWalletUseCase(this._repository);

  Future<WalletWithdrawResult> call(int amountCents) {
    return _repository.withdraw(amountCents);
  }
}
