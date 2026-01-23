import 'package:flutter/material.dart';
import '../../../parent/search/models/sitter_list_item_model.dart';
import '../../../parent/home/presentation/models/home_mock_models.dart';
import '../datasources/sitters_remote_datasource.dart';
import '../../domain/sitters_repository.dart';
import '../models/sitter_dto.dart';
import '../models/sitter_profile_dto.dart';

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
    final dto = await _remoteDataSource.getSitterDetails(id);
    return _mapToSitterModel(dto);
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

  SitterModel _mapToSitterModel(SitterProfileDto dto) {
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
      reviews: dto.reviews?.map((r) {
            // Defensive parsing since reviews list structure isn't strictly defined in DTO type (List<dynamic>)
            final map = r as Map<String, dynamic>;
            final user = map['user'] as Map<String, dynamic>?;
            return ReviewModel(
              id: map['id'] ?? '',
              authorName: user?['firstName'] ?? 'Anonymous',
              authorAvatarUrl: user?['photoUrl'] ?? '',
              rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
              comment: map['comment'] ?? '',
              date: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
            );
          }).toList() ??
          [],
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
}
