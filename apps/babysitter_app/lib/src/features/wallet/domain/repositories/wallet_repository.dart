import 'package:babysitter_app/src/features/wallet/domain/entities/wallet_balance.dart';
import 'package:babysitter_app/src/features/wallet/domain/entities/wallet_withdraw_result.dart';

abstract class WalletRepository {
  Future<WalletBalance> getBalance();
  Future<WalletWithdrawResult> withdraw(int amountCents);
}
