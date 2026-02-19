import 'package:core/core.dart';
import 'package:flutter/material.dart';
import '../../../../theme/app_tokens.dart';
import 'cancellation_confirmation_dialog.dart';
import 'refund_options_dialog.dart';

Future<void> showBookingMoreOptionsSheet(
  BuildContext context, {
  required DateTime scheduledDate,
  required VoidCallback onUpdate,
  required VoidCallback onCancel,
  required VoidCallback onShare,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: false,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.45),
    useSafeArea: true,
    builder: (_) => BookingMoreOptionsSheet(
      scheduledDate: scheduledDate,
      onUpdate: onUpdate,
      onCancel: onCancel,
      onShare: onShare,
    ),
  );
}

class BookingMoreOptionsSheet extends StatefulWidget {
  final DateTime scheduledDate;
  final VoidCallback onUpdate;
  final VoidCallback onCancel;
  final VoidCallback onShare;

  const BookingMoreOptionsSheet({
    super.key,
    required this.scheduledDate,
    required this.onUpdate,
    required this.onCancel,
    required this.onShare,
  });

  @override
  State<BookingMoreOptionsSheet> createState() =>
      _BookingMoreOptionsSheetState();
}

class _BookingMoreOptionsSheetState extends State<BookingMoreOptionsSheet> {
  bool _showCancelReasons = false;
  String? _selectedReason;

  final List<String> _cancelReasons = [
    "Child's Health Issue",
    'Other Emergency',
    'Double Booking',
    'Travelling',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: 24,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _showCancelReasons
            ? _buildCancelReasonsView()
            : _buildOptionsView(),
      ),
    );
  }

  Widget _buildOptionsView() {
    return Column(
      key: const ValueKey('options'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top-right close
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.close, size: 20, color: Color(0xFF111827)),
          ),
        ),
        const SizedBox(height: 4),

        // Title
        const Text(
          'More Options',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0B1220),
            height: 1.1,
          ),
        ),
        const SizedBox(height: 20),

        _OptionTile(
          icon: Icons.calendar_month_outlined,
          label: 'Update Booking',
          onTap: () {
            Navigator.of(context).pop();
            widget.onUpdate();
          },
        ),
        const SizedBox(height: 18),

        _OptionTile(
          icon: Icons.event_busy_outlined,
          label: 'Cancel Booking',
          onTap: () {
            setState(() {
              _showCancelReasons = true;
            });
          },
        ),
        const SizedBox(height: 18),

        _OptionTile(
          icon: Icons.share_outlined,
          label: 'Share Profile',
          onTap: () {
            Navigator.of(context).pop();
            widget.onShare();
          },
        ),
      ],
    );
  }

  Widget _buildCancelReasonsView() {
    return Column(
      key: const ValueKey('cancel_reasons'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: back arrow + close
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _showCancelReasons = false;
                  _selectedReason = null;
                });
              },
              child: const Icon(Icons.chevron_left,
                  size: 28, color: Color(0xFF6B7280)),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child:
                  const Icon(Icons.close, size: 22, color: Color(0xFF111827)),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Title
        const Text(
          'Select Reason to Cancel',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0B1220),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 20),

        // Radio options
        ...List.generate(_cancelReasons.length, (index) {
          final reason = _cancelReasons[index];
          final isSelected = _selectedReason == reason;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedReason = reason;
                });
              },
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppTokens.primaryBlue
                            : const Color(0xFFD1D5DB),
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTokens.primaryBlue,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Text(
                    reason,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 8),

        // Submit button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _selectedReason != null
                ? () async {
                    final navigator = Navigator.of(context);
                    navigator.pop();
                    final tier = getCancellationTier(widget.scheduledDate);
                    final confirmed = await showCancellationConfirmationDialog(
                      navigator.context,
                      tier: tier,
                    );
                    if (confirmed == true) {
                      // Show refund options dialog
                      final refundOption =
                          await showRefundOptionsDialog(navigator.context);
                      if (refundOption != null) {
                        widget.onCancel();
                      }
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTokens.primaryBlue,
              disabledBackgroundColor: AppTokens.primaryBlue.withOpacity(0.5),
              foregroundColor: AppColors.textOnButton,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 22, color: const Color(0xFF6B7280)),
          const SizedBox(width: 14),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }
}
