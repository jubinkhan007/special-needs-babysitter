import 'package:domain/domain.dart';

import '../datasources/profile_remote_datasource.dart';
import '../mappers/auth_mappers.dart';

/// Implementation of ProfileRepository
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<User> getMe() async {
    final dto = await _remoteDataSource.getMe();
    return AuthMappers.userFromDto(dto);
  }

  @override
  Future<User> updateProfile(UpdateProfileParams params) async {
    final dto = await _remoteDataSource.updateProfile(params);
    return AuthMappers.userFromDto(dto);
  }
}

/// Fake implementation for development without backend
class FakeProfileRepositoryImpl implements ProfileRepository {
  User? _cachedUser;

  FakeProfileRepositoryImpl();

  /// Set the cached user (called after signup/signin to store user info)
  void setCachedUser(User user) {
    _cachedUser = user;
  }

  @override
  Future<User> getMe() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (_cachedUser != null) {
      return _cachedUser!;
    }

    // Return mock user if no cached user
    return const User(
      id: 'mock-user-id',
      email: 'user@example.com',
      firstName: 'Test',
      lastName: 'User',
      role: UserRole.parent,
      isProfileComplete: false,
      isSitterApproved: false,
    );
  }

  @override
  Future<User> updateProfile(UpdateProfileParams params) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (_cachedUser == null) {
      throw Exception('No user to update');
    }

    _cachedUser = _cachedUser!.copyWith(
      firstName: params.firstName ?? _cachedUser!.firstName,
      lastName: params.lastName ?? _cachedUser!.lastName,
      phoneNumber: params.phoneNumber ?? _cachedUser!.phoneNumber,
      avatarUrl: params.avatarUrl ?? _cachedUser!.avatarUrl,
    );

    return _cachedUser!;
  }
}
