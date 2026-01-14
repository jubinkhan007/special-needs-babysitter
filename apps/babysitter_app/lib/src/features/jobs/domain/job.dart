enum JobStatus {
  active,
  closed,
  pending,
}

class Job {
  final String id;
  final String title;
  final JobStatus status;
  final String location;
  final DateTime scheduleDate;
  final String rateText;
  final List<ChildDetail> children;

  const Job({
    required this.id,
    required this.title,
    required this.status,
    required this.location,
    required this.scheduleDate,
    required this.rateText,
    required this.children,
  });
}

class ChildDetail {
  final String name;
  final int ageYears;

  const ChildDetail({
    required this.name,
    required this.ageYears,
  });
}
