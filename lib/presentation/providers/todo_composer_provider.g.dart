// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_composer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$editingTodoHash() => r'd1dbaa5b0fe08e3f6cf2bae22655418ccba485b6';

/// 하단 컴포저에서 수정 중인 할 일
///
/// Copied from [EditingTodo].
@ProviderFor(EditingTodo)
final editingTodoProvider =
    AutoDisposeNotifierProvider<EditingTodo, TodoEntity?>.internal(
      EditingTodo.new,
      name: r'editingTodoProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$editingTodoHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$EditingTodo = AutoDisposeNotifier<TodoEntity?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
