import '../../domain/entities/wallet_balance.dart';
import '../../domain/entities/wallet_withdraw_result.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../services/wallet_api_service.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletApiService _service;

  WalletRepositoryImpl(this._service);

  @override
  Future<WalletBalance> getBalance() async {
    return _service.getBalance();
  }

  @override
  Future<WalletWithdrawResult> withdraw(int amountCents) async {
    return _service.withdraw(amountCents);
  }
}
