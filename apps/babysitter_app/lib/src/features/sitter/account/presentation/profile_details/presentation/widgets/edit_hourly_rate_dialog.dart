import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:babysitter_app/src/common_widgets/app_toast.dart';
import 'package:babysitter_app/common/widgets/primary_action_button.dart';

class EditHourlyRateDialog extends StatefulWidget {
  final double initialRate;
  final bool initialOpenToNegotiating;
  final Future<bool> Function(double rate, bool openToNegotiating) onSave;

  const EditHourlyRateDialog({
    super.key,
    required this.initialRate,
    required this.initialOpenToNegotiating,
    required this.onSave,
  });

  @override
  State<EditHourlyRateDialog> createState() => _EditHourlyRateDialogState();
}

class _EditHourlyRateDialogState extends State<EditHourlyRateDialog> {
  static const _textDark = Color(0xFF1A1A1A);
  static const _greyText = Color(0xFF667085);
  static const _primaryBlue = AppColors.primary;

  late double _rate;
  late bool _openToNegotiating;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _rate = widget.initialRate <= 0 ? 15.0 : widget.initialRate;
    _openToNegotiating = widget.initialOpenToNegotiating;
  }

  Future<void> _handleSave() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final success = await widget.onSave(_rate, _openToNegotiating);
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
    } else {
      AppToast.show(
        context,
        const SnackBar(content: Text('Failed to update hourly rate')),
      );
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Edit Hourly Rate',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.buttonDark,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: _greyText),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${_rate.toStringAsFixed(1)} / hr',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 12),
                Slider(
                  min: 10,
                  max: 100,
                  divisions: 180,
                  label: '\$${_rate.toStringAsFixed(1)}',
                  value: _rate,
                  activeColor: _primaryBlue,
                  onChanged: (val) => setState(() => _rate = val),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _openToNegotiating,
                      onChanged: (val) =>
                          setState(() => _openToNegotiating = val ?? false),
                      activeColor: _primaryBlue,
                    ),
                    const Expanded(
                      child: Text(
                        'I am open to negotiating my rate.',
                        style: TextStyle(fontSize: 14, color: _greyText),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: PrimaryActionButton(
              label: _isSaving ? 'Saving...' : 'Save Changes',
              onPressed: _isSaving ? null : _handleSave,
            ),
          ),
        ],
      ),
    );
  }
}
