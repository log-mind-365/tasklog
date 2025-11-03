// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todosStreamHash() => r'f9e1b0a3892f45cb3a59accd9ac020e134aa7cb8';

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
    r'aa2fa9148a3dd22a8bf1d5ed8e5424654a88c18c';

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
    r'4fcb49afe407a7dd6f451f9605dbeae2d8235b6c';

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
