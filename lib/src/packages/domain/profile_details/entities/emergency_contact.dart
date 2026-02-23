import 'package:equatable/equatable.dart';

class EmergencyContact extends Equatable {
  final String fullName;
  final String relationshipToChild;
  final String phoneNumber;
  final String email;
  final String address;
  final String specialInstructions;

  const EmergencyContact({
    required this.fullName,
    required this.relationshipToChild,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.specialInstructions,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'relationshipToChild': relationshipToChild,
      'primaryPhone':
          phoneNumber, // Mapping to backend expected key 'primaryPhone'
      'email': email,
      'address': address,
      'specialInstructions': specialInstructions,
    };
  }

  @override
  List<Object?> get props => [
        fullName,
        relationshipToChild,
        phoneNumber,
        email,
        address,
        specialInstructions,
      ];
}
