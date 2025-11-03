import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_providers.dart';
import '../widgets/todo_item.dart';
import 'todo_form_page.dart';

enum TodoFilter { all, incomplete, completed }

class TodosPage extends ConsumerStatefulWidget {
  const TodosPage({super.key});

  @override
  ConsumerState<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends ConsumerState<TodosPage> {
  TodoFilter _filter = TodoFilter.all;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final todosAsyncValue = _filter == TodoFilter.incomplete
        ? ref.watch(incompleteTodosStreamProvider)
        : _filter == TodoFilter.completed
            ? ref.watch(completedTodosStreamProvider)
            : ref.watch(todosStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('할일 목록'),
        actions: [
          PopupMenuButton<TodoFilter>(
            icon: const Icon(Icons.filter_list),
            onSelected: (filter) {
              setState(() {
                _filter = filter;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: TodoFilter.all,
                child: Text('전체'),
              ),
              const PopupMenuItem(
                value: TodoFilter.incomplete,
                child: Text('미완료'),
              ),
              const PopupMenuItem(
                value: TodoFilter.completed,
                child: Text('완료'),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: '검색...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      body: todosAsyncValue.when(
        data: (todos) {
          final filteredTodos = _searchQuery.isEmpty
              ? todos
              : todos.where((todo) {
                  return todo.title.toLowerCase().contains(_searchQuery) ||
                      todo.description.toLowerCase().contains(_searchQuery);
                }).toList();

          if (filteredTodos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '할일이 없습니다',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: filteredTodos.length,
            itemBuilder: (context, index) {
              final todo = filteredTodos[index];
              return TodoItem(
                todo: todo,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodoFormPage(todo: todo),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('오류 발생: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TodoFormPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
