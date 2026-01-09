import 'package:equatable/equatable.dart';
import 'package:domain/domain.dart'; // UserProfileDetails

class ProfileDetailsState extends Equatable {
  final UserProfileDetails? details;
  final bool isLoading;
  final String? errorMessage;

  const ProfileDetailsState({
    this.details,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [details, isLoading, errorMessage];

  ProfileDetailsState copyWith({
    UserProfileDetails? details,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileDetailsState(
      details: details ?? this.details,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
