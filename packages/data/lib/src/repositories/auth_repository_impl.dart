import 'dart:async';

import 'package:domain/domain.dart';

import '../datasources/auth_remote_datasource.dart';
import '../mappers/auth_mappers.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final Future<void> Function(AuthSession?) _onSessionChanged;
  final Future<AuthSession?> Function() _getStoredSession;

  final _authStateController = StreamController<AuthSession?>.broadcast();
  AuthSession? _currentSession;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required Future<void> Function(AuthSession?) onSessionChanged,
    required Future<AuthSession?> Function() getStoredSession,
  })  : _remoteDataSource = remoteDataSource,
        _onSessionChanged = onSessionChanged,
        _getStoredSession = getStoredSession;

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final dto = await _remoteDataSource.signIn(
      email: email,
      password: password,
    );
    final session = AuthMappers.authSessionFromDto(dto);
    await _updateSession(session);
    return session;
  }

  @override
  Future<AuthSession> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
  }) async {
    final dto = await _remoteDataSource.signUp(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
    final session = AuthMappers.authSessionFromDto(dto);
    await _updateSession(session);
    return session;
  }

  @override
  Future<void> signOut() async {
    try {
      await _remoteDataSource.signOut();
    } finally {
      await _updateSession(null);
    }
  }

  @override
  Future<AuthSession> refreshToken(String refreshToken) async {
    final dto = await _remoteDataSource.refreshToken(refreshToken);
    final session = AuthMappers.authSessionFromDto(dto);
    await _updateSession(session);
    return session;
  }

  @override
  Future<AuthSession?> getCurrentSession() async {
    if (_currentSession != null) return _currentSession;
    _currentSession = await _getStoredSession();
    return _currentSession;
  }

  @override
  Stream<AuthSession?> get authStateChanges => _authStateController.stream;

  Future<void> _updateSession(AuthSession? session) async {
    _currentSession = session;
    await _onSessionChanged(session);
    _authStateController.add(session);
  }

  void dispose() {
    _authStateController.close();
  }
}

/// Fake implementation for development without backend
class FakeAuthRepositoryImpl implements AuthRepository {
  final Future<void> Function(AuthSession?, {User? user}) _onSessionChanged;
  final Future<AuthSession?> Function() _getStoredSession;

  final _authStateController = StreamController<AuthSession?>.broadcast();
  AuthSession? _currentSession;

  FakeAuthRepositoryImpl({
    required Future<void> Function(AuthSession?, {User? user}) onSessionChanged,
    required Future<AuthSession?> Function() getStoredSession,
  })  : _onSessionChanged = onSessionChanged,
        _getStoredSession = getStoredSession;

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // For fake signin, we assume role from cached profile
    // In real impl, we'd fetch profile after signin
    final user = User(
      id: 'fake-user-id',
      email: email,
      firstName: 'Test',
      lastName: 'User',
      role:
          UserRole.parent, // Default for signin - real would come from profile
      isProfileComplete: true,
      isSitterApproved: false,
      createdAt: DateTime.now(),
    );

    final session = AuthSession(
      user: user,
      accessToken: 'fake-access-token-${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'fake-refresh-token',
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );
    await _updateSession(session, user: user);
    return session;
  }

  @override
  Future<AuthSession> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required UserRole role,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final user = User(
      id: 'fake-user-id-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      firstName: firstName,
      lastName: lastName,
      role: role,
      isProfileComplete: false,
      isSitterApproved: false,
      createdAt: DateTime.now(),
    );

    final session = AuthSession(
      user: user,
      accessToken: 'fake-access-token-${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'fake-refresh-token',
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );
    await _updateSession(session, user: user);
    return session;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _updateSession(null);
  }

  @override
  Future<AuthSession> refreshToken(String refreshToken) async {
    final current = _currentSession;
    if (current == null) {
      throw Exception('No session to refresh');
    }

    final session = current.copyWith(
      accessToken: 'fake-access-token-${DateTime.now().millisecondsSinceEpoch}',
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );
    await _updateSession(session);
    return session;
  }

  @override
  Future<AuthSession?> getCurrentSession() async {
    if (_currentSession != null) return _currentSession;
    _currentSession = await _getStoredSession();
    return _currentSession;
  }

  @override
  Stream<AuthSession?> get authStateChanges => _authStateController.stream;

  Future<void> _updateSession(AuthSession? session, {User? user}) async {
    _currentSession = session;
    await _onSessionChanged(session, user: user);
    _authStateController.add(session);
  }

  void dispose() {
    _authStateController.close();
  }
}
