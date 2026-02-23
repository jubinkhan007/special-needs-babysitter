import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babysitter_app/src/packages/data/data.dart';
import 'package:babysitter_app/src/packages/domain/domain.dart';
import 'package:babysitter_app/src/packages/auth/auth.dart'; // For authDioProvider, profileRepositoryProvider

// Remote DataSource
final accountRemoteDataSourceProvider = Provider<AccountRemoteDataSource>((
  ref,
) {
  return AccountRemoteDataSource(ref.watch(authDioProvider));
});

// Repository
final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepositoryImpl(
    ref.watch(accountRemoteDataSourceProvider),
    ref.watch(profileRepositoryProvider),
  );
});

// Use Case
final getAccountOverviewUseCaseProvider = Provider<GetAccountOverviewUseCase>((
  ref,
) {
  return GetAccountOverviewUseCase(ref.watch(accountRepositoryProvider));
});
