import 'package:equatable/equatable.dart';
import 'package:domain/domain.dart';

class SitterAccountOverview extends Equatable {
  final User user;
  final int completedJobsCount;
  final int savedJobsCount;
  final double profileCompletionPercent; // 0.0 to 1.0

  const SitterAccountOverview({
    required this.user,
    required this.completedJobsCount,
    required this.savedJobsCount,
    required this.profileCompletionPercent,
  });

  @override
  List<Object?> get props => [
        user,
        completedJobsCount,
        savedJobsCount,
        profileCompletionPercent,
      ];
}

class SitterAccountState extends Equatable {
  final SitterAccountOverview? overview;
  final bool isLoading;
  final String? errorMessage;

  const SitterAccountState({
    this.overview,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [overview, isLoading, errorMessage];

  SitterAccountState copyWith({
    SitterAccountOverview? overview,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SitterAccountState(
      overview: overview ?? this.overview,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
