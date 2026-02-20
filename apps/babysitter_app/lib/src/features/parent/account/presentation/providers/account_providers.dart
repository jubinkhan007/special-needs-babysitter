import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:auth/auth.dart'; // For authDioProvider, profileRepositoryProvider

// Remote DataSource
final accountRemoteDataSourceProvider =
    Provider<AccountRemoteDataSource>((ref) {
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
final getAccountOverviewUseCaseProvider =
    Provider<GetAccountOverviewUseCase>((ref) {
  return GetAccountOverviewUseCase(ref.watch(accountRepositoryProvider));
});
