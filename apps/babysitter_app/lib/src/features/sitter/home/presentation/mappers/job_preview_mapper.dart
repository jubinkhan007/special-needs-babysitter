import 'package:domain/domain.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/job_preview.dart';

/// Legacy mapper for Job -> JobPreview conversion.
/// Note: The sitter home screen now uses jobPreviewsNotifierProvider which
/// parses the API response directly with SitterJobPreviewDto for accurate data.
/// This mapper is kept for backwards compatibility with other screens.
class JobPreviewMapper {
  static JobPreview map(
    Job job, {
    bool isBookmarked = false,
    LatLng? userLocation,
  }) {
    final location =
        '${job.address.city}, ${job.address.state} ${job.address.zipCode}';

    String distanceText = '';
    if (userLocation != null && job.location != null) {
      final distance = const Distance().as(
        LengthUnit.Kilometer,
        userLocation,
        LatLng(job.location!.latitude, job.location!.longitude),
      );
      distanceText = '$distance km away';
    }

    final childrenList = job.children.isNotEmpty
        ? job.children
            .map((c) => ChildInfo(name: c.firstName, age: c.age))
            .toList()
        : job.childIds
            .map((id) => const ChildInfo(name: 'Child', age: 0))
            .toList();

    return JobPreview(
      id: job.id ?? '',
      title: job.title,
      familyName: 'Family',
      childrenCount: job.childIds.length,
      children: childrenList,
      location: location,
      distance: distanceText,
      requiredSkills: const ['Special Needs'],
      hourlyRate: job.payRate,
      isBookmarked: isBookmarked,
    );
  }
}
