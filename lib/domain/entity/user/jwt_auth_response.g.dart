// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jwt_auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwtAuthResponse _$JwtAuthResponseFromJson(Map<String, dynamic> json) =>
    JwtAuthResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      userDisplayName: json['user_display_name'] as String,
      userNicename: json['user_nicename'] as String,
      userEmail: json['user_email'] as String,
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$JwtAuthResponseToJson(JwtAuthResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'user_display_name': instance.userDisplayName,
      'user_nicename': instance.userNicename,
      'user_email': instance.userEmail,
      'user_id': instance.userId,
    };
