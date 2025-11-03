// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todosStreamHash() => r'690f2c634044c61dab3eb8136e3e43f65b9e568a';

/// See also [todosStream].
@ProviderFor(todosStream)
final todosStreamProvider =
    AutoDisposeStreamProvider<List<TodoEntity>>.internal(
      todosStream,
      name: r'todosStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todosStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodosStreamRef = AutoDisposeStreamProviderRef<List<TodoEntity>>;
String _$incompleteTodosStreamHash() =>
    r'238bf4c54d5967fe3b4aad4c27b66e0d5048cc7f';

/// See also [incompleteTodosStream].
@ProviderFor(incompleteTodosStream)
final incompleteTodosStreamProvider =
    AutoDisposeStreamProvider<List<TodoEntity>>.internal(
      incompleteTodosStream,
      name: r'incompleteTodosStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$incompleteTodosStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IncompleteTodosStreamRef =
    AutoDisposeStreamProviderRef<List<TodoEntity>>;
String _$completedTodosStreamHash() =>
    r'e5136cf87827dca8067a9ff3d66d27a45739baab';

/// See also [completedTodosStream].
@ProviderFor(completedTodosStream)
final completedTodosStreamProvider =
    AutoDisposeStreamProvider<List<TodoEntity>>.internal(
      completedTodosStream,
      name: r'completedTodosStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$completedTodosStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompletedTodosStreamRef =
    AutoDisposeStreamProviderRef<List<TodoEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
