// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$themeModeSettingHash() => r'c4315b18a34dd4aaa1ad67cff0a3bffbcb6669f4';

/// 테마 모드 설정 Provider
///
/// Copied from [ThemeModeSetting].
@ProviderFor(ThemeModeSetting)
final themeModeSettingProvider =
    AutoDisposeNotifierProvider<ThemeModeSetting, ThemeModeEnum>.internal(
      ThemeModeSetting.new,
      name: r'themeModeSettingProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$themeModeSettingHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ThemeModeSetting = AutoDisposeNotifier<ThemeModeEnum>;
String _$appLocaleHash() => r'768cb1a3d5aa68b53f05d5021090252991deb146';

/// 로케일 설정 Provider
///
/// Copied from [AppLocale].
@ProviderFor(AppLocale)
final appLocaleProvider =
    AutoDisposeNotifierProvider<AppLocale, flutter.Locale?>.internal(
      AppLocale.new,
      name: r'appLocaleProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$appLocaleHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AppLocale = AutoDisposeNotifier<flutter.Locale?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
