import 'package:domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_init_dto.g.dart';

@JsonSerializable()
class ChatInitDto {
  final String agoraUsername;
  final String agoraToken;

  ChatInitDto({
    required this.agoraUsername,
    required this.agoraToken,
  });

  factory ChatInitDto.fromJson(Map<String, dynamic> json) =>
      _$ChatInitDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatInitDtoToJson(this);

  ChatInitResult toDomain() {
    return ChatInitResult(
      agoraUsername: agoraUsername,
      agoraToken: agoraToken,
    );
  }
}
