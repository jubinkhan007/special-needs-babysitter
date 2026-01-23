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
  final List<String> childIds;
  final List<ChildDetail> children;

  const Job({
    required this.id,
    required this.title,
    required this.status,
    required this.location,
    required this.scheduleDate,
    required this.rateText,
    this.childIds = const [],
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

class Address {
  final String streetAddress;
  final String aptUnit;
  final String city;
  final String state;
  final String zipCode;

  const Address({
    required this.streetAddress,
    required this.aptUnit,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  String get publicLocation => '$city, $state';
  String get fullAddress =>
      '$streetAddress${aptUnit.isNotEmpty ? ", $aptUnit" : ""}, $city, $state $zipCode';
}
