import 'package:intl/intl.dart';
import '../../domain/job.dart';

class JobUiModel {
  final String id;
  final String title;
  final bool isActive;
  final String location;
  final String scheduleLabel;
  final String rateLabel;
  final String
      childDetailsRaw; // "Ally (4y) | Jason (2y)" - formatting handled by widget
  final List<ChildPart>
      childParts; // Structure for rich text: ["Ally ", "(4y)", " | ", "Jason ", "(2y)"]

  JobUiModel({
    required this.id,
    required this.title,
    required this.isActive,
    required this.location,
    required this.scheduleLabel,
    required this.rateLabel,
    required this.childDetailsRaw,
    required this.childParts,
  });

  factory JobUiModel.fromDomain(Job job) {
    // formatter
    final dateFormat = DateFormat('MM/dd/yyyy'); // 20 May, 2025

    return JobUiModel(
      id: job.id,
      title: job.title,
      isActive: job.status == JobStatus.active,
      location: job.location, // "Brooklyn, NY 11201"
      scheduleLabel: dateFormat.format(job.scheduleDate),
      rateLabel: job.rateText, // "$25/hr"
      childDetailsRaw: _formatChildrenString(job.children),
      childParts: _generateChildParts(job.children),
    );
  }

  static String _formatChildrenString(List<ChildDetail> children) {
    if (children.isEmpty) return 'No children';
    return children.map((c) => '${c.name} (${c.ageYears}y)').join(' | ');
  }

  static List<ChildPart> _generateChildParts(List<ChildDetail> children) {
    // Produces a list of parts so the UI can construct RichText
    // Example: Ally (4y) | Jason (2y)
    // Parts: [Name: "Ally ", Age: "(4y)", Separator: " | ", Name: "Jason ", Age: "(2y)"]
    final parts = <ChildPart>[];
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      parts.add(ChildPart(text: '${child.name} ', type: ChildPartType.name));
      parts.add(
          ChildPart(text: '(${child.ageYears}y)', type: ChildPartType.age));

      if (i < children.length - 1) {
        parts.add(ChildPart(text: ' | ', type: ChildPartType.separator));
      }
    }
    return parts;
  }
}

enum ChildPartType {
  name, // Grey
  age, // Blue accent
  separator, // Grey
}

class ChildPart {
  final String text;
  final ChildPartType type;

  ChildPart({required this.text, required this.type});
}
