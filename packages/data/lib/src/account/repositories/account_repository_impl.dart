import 'package:domain/domain.dart';
import '../datasources/account_remote_datasource.dart';

/// Implementation of AccountRepository
class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource _remoteDataSource;
  final ProfileRepository _profileRepository;

  AccountRepositoryImpl(this._remoteDataSource, this._profileRepository);

  @override
  Future<AccountOverview> getAccountOverview(String userId) async {
    // 1. Fetch fresh user profile
    final user = await _profileRepository.getMe();
    print(
        'DEBUG: AccountRepo user firstName: ${user.firstName}, lastName: ${user.lastName}');

    // 2. Fetch stats (mocked in datasource)
    final stats = await _remoteDataSource.getAccountStats(userId);
    print('DEBUG: AccountRepo stats: $stats');

    // 3. Calculate profile completion (logic could be more complex)
    double completion = 0.0;
    if (user.firstName != null) completion += 0.2;
    if (user.lastName != null) completion += 0.2;
    if (user.avatarUrl != null) completion += 0.2;
    if (user.phoneNumber != null) completion += 0.2;
    if (user.isProfileComplete) completion = 1.0; // Trust the flag if true

    // Fallback to 60% as per design/mock if calculation is low?
    final effectiveCompletion = completion > 0 ? completion : 0.60;

    final overview = AccountOverview(
      user: user,
      bookingHistoryCount: stats['bookingHistoryCount'] as int? ?? 0,
      savedSittersCount: stats['savedSittersCount'] as int? ?? 0,
      profileCompletionPercent: effectiveCompletion,
    );
    print('DEBUG: AccountRepo mapping overview successful');
    return overview;
  }
}
