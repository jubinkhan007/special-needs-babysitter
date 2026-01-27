import '../../domain/booking.dart';
import '../../domain/booking_details.dart';
import '../../domain/booking_location.dart';
import '../../domain/booking_status.dart';
import '../../domain/bookings_repository.dart';
import '../datasources/bookings_remote_datasource.dart';
import '../models/parent_booking_dto.dart';
import '../models/booking_details_dto.dart';
import '../models/booking_location_dto.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  final BookingsRemoteDataSource _remoteDataSource;

  BookingsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Booking>> getBookings() async {
    final dtos = await _remoteDataSource.getBookings();
    return dtos.map(_mapToEntity).toList();
  }

  @override
  Future<BookingDetails> getBookingDetails(String bookingId) async {
    final dto = await _remoteDataSource.getBookingDetails(bookingId);
    return _mapToDetailsEntity(dto);
  }

  @override
  Future<BookingLocation> getBookingLocation(String bookingId) async {
    final dto = await _remoteDataSource.getBookingLocation(bookingId);
    return _mapToLocationEntity(dto);
  }

  BookingDetails _mapToDetailsEntity(BookingDetailsDto dto) {
    // Safely parse dates
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now();
    DateTime startTime = DateTime.now();
    DateTime endTime = DateTime.now();
    DateTime? jobStartDateTime;

    if (dto.job?.startDate != null) {
      try {
        startDate = DateTime.parse(dto.job!.startDate!);
      } catch (_) {}
    }
    if (dto.job?.endDate != null) {
      try {
        endDate = DateTime.parse(dto.job!.endDate!);
      } catch (_) {}
    }

    // Time parsing (assuming HH:mm format usually, but let's parse safe)
    if (dto.job?.startTime != null) {
      // Just creating a DateTime with that time
      try {
        final parts = dto.job!.startTime!.split(':');
        startTime =
            DateTime(2000, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
        jobStartDateTime = DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
      } catch (_) {}
    }

    if (dto.job?.endTime != null) {
      try {
        final parts = dto.job!.endTime!.split(':');
        endTime =
            DateTime(2000, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
      } catch (_) {}
    }
    jobStartDateTime ??= startDate;

    // Map status string to enum (align with list logic)
    final rawStatus =
        dto.status.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');
    BookingStatus status;
    
    final now = DateTime.now();
    final isPast = jobStartDateTime != null && jobStartDateTime.isBefore(now);

    if (rawStatus == 'active' || rawStatus == 'inprogress') {
      status = BookingStatus.active;
    } else if (rawStatus == 'clockedout') {
      status = BookingStatus.clockedOut;
    } else if (rawStatus == 'pending' || rawStatus == 'directbooking') {
      status = BookingStatus.pending;
    } else if (rawStatus == 'declined' || rawStatus == 'cancelled') {
      status = BookingStatus.cancelled;
    } else if (rawStatus == 'accepted') {
      if (isPast) {
        status = BookingStatus.completed;
      } else {
        status = BookingStatus.upcoming;
      }
    } else if (rawStatus == 'completed' || rawStatus == 'expired') {
      status = BookingStatus.completed;
    } else if (rawStatus == 'upcoming') {
      status = BookingStatus.upcoming;
    } else {
      if (isPast) {
        status = BookingStatus.completed;
      } else {
        status = BookingStatus.upcoming;
      }
    }

    return BookingDetails(
      id: dto.id,
      sitterId: dto.sitter?.userId ?? '',
      sitterName:
          '${dto.sitter?.firstName ?? ''} ${dto.sitter?.lastName ?? ''}'.trim(),
      avatarUrl: dto.sitter?.photoUrl ?? 'https://via.placeholder.com/150',
      isVerified: true,
      rating: 5.0, // Placeholder
      responseRate: dto.sitter?.responseRate ?? 100,
      reliabilityRate: dto.sitter?.reliabilityScore ?? 100,
      experienceText: dto.sitter?.yearsOfExperience ?? 'N/A',
      distanceText: dto.sitter?.distance ?? 'Unknown',
      status: status,
      familyName: dto.family?.familyName ?? 'Unknown Family',
      numberOfChildren: dto.family?.childrenCount ?? 0,
      startDate: startDate,
      endDate: endDate,
      startTime: startTime,
      endTime: endTime,
      hourlyRate: dto.job?.payRate ?? 0,
      numberOfDays: dto.job?.numberOfDays ?? 1,
      additionalNotes: dto.job?.additionalDetails,
      address: dto.job?.fullAddress ?? dto.job?.location ?? 'Unknown Address',
      skills: dto.sitter?.skills ?? [],
    );
  }

  Booking _mapToEntity(ParentBookingDto dto) {
    // Safely parse date and time
    DateTime scheduledDate = DateTime.now();
    DateTime? jobStartDateTime;

    if (dto.job?.startDate != null) {
      try {
        scheduledDate = DateTime.parse(dto.job!.startDate!);

        // Try to combine with time if available
        if (dto.job?.startTime != null) {
          // startTime is likely "HH:MM"
          final timeParts = dto.job!.startTime!.split(':');
          if (timeParts.length == 2) {
            jobStartDateTime = DateTime(
              scheduledDate.year,
              scheduledDate.month,
              scheduledDate.day,
              int.parse(timeParts[0]),
              int.parse(timeParts[1]),
            );
          }
        }
        // Fallback to startDate if time parsing fails or is missing
        jobStartDateTime ??= scheduledDate;
      } catch (e) {
        print('DEBUG: Date parsing error for booking ${dto.id}: $e');
      }
    }

    // Map status string to enum with logic
    BookingStatus status;
    final rawStatus = dto.status.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');
    final now = DateTime.now();
    final isPast = jobStartDateTime != null && jobStartDateTime.isBefore(now);

    if (rawStatus == 'active' || rawStatus == 'inprogress') {
      status = BookingStatus.active;
    } else if (rawStatus == 'clockedout') {
      status = BookingStatus.clockedOut;
    } else if (rawStatus == 'pending' || rawStatus == 'directbooking') {
      status = BookingStatus.pending;
    } else if (rawStatus == 'declined' || rawStatus == 'cancelled') {
      status = BookingStatus.cancelled;
    } else if (rawStatus == 'accepted') {
      if (isPast) {
        status = BookingStatus.completed;
      } else {
        status = BookingStatus.upcoming;
      }
    } else if (rawStatus == 'completed' || rawStatus == 'expired') {
      status = BookingStatus.completed;
    } else {
      if (isPast) {
        status = BookingStatus.completed;
      } else {
        status = BookingStatus.upcoming;
      }
    }

    return Booking(
      id: dto.id,
      sitterId: dto.sitter?.userId ?? '',
      sitterName:
          '${dto.sitter?.firstName ?? ''} ${dto.sitter?.lastName ?? ''}'.trim(),
      distanceText: dto.job?.location ?? 'Unknown location',
      rating: 5.0, // API doesn't provide rating yet, use placeholder
      responseRate: 100, // Placeholder
      reliabilityRate: dto.sitter?.reliabilityScore ?? 100,
      experienceText: 'N/A', // Placeholder
      scheduledDate: scheduledDate,
      status: status,
      avatarAssetOrUrl:
          dto.sitter?.photoUrl ?? 'https://via.placeholder.com/150',
      isVerified: true,
    );
  }

  BookingLocation _mapToLocationEntity(BookingLocationDto dto) {
    BookingLocationPoint? mapPoint(BookingLocationPointDto? point) {
      if (point == null) {
        return null;
      }
      return BookingLocationPoint(
        latitude: point.latitude,
        longitude: point.longitude,
        timestamp: point.timestamp,
      );
    }

    return BookingLocation(
      currentLocation: mapPoint(dto.currentLocation),
      routeCoordinates: dto.routeCoordinates
          .map((point) => BookingLocationPoint(
                latitude: point.latitude,
                longitude: point.longitude,
                timestamp: point.timestamp,
              ))
          .toList(),
      distance: dto.distance,
      status: dto.status,
      isPaused: dto.isPaused,
      pausedAt: dto.pausedAt,
      currentBreakReason: dto.currentBreakReason,
      clockInTime: dto.clockInTime,
    );
  }
}
