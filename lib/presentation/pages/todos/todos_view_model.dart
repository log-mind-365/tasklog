import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/todo_entity.dart';

part 'todos_view_model.g.dart';

/// Todo 필터 타입
enum TodoFilter { all, incomplete, completed }

/// Todo 페이지 상태 (검색, 필터)
class TodoPageState {
  final TodoFilter filter;
  final String searchQuery;
  final bool isSearching;

  const TodoPageState({
    this.filter = TodoFilter.all,
    this.searchQuery = '',
    this.isSearching = false,
  });

  TodoPageState copyWith({
    TodoFilter? filter,
    String? searchQuery,
    bool? isSearching,
  }) {
    return TodoPageState(
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

/// 폴더별 Todo 페이지 상태 Provider
final todoPageStateProvider = StateProvider.family<TodoPageState, int>((
  ref,
  folderId,
) {
  return const TodoPageState();
});

/// Todos ViewModel
@riverpod
class TodosViewModel extends _$TodosViewModel {
  @override
  void build() {
    // No initial state needed
  }

  /// 필터링된 Todo 리스트 가져오기
  List<TodoEntity> getFilteredTodos({
    required List<TodoEntity> todos,
    required TodoPageState pageState,
  }) {
    // 상태별 필터링
    final filteredByStatus = _filterByStatus(todos, pageState.filter);

    // 검색어 필터링
    final filteredTodos = _filterBySearch(
      filteredByStatus,
      pageState.searchQuery,
    );

    return filteredTodos;
  }

  /// 상태별 필터링
  List<TodoEntity> _filterByStatus(List<TodoEntity> todos, TodoFilter filter) {
    switch (filter) {
      case TodoFilter.incomplete:
        return todos.where((todo) => !todo.isDone).toList();
      case TodoFilter.completed:
        return todos.where((todo) => todo.isDone).toList();
      case TodoFilter.all:
        return todos;
    }
  }

  /// 검색어로 필터링
  List<TodoEntity> _filterBySearch(List<TodoEntity> todos, String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return todos;

    final q = trimmed.toLowerCase();
    return todos.where((todo) {
      return todo.title.toLowerCase().contains(q) ||
          todo.description.toLowerCase().contains(q) ||
          todo.labels.any((l) => l.toLowerCase().contains(q));
    }).toList();
  }

  /// 검색 모드 시작
  void startSearch(int folderId) {
    final notifier = ref.read(todoPageStateProvider(folderId).notifier);
    notifier.state = notifier.state.copyWith(isSearching: true);
  }

  /// 검색 모드 종료
  void stopSearch(int folderId) {
    final notifier = ref.read(todoPageStateProvider(folderId).notifier);
    notifier.state = notifier.state.copyWith(
      isSearching: false,
      searchQuery: '',
    );
  }

  /// 검색어 업데이트
  void updateSearchQuery(int folderId, String query) {
    final notifier = ref.read(todoPageStateProvider(folderId).notifier);
    notifier.state = notifier.state.copyWith(searchQuery: query.toLowerCase());
  }

  /// 필터 변경
  void updateFilter(int folderId, TodoFilter filter) {
    final notifier = ref.read(todoPageStateProvider(folderId).notifier);
    notifier.state = notifier.state.copyWith(filter: filter);
  }

  /// 필터에 해당하는 아이콘 가져오기
  static TodoFilter getFilterIcon(TodoFilter filter) {
    return filter;
  }
}
