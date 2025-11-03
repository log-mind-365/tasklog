// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoriesStreamHash() => r'bd62a365dbad62d8bc7deaf20b8dda080ef27ae6';

/// See also [categoriesStream].
@ProviderFor(categoriesStream)
final categoriesStreamProvider =
    AutoDisposeStreamProvider<List<CategoryEntity>>.internal(
      categoriesStream,
      name: r'categoriesStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoriesStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoriesStreamRef =
    AutoDisposeStreamProviderRef<List<CategoryEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
