import 'package:equatable/equatable.dart';

class CareApproach extends Equatable {
  final String description;
  final String transportationNeeds; // "Pickup", "Dropoff", etc.
  final bool needsPickupFromSchool;
  final bool needsDropOffAtTherapy;
  final String pickupDropOffRequirements;
  final String specialAccommodations;

  const CareApproach({
    required this.description,
    required this.transportationNeeds,
    required this.needsPickupFromSchool,
    required this.needsDropOffAtTherapy,
    required this.pickupDropOffRequirements,
    required this.specialAccommodations,
  });

  @override
  List<Object?> get props => [
        description,
        transportationNeeds,
        needsPickupFromSchool,
        needsDropOffAtTherapy,
        pickupDropOffRequirements,
        specialAccommodations,
      ];
}
