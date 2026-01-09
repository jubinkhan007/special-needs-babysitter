import 'package:equatable/equatable.dart';
import 'package:domain/domain.dart';

class AccountState extends Equatable {
  final AccountOverview? overview;
  final bool isLoading;
  final String? errorMessage;

  const AccountState({
    this.overview,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [overview, isLoading, errorMessage];

  AccountState copyWith({
    AccountOverview? overview,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AccountState(
      overview: overview ?? this.overview,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
