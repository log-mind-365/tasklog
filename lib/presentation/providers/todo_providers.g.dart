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
String _$todosByFolderHash() => r'f82b365b911da74b0a81cf27a746414a44619d7a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [todosByFolder].
@ProviderFor(todosByFolder)
const todosByFolderProvider = TodosByFolderFamily();

/// See also [todosByFolder].
class TodosByFolderFamily extends Family<AsyncValue<List<TodoEntity>>> {
  /// See also [todosByFolder].
  const TodosByFolderFamily();

  /// See also [todosByFolder].
  TodosByFolderProvider call(int? folderId) {
    return TodosByFolderProvider(folderId);
  }

  @override
  TodosByFolderProvider getProviderOverride(
    covariant TodosByFolderProvider provider,
  ) {
    return call(provider.folderId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'todosByFolderProvider';
}

/// See also [todosByFolder].
class TodosByFolderProvider
    extends AutoDisposeStreamProvider<List<TodoEntity>> {
  /// See also [todosByFolder].
  TodosByFolderProvider(int? folderId)
    : this._internal(
        (ref) => todosByFolder(ref as TodosByFolderRef, folderId),
        from: todosByFolderProvider,
        name: r'todosByFolderProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$todosByFolderHash,
        dependencies: TodosByFolderFamily._dependencies,
        allTransitiveDependencies:
            TodosByFolderFamily._allTransitiveDependencies,
        folderId: folderId,
      );

  TodosByFolderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.folderId,
  }) : super.internal();

  final int? folderId;

  @override
  Override overrideWith(
    Stream<List<TodoEntity>> Function(TodosByFolderRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TodosByFolderProvider._internal(
        (ref) => create(ref as TodosByFolderRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        folderId: folderId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<TodoEntity>> createElement() {
    return _TodosByFolderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TodosByFolderProvider && other.folderId == folderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, folderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TodosByFolderRef on AutoDisposeStreamProviderRef<List<TodoEntity>> {
  /// The parameter `folderId` of this provider.
  int? get folderId;
}

class _TodosByFolderProviderElement
    extends AutoDisposeStreamProviderElement<List<TodoEntity>>
    with TodosByFolderRef {
  _TodosByFolderProviderElement(super.provider);

  @override
  int? get folderId => (origin as TodosByFolderProvider).folderId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
