import '../../presentation/models/booking_details_ui_model.dart';
import '../booking_status.dart';

class ReviewArgs {
  final String bookingId;
  final String sitterId;
  final String sitterName;
  final BookingDetailsUiModel sitterData; // Reusing UI model for card display
  final BookingStatus status;
  final String? jobTitle;
  final String? location;
  final String? familyName;
  final String? childrenCount;
  final String? paymentLabel;
  final String? avatarUrl;
  final String? reviewPrompt;
  final String jobId;

  ReviewArgs({
    required this.bookingId,
    required this.sitterId,
    required this.sitterName,
    required this.sitterData,
    required this.status,
    this.jobTitle,
    this.location,
    this.familyName,
    this.childrenCount,
    this.paymentLabel,
    this.avatarUrl,
    this.reviewPrompt,
    required this.jobId,
  });
}
