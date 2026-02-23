class WalletWithdrawResult {
  final bool success;
  final String? transferId;
  final int amountCents;
  final String? amountInDollars;
  final String? estimatedArrival;

  const WalletWithdrawResult({
    required this.success,
    required this.amountCents,
    this.transferId,
    this.amountInDollars,
    this.estimatedArrival,
  });
}
