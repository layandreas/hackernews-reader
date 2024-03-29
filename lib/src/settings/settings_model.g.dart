// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FontSettingsModelImpl _$$FontSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FontSettingsModelImpl(
      textScaleFactor: (json['textScaleFactor'] as num).toDouble(),
    );

Map<String, dynamic> _$$FontSettingsModelImplToJson(
        _$FontSettingsModelImpl instance) =>
    <String, dynamic>{
      'textScaleFactor': instance.textScaleFactor,
    };

_$ThemeSettingsModelImpl _$$ThemeSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ThemeSettingsModelImpl(
      theme: $enumDecode(_$ThemeSettingEnumMap, json['theme']),
      defaultLightTheme:
          $enumDecode(_$DefaultThemeEnumMap, json['defaultLightTheme']),
      defaultDarkTheme:
          $enumDecode(_$DefaultThemeEnumMap, json['defaultDarkTheme']),
    );

Map<String, dynamic> _$$ThemeSettingsModelImplToJson(
        _$ThemeSettingsModelImpl instance) =>
    <String, dynamic>{
      'theme': _$ThemeSettingEnumMap[instance.theme]!,
      'defaultLightTheme': _$DefaultThemeEnumMap[instance.defaultLightTheme]!,
      'defaultDarkTheme': _$DefaultThemeEnumMap[instance.defaultDarkTheme]!,
    };

const _$ThemeSettingEnumMap = {
  ThemeSetting.system: 'system',
  ThemeSetting.light: 'light',
  ThemeSetting.dark: 'dark',
  ThemeSetting.darker: 'darker',
  ThemeSetting.oledDark: 'oledDark',
  ThemeSetting.blue: 'blue',
};

const _$DefaultThemeEnumMap = {
  DefaultTheme.light: 'light',
  DefaultTheme.dark: 'dark',
  DefaultTheme.oledDark: 'oledDark',
  DefaultTheme.darker: 'darker',
  DefaultTheme.blue: 'blue',
};

_$SettingsModelImpl _$$SettingsModelImplFromJson(Map<String, dynamic> json) =>
    _$SettingsModelImpl(
      themeSettings: ThemeSettingsModel.fromJson(
          json['themeSettings'] as Map<String, dynamic>),
      fontSettings: FontSettingsModel.fromJson(
          json['fontSettings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SettingsModelImplToJson(_$SettingsModelImpl instance) =>
    <String, dynamic>{
      'themeSettings': instance.themeSettings.toJson(),
      'fontSettings': instance.fontSettings.toJson(),
    };
