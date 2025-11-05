// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_form_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todoFormViewModelHash() => r'd5ea180bdcd1deb99dce54371f294b84521bd2de';

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

abstract class _$TodoFormViewModel
    extends BuildlessAutoDisposeNotifier<TodoFormState> {
  late final TodoEntity? initialTodo;
  late final int? defaultFolderId;

  TodoFormState build(TodoEntity? initialTodo, int? defaultFolderId);
}

/// See also [TodoFormViewModel].
@ProviderFor(TodoFormViewModel)
const todoFormViewModelProvider = TodoFormViewModelFamily();

/// See also [TodoFormViewModel].
class TodoFormViewModelFamily extends Family<TodoFormState> {
  /// See also [TodoFormViewModel].
  const TodoFormViewModelFamily();

  /// See also [TodoFormViewModel].
  TodoFormViewModelProvider call(
    TodoEntity? initialTodo,
    int? defaultFolderId,
  ) {
    return TodoFormViewModelProvider(initialTodo, defaultFolderId);
  }

  @override
  TodoFormViewModelProvider getProviderOverride(
    covariant TodoFormViewModelProvider provider,
  ) {
    return call(provider.initialTodo, provider.defaultFolderId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'todoFormViewModelProvider';
}

/// See also [TodoFormViewModel].
class TodoFormViewModelProvider
    extends AutoDisposeNotifierProviderImpl<TodoFormViewModel, TodoFormState> {
  /// See also [TodoFormViewModel].
  TodoFormViewModelProvider(TodoEntity? initialTodo, int? defaultFolderId)
    : this._internal(
        () => TodoFormViewModel()
          ..initialTodo = initialTodo
          ..defaultFolderId = defaultFolderId,
        from: todoFormViewModelProvider,
        name: r'todoFormViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$todoFormViewModelHash,
        dependencies: TodoFormViewModelFamily._dependencies,
        allTransitiveDependencies:
            TodoFormViewModelFamily._allTransitiveDependencies,
        initialTodo: initialTodo,
        defaultFolderId: defaultFolderId,
      );

  TodoFormViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.initialTodo,
    required this.defaultFolderId,
  }) : super.internal();

  final TodoEntity? initialTodo;
  final int? defaultFolderId;

  @override
  TodoFormState runNotifierBuild(covariant TodoFormViewModel notifier) {
    return notifier.build(initialTodo, defaultFolderId);
  }

  @override
  Override overrideWith(TodoFormViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: TodoFormViewModelProvider._internal(
        () => create()
          ..initialTodo = initialTodo
          ..defaultFolderId = defaultFolderId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        initialTodo: initialTodo,
        defaultFolderId: defaultFolderId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<TodoFormViewModel, TodoFormState>
  createElement() {
    return _TodoFormViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TodoFormViewModelProvider &&
        other.initialTodo == initialTodo &&
        other.defaultFolderId == defaultFolderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, initialTodo.hashCode);
    hash = _SystemHash.combine(hash, defaultFolderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TodoFormViewModelRef on AutoDisposeNotifierProviderRef<TodoFormState> {
  /// The parameter `initialTodo` of this provider.
  TodoEntity? get initialTodo;

  /// The parameter `defaultFolderId` of this provider.
  int? get defaultFolderId;
}

class _TodoFormViewModelProviderElement
    extends AutoDisposeNotifierProviderElement<TodoFormViewModel, TodoFormState>
    with TodoFormViewModelRef {
  _TodoFormViewModelProviderElement(super.provider);

  @override
  TodoEntity? get initialTodo =>
      (origin as TodoFormViewModelProvider).initialTodo;
  @override
  int? get defaultFolderId =>
      (origin as TodoFormViewModelProvider).defaultFolderId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
