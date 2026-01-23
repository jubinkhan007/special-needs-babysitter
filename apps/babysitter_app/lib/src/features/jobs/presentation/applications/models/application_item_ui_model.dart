import '../../../../jobs/domain/applications/application_item.dart';
import 'package:intl/intl.dart';

class ApplicationItemUiModel {
  final String id;
  final String sitterName;
  final String avatarUrl;
  final String distanceText;
  final bool isVerified;
  final String ratingText;
  final double ratingValue; // For stars
  final String responseRateText;
  final String reliabilityRateText;
  final String experienceText;
  final String jobTitle;
  final String scheduledDateText;
  final bool showApplicationChip;
  final String? status;
  final bool isPending;

  const ApplicationItemUiModel({
    required this.id,
    required this.sitterName,
    required this.avatarUrl,
    required this.distanceText,
    required this.isVerified,
    required this.ratingText,
    required this.ratingValue,
    required this.responseRateText,
    required this.reliabilityRateText,
    required this.experienceText,
    required this.jobTitle,
    required this.scheduledDateText,
    required this.showApplicationChip,
    this.status,
    required this.isPending,
  });

  factory ApplicationItemUiModel.fromDomain(ApplicationItem item) {
    // Format helpers
    final dateFormat = DateFormat('MM/dd/yyyy');

    return ApplicationItemUiModel(
      id: item.id,
      sitterName: item.sitterName,
      avatarUrl: item.avatarUrl,
      distanceText: '${item.distanceMiles.toInt()} Miles Away',
      isVerified: item.isVerified,
      ratingText: item.rating.toString(),
      ratingValue: item.rating,
      responseRateText: '${item.responseRatePercent}%',
      reliabilityRateText: '${item.reliabilityRatePercent}%',
      experienceText: '${item.experienceYears} Years',
      jobTitle: item.jobTitle,
      scheduledDateText: 'Scheduled: ${dateFormat.format(item.scheduledDate)}',
      status: item.status,
      isPending: item.status == null || item.status == 'pending',
      showApplicationChip: item.isApplication,
    );
  }
}
