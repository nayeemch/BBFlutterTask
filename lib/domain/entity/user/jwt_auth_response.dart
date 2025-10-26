import 'package:json_annotation/json_annotation.dart';

part 'jwt_auth_response.g.dart';

/// Represents the response returned by the BuddyBoss JWT Login API.
///
/// Example endpoint:
/// `https://nayeem.ue1.developbb.dev/wp-json/buddyboss-app/auth/v2/jwt/login`
///
/// Example response:
/// ```json
/// {
///   "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..",
///   "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
///   "user_display_name": "Nayeem",
///   "user_nicename": "nayeem",
///   "user_email": "nayeem@buddyboss.com",
///   "user_id": "2"
/// }
/// ```

@JsonSerializable()
class JwtAuthResponse {
  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  @JsonKey(name: 'user_display_name')
  final String userDisplayName;

  @JsonKey(name: 'user_nicename')
  final String userNicename;

  @JsonKey(name: 'user_email')
  final String userEmail;

  @JsonKey(name: 'user_id')
  final String userId;

  const JwtAuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userDisplayName,
    required this.userNicename,
    required this.userEmail,
    required this.userId,
  });

  /// Creates an instance from JSON.
  factory JwtAuthResponse.fromJson(Map<String, dynamic> json) =>
      _$JwtAuthResponseFromJson(json);

  /// Converts the instance back to JSON.
  Map<String, dynamic> toJson() => _$JwtAuthResponseToJson(this);
}
