import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/priority.dart';
import '../../../domain/entities/todo_entity.dart';
import '../../providers/providers.dart';

part 'todo_form_view_model.freezed.dart';
part 'todo_form_view_model.g.dart';

@freezed
class TodoFormState with _$TodoFormState {
  const factory TodoFormState({
    required String title,
    required String description,
    required Priority priority,
    DateTime? dueDate,
    int? folderId,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = _TodoFormState;
}

@riverpod
class TodoFormViewModel extends _$TodoFormViewModel {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  @override
  TodoFormState build(TodoEntity? initialTodo, int? defaultFolderId) {
    // TextEditingController 초기화
    titleController = TextEditingController(text: initialTodo?.title ?? '');
    descriptionController = TextEditingController(
      text: initialTodo?.description ?? '',
    );

    // TextEditingController가 변경될 때 상태 업데이트
    titleController.addListener(_onTitleChanged);
    descriptionController.addListener(_onDescriptionChanged);

    // dispose 시 정리
    ref.onDispose(() {
      titleController.removeListener(_onTitleChanged);
      descriptionController.removeListener(_onDescriptionChanged);
      titleController.dispose();
      descriptionController.dispose();
    });

    return TodoFormState(
      title: initialTodo?.title ?? '',
      description: initialTodo?.description ?? '',
      priority: initialTodo?.priority ?? Priority.medium,
      dueDate: initialTodo?.dueDate,
      folderId: initialTodo?.folderId ?? defaultFolderId,
    );
  }

  void _onTitleChanged() {
    state = state.copyWith(title: titleController.text);
  }

  void _onDescriptionChanged() {
    state = state.copyWith(description: descriptionController.text);
  }

  void setPriority(Priority priority) {
    state = state.copyWith(priority: priority);
  }

  void setDueDate(DateTime? dueDate) {
    state = state.copyWith(dueDate: dueDate);
  }

  void clearDueDate() {
    state = state.copyWith(dueDate: null);
  }

  void setFolderId(int? folderId) {
    state = state.copyWith(folderId: folderId);
  }

  String? validateTitle() {
    if (state.title.trim().isEmpty) {
      return 'pleaseEnterTitle'; // L10n 키
    }
    return null;
  }

  Future<bool> saveTodo(TodoEntity? initialTodo) async {
    // 유효성 검증
    final titleError = validateTitle();
    if (titleError != null) {
      state = state.copyWith(errorMessage: titleError);
      return false;
    }

    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      final todo = TodoEntity(
        id: initialTodo?.id ?? 0,
        title: state.title.trim(),
        description: state.description.trim(),
        isDone: initialTodo?.isDone ?? false,
        priority: state.priority,
        dueDate: state.dueDate,
        folderId: state.folderId,
        createdAt: initialTodo?.createdAt ?? DateTime.now(),
      );

      if (initialTodo == null) {
        final addUseCase = ref.read(addTodoUseCaseProvider);
        await addUseCase(todo);
      } else {
        final updateUseCase = ref.read(updateTodoUseCaseProvider);
        await updateUseCase(todo);
      }

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e, stackTrace) {
      print('Error saving todo: $e');
      print('Stack trace: $stackTrace');
      state = state.copyWith(isSaving: false, errorMessage: e.toString());
      return false;
    }
  }
}
