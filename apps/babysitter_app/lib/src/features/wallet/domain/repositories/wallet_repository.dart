import '../entities/wallet_balance.dart';
import '../entities/wallet_withdraw_result.dart';

abstract class WalletRepository {
  Future<WalletBalance> getBalance();
  Future<WalletWithdrawResult> withdraw(int amountCents);
}
