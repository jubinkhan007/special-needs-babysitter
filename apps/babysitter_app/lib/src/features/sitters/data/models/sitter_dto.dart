import 'package:json_annotation/json_annotation.dart';

part 'sitter_dto.g.dart';

@JsonSerializable()
class BrowseSittersResponseDto {
  @JsonKey(defaultValue: false)
  final bool success;
  final BrowseSittersDataDto data;

  BrowseSittersResponseDto({required this.success, required this.data});

  factory BrowseSittersResponseDto.fromJson(Map<String, dynamic> json) =>
      _$BrowseSittersResponseDtoFromJson(json);
}

@JsonSerializable()
class BrowseSittersDataDto {
  final List<SitterDto> sitters;
  final int total;
  final int limit;
  final int offset;
  @JsonKey(defaultValue: false)
  final bool hasMore;

  BrowseSittersDataDto({
    required this.sitters,
    required this.total,
    required this.limit,
    required this.offset,
    required this.hasMore,
  });

  factory BrowseSittersDataDto.fromJson(Map<String, dynamic> json) =>
      _$BrowseSittersDataDtoFromJson(json);
}

@JsonSerializable()
class SitterDto {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String photoUrl;
  final String bio;
  final double hourlyRate;
  final List<String> skills;
  final List<String> ageRanges;
  final String?
      address; // Nullable in example? No, string. But assume could be null.
  final double? distance; // Null in example
  final double reliabilityScore; // 100 in example
  final int reviewCount; // 0
  @JsonKey(defaultValue: false)
  final bool isSaved;

  SitterDto({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.photoUrl,
    required this.bio,
    required this.hourlyRate,
    required this.skills,
    required this.ageRanges,
    this.address,
    this.distance,
    required this.reliabilityScore,
    required this.reviewCount,
    required this.isSaved,
  });

  factory SitterDto.fromJson(Map<String, dynamic> json) =>
      _$SitterDtoFromJson(json);
}
