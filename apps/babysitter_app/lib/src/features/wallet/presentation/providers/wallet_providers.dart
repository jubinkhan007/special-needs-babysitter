import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/wallet_controller.dart';

export 'wallet_dependencies.dart';
export '../controllers/wallet_controller.dart'
    show WalletController, WalletState;

final walletControllerProvider =
    NotifierProvider<WalletController, WalletState>(() {
  return WalletController();
});
