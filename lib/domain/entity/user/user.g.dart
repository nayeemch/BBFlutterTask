// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      userDisplayName: json['userDisplayName'] as String?,
      userNicename: json['userNicename'] as String?,
      userEmail: json['userEmail'] as String?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'userDisplayName': instance.userDisplayName,
      'userNicename': instance.userNicename,
      'userEmail': instance.userEmail,
      'userId': instance.userId,
    };
