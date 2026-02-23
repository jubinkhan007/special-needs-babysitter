import 'package:equatable/equatable.dart';
import 'package:babysitter_app/src/packages/domain/entities/user.dart';

/// Entity representing the account overview data
class AccountOverview extends Equatable {
  final User user;
  final int bookingHistoryCount;
  final int savedSittersCount;
  final double profileCompletionPercent; // 0.0 to 1.0

  const AccountOverview({
    required this.user,
    required this.bookingHistoryCount,
    required this.savedSittersCount,
    required this.profileCompletionPercent,
  });

  @override
  List<Object?> get props => [
        user,
        bookingHistoryCount,
        savedSittersCount,
        profileCompletionPercent,
      ];
}
