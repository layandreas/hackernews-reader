// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginStateImpl _$$LoginStateImplFromJson(Map<String, dynamic> json) =>
    _$LoginStateImpl(
      user: json['user'] as String?,
      authCookieRequestHeader: json['authCookieRequestHeader'] as String?,
      isLoading: json['isLoading'] as bool,
      error: json['error'] as bool,
    );

Map<String, dynamic> _$$LoginStateImplToJson(_$LoginStateImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'authCookieRequestHeader': instance.authCookieRequestHeader,
      'isLoading': instance.isLoading,
      'error': instance.error,
    };