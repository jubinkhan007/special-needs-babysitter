import 'package:equatable/equatable.dart';

/// Model representing a child in a job request
class JobChildModel extends Equatable {
  final String firstName;
  final int age;

  const JobChildModel({
    required this.firstName,
    required this.age,
  });

  factory JobChildModel.fromJson(Map<String, dynamic> json) {
    return JobChildModel(
      firstName: json['firstName'] as String,
      age: json['age'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'age': age,
    };
  }

  @override
  List<Object?> get props => [firstName, age];
}
