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
  final bool isDraft;
  final String parentUserId;

  const Job({
    required this.id,
    required this.title,
    required this.status,
    required this.location,
    required this.scheduleDate,
    required this.rateText,
    this.childIds = const [],
    required this.children,
    this.isDraft = false,
    required this.parentUserId,
  });
  
  /// Returns true if payment is required to activate this job
  /// A job in "draft" status needs payment to be posted
  bool get requiresPayment => isDraft;
  
  /// Returns true if the given userId is the owner of this job
  bool isOwnedBy(String userId) => parentUserId == userId;
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
