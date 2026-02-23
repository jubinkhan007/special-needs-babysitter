class WalletBalance {
  final int balanceCents;
  final int availableForWithdrawalCents;
  final String? balanceInDollars;

  const WalletBalance({
    required this.balanceCents,
    required this.availableForWithdrawalCents,
    this.balanceInDollars,
  });

  String get formattedBalance {
    final formatted = balanceInDollars?.trim();
    if (formatted != null && formatted.isNotEmpty) {
      return '\$$formatted';
    }
    return _formatFromCents(balanceCents);
  }

  String get formattedAvailable {
    return _formatFromCents(availableForWithdrawalCents);
  }

  String _formatFromCents(int cents) {
    final value = cents / 100.0;
    return '\$${value.toStringAsFixed(2)}';
  }
}
