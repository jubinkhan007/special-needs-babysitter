import '../../presentation/models/booking_details_ui_model.dart';
import '../booking_status.dart';

class ReviewArgs {
  final String bookingId;
  final String sitterId;
  final String sitterName;
  final BookingDetailsUiModel sitterData; // Reusing UI model for card display
  final BookingStatus status;

  ReviewArgs({
    required this.bookingId,
    required this.sitterId,
    required this.sitterName,
    required this.sitterData,
    required this.status,
  });
}
