import 'package:flutter/material.dart';
import '../../../parent/search/models/sitter_list_item_model.dart';
import '../../../parent/home/presentation/models/home_mock_models.dart';
import '../datasources/sitters_remote_datasource.dart';
import '../../domain/sitters_repository.dart';
import '../models/sitter_dto.dart';
import '../models/sitter_profile_dto.dart';
import '../models/review_dto.dart';

class SittersRepositoryImpl implements SittersRepository {
  final SittersRemoteDataSource _remoteDataSource;

  SittersRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<SitterListItemModel>> fetchSitters({
    required double latitude,
    required double longitude,
    int limit = 20,
    int offset = 0,
    int? maxDistance,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? name,
    List<String>? skills,
    double? minRate,
    double? maxRate,
    String? location,
  }) async {
    final dtos = await _remoteDataSource.fetchSitters(
      latitude: latitude,
      longitude: longitude,
      limit: limit,
      offset: offset,
      maxDistance: maxDistance,
      date: date,
      startTime: startTime,
      endTime: endTime,
      name: name,
      skills: skills,
      minRate: minRate,
      maxRate: maxRate,
      location: location,
    );
    return dtos.map(_mapToSitterListItem).toList();
  }

  @override
  Future<SitterModel> getSitterDetails(String id) async {
    // Fetch profile and reviews in parallel
    final results = await Future.wait([
      _remoteDataSource.getSitterDetails(id),
      _remoteDataSource.fetchReviews(id),
    ]);

    final dto = results[0] as SitterProfileDto;
    final reviewDtos = results[1] as List<ReviewDto>;

    return _mapToSitterModel(dto, reviewDtos: reviewDtos);
  }

  @override
  Future<void> bookmarkSitter(String sitterId) async {
    return _remoteDataSource.bookmarkSitter(sitterId);
  }

  @override
  Future<void> removeBookmarkedSitter(String sitterUserId) async {
    return _remoteDataSource.removeBookmarkedSitter(sitterUserId);
  }

  @override
  Future<List<SitterListItemModel>> getSavedSitters() async {
    final dtos = await _remoteDataSource.getSavedSitters();
    return dtos.map(_mapToSitterListItem).toList();
  }

  SitterListItemModel _mapToSitterListItem(SitterDto dto) {
    return SitterListItemModel(
      id: dto.id, // Using SitterProfile ID (uuid)
      userId: dto.userId, // Map the User ID
      name: dto.firstName, // Just first name per design
      imageAssetPath: dto
          .photoUrl, // It's a URL, but field name is imageAssetPath. We fixed consumers to handle URLs.
      isVerified:
          true, // Assuming true for now. DTO doesn't have it explicitly yet.
      rating: 0.0, // Default 0 as reviewCount is 0 in example
      distanceText:
          '${dto.distance?.toStringAsFixed(1) ?? "1.2"} Miles Away', // Fallback or real value
      responseRate: 100, // DTO reliabilityScore is 100
      reliabilityRate: dto.reliabilityScore.toInt(),
      experienceYears:
          5, // Hardcoded or extracted from bio? API doesn't have it explicitly in browse model maybe?
      tags: dto.skills,
      hourlyRate: dto.hourlyRate,
    );
  }

  SitterModel _mapToSitterModel(SitterProfileDto dto,
      {List<ReviewDto>? reviewDtos}) {
    // Use provided reviewDtos or fall back to embedded reviews
    final reviews = reviewDtos
            ?.map((r) => ReviewModel(
                  id: r.id,
                  authorName: r.reviewer?.displayName ?? 'Anonymous',
                  authorAvatarUrl: r.reviewer?.profilePhotoUrl ?? '',
                  rating: r.rating,
                  comment: r.reviewText,
                  date: r.createdAt ?? DateTime.now(),
                ))
            .toList() ??
        dto.reviews?.map((r) {
          // Fallback: parse embedded reviews
          final map = r as Map<String, dynamic>;
          final reviewDto = ReviewDto.fromJson(map);
          return ReviewModel(
            id: reviewDto.id,
            authorName: reviewDto.reviewer?.displayName ?? 'Anonymous',
            authorAvatarUrl: reviewDto.reviewer?.profilePhotoUrl ?? '',
            rating: reviewDto.rating,
            comment: reviewDto.reviewText,
            date: reviewDto.createdAt ?? DateTime.now(),
          );
        }).toList() ??
        [];

    return SitterModel(
      id: dto.id,
      userId: dto.userId,
      name: dto.firstName,
      avatarUrl: dto.photoUrl ?? '',
      isVerified: true, // Assuming true
      rating: dto.avgRating,
      location: dto.address ??
          '${dto.distance?.toStringAsFixed(1) ?? "1.2"} Miles Away',
      distance: '${dto.distance?.toStringAsFixed(1) ?? "1.2"} Miles',
      responseRate:
          100, // Not in profile DTO directly? reliabilityScore is there.
      reliabilityRate: dto.reliabilityScore.toInt(),
      experienceYears: _parseExperience(dto.yearsOfExperience ?? '1'),
      hourlyRate: dto.hourlyRate,
      badges: dto.skills, // Using skills as badges
      bio: dto.bio ?? "No bio available.",
      reviews: reviews,
      availability: dto.availability ?? [],
      languages: dto.languages,
      certifications: dto.certifications,
      willingToTravel: dto.willingToTravel ?? false,
      travelRadius: dto.travelRadiusMiles != null
          ? 'Up to ${dto.travelRadiusMiles!.toInt()} km'
          : null,
      hasTransportation: dto.hasTransportation,
      transportationType: dto.transportationType,
      jobTypesAccepted: dto.jobTypesAccepted ?? {},
      openToNegotiating: dto.openToNegotiating ?? false,
      ageRanges: dto.ageRanges,
    );
  }

  int _parseExperience(String experience) {
    // "1-2 years" attempt to parse. Return 1 if fails.
    try {
      final parts = experience.split(' ');
      if (parts.isNotEmpty) {
        final range = parts[0].split('-');
        if (range.isNotEmpty) {
          return int.parse(range[0]);
        }
      }
      return 1;
    } catch (e) {
      return 1;
    }
  }

  @override
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    return _remoteDataSource.getUserProfile(userId);
  }
}
