import '../entities/wallet_balance.dart';
import '../repositories/wallet_repository.dart';

class GetWalletBalanceUseCase {
  final WalletRepository _repository;

  GetWalletBalanceUseCase(this._repository);

  Future<WalletBalance> call() {
    return _repository.getBalance();
  }
}
