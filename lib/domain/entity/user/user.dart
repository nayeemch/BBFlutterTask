import 'package:json_annotation/json_annotation.dart';
import 'jwt_auth_response.dart';

part 'user.g.dart';

/// Represents an authenticated user in the app.

@JsonSerializable()
class User {
  final String? accessToken;
  final String? refreshToken;
  final String? userDisplayName;
  final String? userNicename;
  final String? userEmail;
  final String? userId;

  const User({
    this.accessToken,
    this.refreshToken,
    this.userDisplayName,
    this.userNicename,
    this.userEmail,
    this.userId,
  });

  /// Create an User instance from a JSON map.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Convert an User instance to JSON.
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// Create an User instance from a JwtAuthResponse
  factory User.fromJwtAuthResponse(JwtAuthResponse jwtResponse) {
    return User(
      accessToken: jwtResponse.accessToken,
      refreshToken: jwtResponse.refreshToken,
      userDisplayName: jwtResponse.userDisplayName,
      userNicename: jwtResponse.userNicename,
      userEmail: jwtResponse.userEmail,
      userId: jwtResponse.userId,
    );
  }
}
