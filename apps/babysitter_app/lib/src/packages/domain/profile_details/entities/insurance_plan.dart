import 'package:equatable/equatable.dart';

class InsurancePlan extends Equatable {
  final String planName;
  final String insuranceType;
  final double coverageAmount;
  final double monthlyPremium;
  final double yearlyPremium;
  final String description;
  final bool isActive;

  const InsurancePlan({
    required this.planName,
    required this.insuranceType,
    required this.coverageAmount,
    required this.monthlyPremium,
    required this.yearlyPremium,
    required this.description,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        planName,
        insuranceType,
        coverageAmount,
        monthlyPremium,
        yearlyPremium,
        description,
        isActive,
      ];

  Map<String, dynamic> toMap() {
    return {
      'planName': planName,
      'insuranceType': insuranceType,
      'coverageAmount': coverageAmount,
      'monthlyPremium': monthlyPremium,
      'yearlyPremium': yearlyPremium,
      'description': description,
      'isActive': isActive,
    };
  }
}
