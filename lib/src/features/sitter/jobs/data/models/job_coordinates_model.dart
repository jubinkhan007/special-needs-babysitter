import 'package:equatable/equatable.dart';

/// Model representing job location coordinates
class JobCoordinatesModel extends Equatable {
  final double latitude;
  final double longitude;

  const JobCoordinatesModel({
    required this.latitude,
    required this.longitude,
  });

  factory JobCoordinatesModel.fromJson(Map<String, dynamic> json) {
    return JobCoordinatesModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  List<Object?> get props => [latitude, longitude];
}
