import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/models/booking_session_model.dart';
import '../../data/sources/booking_session_local_datasource.dart';
import '../../domain/repositories/bookings_repository.dart';
import '../../../jobs/data/models/job_coordinates_model.dart';

class SessionTrackingState {
  final BookingSessionModel? session;
  final bool isLoading;
  final bool isTracking;
  final String? errorMessage;
  final String? locationWarning;
  final DateTime? lastLocationAt;

  const SessionTrackingState({
    this.session,
    this.isLoading = false,
    this.isTracking = false,
    this.errorMessage,
    this.locationWarning,
    this.lastLocationAt,
  });

  SessionTrackingState copyWith({
    BookingSessionModel? session,
    bool? isLoading,
    bool? isTracking,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? locationWarning,
    bool clearLocationWarning = false,
    DateTime? lastLocationAt,
  }) {
    return SessionTrackingState(
      session: session ?? this.session,
      isLoading: isLoading ?? this.isLoading,
      isTracking: isTracking ?? this.isTracking,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      locationWarning:
          clearLocationWarning ? null : (locationWarning ?? this.locationWarning),
      lastLocationAt: lastLocationAt ?? this.lastLocationAt,
    );
  }

  bool get hasActiveSession =>
      session != null && session!.applicationId.isNotEmpty;

  List<JobCoordinatesModel> get routeCoordinates =>
      session?.routeCoordinates ?? const [];

  JobCoordinatesModel? get currentLocation =>
      routeCoordinates.isNotEmpty ? routeCoordinates.last : null;
}

class SessionTrackingController extends StateNotifier<SessionTrackingState> {
  SessionTrackingController(this._repository, this._localDataSource)
      : super(const SessionTrackingState());

  final BookingsRepository _repository;
  final BookingSessionLocalDataSource _localDataSource;
  StreamSubscription<Position>? _positionSub;
  bool _pendingStart = false;
  DateTime? _lastLocationSentAt;
  static const Duration _locationSendInterval = Duration(minutes: 2);

  Future<void> restoreSession() async {
    final cached = await _localDataSource.readSession();
    if (cached == null) {
      return;
    }
    state = state.copyWith(session: cached);
    await _startLocationTracking();
    unawaited(refreshSession());
  }

  Future<void> loadSession(String applicationId,
      {bool forceRefresh = false}) async {
    final existing = state.session;
    if (!forceRefresh &&
        existing != null &&
        existing.applicationId == applicationId) {
      await _startLocationTracking();
      return;
    }

    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    try {
      final session = await _repository.getBookingSession(applicationId);
      final cached = await _localDataSource.readSession();
      final mergedRoute = _mergeRoute(
        session.routeCoordinates,
        cached != null && cached.applicationId == applicationId
            ? cached.routeCoordinates
            : const [],
      );
      final mergedSession = session.copyWith(routeCoordinates: mergedRoute);
      state = state.copyWith(
        session: mergedSession,
        isLoading: false,
        clearErrorMessage: true,
      );
      await _localDataSource.saveSession(mergedSession);
      await _startLocationTracking();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> refreshSession() async {
    final applicationId = state.session?.applicationId;
    if (applicationId == null || applicationId.isEmpty) {
      return;
    }
    await loadSession(applicationId, forceRefresh: true);
  }

  Future<void> stopSession() async {
    await _stopLocationTracking();
    await _localDataSource.clearSession();
    state = const SessionTrackingState();
  }

  void togglePause({String? breakReason}) {
    final session = state.session;
    if (session == null) {
      return;
    }

    if (session.isPaused) {
      final pausedAt = session.pausedAt ?? DateTime.now();
      final addedSeconds =
          DateTime.now().difference(pausedAt).inSeconds;
      final updatedSession = session.copyWith(
        isPaused: false,
        pausedAt: null,
        totalPausedDurationSeconds:
            session.totalPausedDurationSeconds + addedSeconds,
        currentBreakReason: null,
      );
      state = state.copyWith(session: updatedSession);
      unawaited(_localDataSource.saveSession(updatedSession));
      return;
    }

    final updatedSession = session.copyWith(
      isPaused: true,
      pausedAt: DateTime.now(),
      currentBreakReason: breakReason ?? session.currentBreakReason,
    );
    state = state.copyWith(session: updatedSession);
    unawaited(_localDataSource.saveSession(updatedSession));
  }

  Future<void> _startLocationTracking() async {
    if (_positionSub != null || !state.hasActiveSession) {
      return;
    }

    if (!_isAppResumed()) {
      _pendingStart = true;
      state = state.copyWith(
        locationWarning:
            'Open the app to start live tracking for this booking.',
      );
      return;
    }

    final permission = await _ensureLocationPermission();
    if (!permission) {
      return;
    }

    try {
      final settings = _buildLocationSettings();
      _positionSub = Geolocator.getPositionStream(
        locationSettings: settings,
      ).listen(
        _handlePositionUpdate,
        onError: (error) {
          state = state.copyWith(
            isTracking: false,
            errorMessage: 'Live tracking error: $error',
          );
        },
      );
      state = state.copyWith(isTracking: true);
    } catch (e) {
      state = state.copyWith(
        isTracking: false,
        errorMessage: 'Live tracking error: $e',
      );
    }
  }

  Future<void> _stopLocationTracking() async {
    await _positionSub?.cancel();
    _positionSub = null;
    state = state.copyWith(isTracking: false);
  }

  void handleAppLifecycle(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _pendingStart) {
      _pendingStart = false;
      unawaited(_startLocationTracking());
    }
  }

  void _handlePositionUpdate(Position position) {
    final point = JobCoordinatesModel(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    if (_shouldRecord(point)) {
      final session = state.session;
      if (session == null) {
        return;
      }

      final updatedRoute = [...session.routeCoordinates, point];
      final updatedSession = session.copyWith(routeCoordinates: updatedRoute);
      state = state.copyWith(
        session: updatedSession,
        lastLocationAt: DateTime.now(),
      );
      unawaited(_localDataSource.saveSession(updatedSession));
    }

    _maybeSendLocation(point);
  }

  void _maybeSendLocation(JobCoordinatesModel point) {
    final now = DateTime.now();
    if (_lastLocationSentAt != null &&
        now.difference(_lastLocationSentAt!) < _locationSendInterval) {
      return;
    }

    final applicationId = state.session?.applicationId;
    if (applicationId == null || applicationId.isEmpty) {
      return;
    }

    _lastLocationSentAt = now;
    unawaited(_repository
        .postBookingLocation(
          applicationId,
          latitude: point.latitude,
          longitude: point.longitude,
        )
        .catchError((error) {
      state = state.copyWith(
        errorMessage: 'Live tracking error: $error',
      );
    }));
  }

  bool _shouldRecord(JobCoordinatesModel nextPoint) {
    final last = state.currentLocation;
    if (last == null) {
      return true;
    }
    final distance = Geolocator.distanceBetween(
      last.latitude,
      last.longitude,
      nextPoint.latitude,
      nextPoint.longitude,
    );
    return distance >= 8;
  }

  List<JobCoordinatesModel> _mergeRoute(
    List<JobCoordinatesModel> serverPoints,
    List<JobCoordinatesModel> localPoints,
  ) {
    if (localPoints.isEmpty) {
      return serverPoints;
    }
    if (serverPoints.isEmpty) {
      return localPoints;
    }
    final merged = [...serverPoints];
    for (final point in localPoints) {
      if (!_containsPoint(merged, point)) {
        merged.add(point);
      }
    }
    return merged;
  }

  bool _containsPoint(
    List<JobCoordinatesModel> points,
    JobCoordinatesModel candidate,
  ) {
    for (final point in points) {
      final latDiff = (point.latitude - candidate.latitude).abs();
      final lngDiff = (point.longitude - candidate.longitude).abs();
      if (latDiff < 0.00001 && lngDiff < 0.00001) {
        return true;
      }
    }
    return false;
  }

  Future<bool> _ensureLocationPermission() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      state = state.copyWith(
        isTracking: false,
        locationWarning:
            'Location services are disabled. Enable them to share live tracking.',
      );
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      state = state.copyWith(
        isTracking: false,
        locationWarning:
            'Location permission is denied. Enable it in Settings to continue live tracking.',
      );
      return false;
    }

    if (permission == LocationPermission.whileInUse) {
      final upgraded = await Geolocator.requestPermission();
      permission = upgraded;
    }

    if (permission == LocationPermission.whileInUse) {
      state = state.copyWith(
        locationWarning:
            'Background location is not enabled. Live tracking may pause when the app is not active.',
      );
    } else {
      state = state.copyWith(clearLocationWarning: true);
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  LocationSettings _buildLocationSettings() {
    if (kIsWeb) {
      return const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
      );
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
        intervalDuration: _locationSendInterval,
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'Special Needs Sitters',
          notificationText: 'Live tracking is active during your booking.',
          enableWakeLock: true,
          setOngoing: true,
        ),
      );
    }

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return AppleSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: true,
        allowBackgroundLocationUpdates: true,
      );
    }

    return const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10,
    );
  }

  bool _isAppResumed() {
    final lifecycleState = WidgetsBinding.instance.lifecycleState;
    return lifecycleState == null ||
        lifecycleState == AppLifecycleState.resumed;
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }
}
