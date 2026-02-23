import 'package:babysitter_app/src/features/wallet/domain/entities/wallet_balance.dart';
import 'package:babysitter_app/src/features/wallet/domain/repositories/wallet_repository.dart';

class GetWalletBalanceUseCase {
  final WalletRepository _repository;

  GetWalletBalanceUseCase(this._repository);

  Future<WalletBalance> call() {
    return _repository.getBalance();
  }
}
