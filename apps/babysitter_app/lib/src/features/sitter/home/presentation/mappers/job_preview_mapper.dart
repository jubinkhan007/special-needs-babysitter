import 'package:domain/domain.dart';
import '../../domain/entities/job_preview.dart';

class JobPreviewMapper {
  static JobPreview map(Job job) {
    return JobPreview(
      id: job.id ?? '',
      title: job.title,
      familyName: 'Family', // Placeholder until API provides this
      childrenCount: job.childIds.length,
      children: job.childIds
          .map((id) => const ChildInfo(name: 'Child', age: 0))
          .toList(), // Placeholder
      location:
          '${job.address.city}, ${job.address.state} ${job.address.zipCode}',
      distance: '5.0 km away', // Placeholder until location calc is added
      requiredSkills: const [
        'Special Needs'
      ], // Placeholder, maybe extract from details?
      hourlyRate: job.payRate,
    );
  }
}
