import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';

import '../../../../common_widgets/app_toast.dart';
import '../providers/wallet_providers.dart';
import 'wallet_styles.dart';

class WithdrawBottomSheet extends ConsumerStatefulWidget {
  final int availableCents;
  final VoidCallback onSuccess;

  const WithdrawBottomSheet({
    super.key,
    required this.availableCents,
    required this.onSuccess,
  });

  @override
  ConsumerState<WithdrawBottomSheet> createState() =>
      _WithdrawBottomSheetState();
}

class _WithdrawBottomSheetState extends ConsumerState<WithdrawBottomSheet> {
  final _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletControllerProvider);
    final availableDollars = widget.availableCents / 100.0;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            'Withdraw',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: WalletStyles.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Available: \$${availableDollars.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 13,
              color: WalletStyles.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]{0,2}')),
            ],
            decoration: InputDecoration(
              prefixText: '\$ ',
              labelText: 'Amount',
              errorText: _errorText,
              helperText: 'Minimum withdrawal is \$5.00',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: walletState.isWithdrawing
                  ? null
                  : () => _submitWithdrawal(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: WalletStyles.primaryBlue,
                foregroundColor: AppColors.textOnButton,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: walletState.isWithdrawing
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnButton),
                      ),
                    )
                  : const Text(
                      'Withdraw',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitWithdrawal(BuildContext context) async {
    final text = _controller.text.trim();
    final amount = double.tryParse(text);
    final available = widget.availableCents / 100.0;

    if (amount == null || amount <= 0) {
      setState(() => _errorText = 'Enter a valid amount');
      return;
    }
    if (amount < 5.0) {
      setState(() => _errorText = 'Minimum withdrawal is \$5.00');
      return;
    }
    if (amount > available) {
      setState(() => _errorText = 'Amount exceeds available balance');
      return;
    }

    setState(() => _errorText = null);

    final cents = (amount * 100).round();

    try {
      final result = await ref.read(walletControllerProvider.notifier).withdraw(cents);
      if (!context.mounted) return;
      Navigator.of(context).pop();
      final arrival = result.estimatedArrival;
      AppToast.show(
        context,
        SnackBar(
          content: Text(
            arrival == null || arrival.isEmpty
                ? 'Withdrawal submitted successfully.'
                : 'Withdrawal submitted. Estimated arrival: $arrival',
          ),
        ),
      );
      widget.onSuccess();
    } catch (e) {
      if (!context.mounted) return;
      final message = AppErrorHandler.parse(e).message;
      AppToast.show(context, SnackBar(content: Text(message)));
    }
  }
}
