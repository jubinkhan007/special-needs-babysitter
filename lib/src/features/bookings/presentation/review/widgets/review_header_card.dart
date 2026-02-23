import 'package:flutter/material.dart';
import 'package:babysitter_app/src/features/bookings/presentation/models/booking_details_ui_model.dart';
import 'package:babysitter_app/src/features/bookings/presentation/widgets/sitter_details_card.dart';

/// Reuses the [SitterDetailsCard] to ensure 100% visual consistency
/// between Booking Details and Review screens.
class ReviewHeaderCard extends StatelessWidget {
  final BookingDetailsUiModel uiModel;

  const ReviewHeaderCard({
    super.key,
    required this.uiModel,
  });

  @override
  Widget build(BuildContext context) {
    return SitterDetailsCard(uiModel: uiModel);
  }
}
