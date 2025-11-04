import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tasklog/presentation/providers/providers.dart';
import '../../data/repositories/habit_repository_impl.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/habit_log_entity.dart';
import '../../domain/repositories/habit_repository.dart';
import '../../domain/usecases/add_habit_usecase.dart';
import '../../domain/usecases/decrement_habit_log_usecase.dart';
import '../../domain/usecases/delete_habit_usecase.dart';
import '../../domain/usecases/get_habit_logs_usecase.dart';
import '../../domain/usecases/get_habits_usecase.dart';
import '../../domain/usecases/increment_habit_log_usecase.dart';
import '../../domain/usecases/update_habit_usecase.dart';

part 'habit_providers.g.dart';

// Repository Provider
@riverpod
HabitRepository habitRepository(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  return HabitRepositoryImpl(database);
}

// Use Case Providers
@riverpod
GetHabitsUseCase getHabitsUseCase(Ref ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return GetHabitsUseCase(repository);
}

@riverpod
AddHabitUseCase addHabitUseCase(Ref ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return AddHabitUseCase(repository);
}

@riverpod
UpdateHabitUseCase updateHabitUseCase(Ref ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return UpdateHabitUseCase(repository);
}

@riverpod
DeleteHabitUseCase deleteHabitUseCase(Ref ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return DeleteHabitUseCase(repository);
}

@riverpod
IncrementHabitLogUseCase incrementHabitLogUseCase(Ref ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return IncrementHabitLogUseCase(repository);
}

@riverpod
DecrementHabitLogUseCase decrementHabitLogUseCase(Ref ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return DecrementHabitLogUseCase(repository);
}

@riverpod
GetHabitLogsUseCase getHabitLogsUseCase(Ref ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return GetHabitLogsUseCase(repository);
}

// Stream Providers
@riverpod
Stream<List<HabitEntity>> habits(Ref ref) {
  final useCase = ref.watch(getHabitsUseCaseProvider);
  return useCase.watch();
}

@riverpod
Stream<HabitEntity?> habitById(Ref ref, int habitId) {
  final habitsStream = ref.watch(habitsProvider.stream);
  return habitsStream.map((habits) {
    try {
      return habits.firstWhere((habit) => habit.id == habitId);
    } catch (e) {
      return null;
    }
  });
}

@riverpod
Stream<List<HabitLogEntity>> habitLogs(Ref ref, int habitId) {
  final useCase = ref.watch(getHabitLogsUseCaseProvider);
  return useCase.watch(habitId);
}

// Async Provider for date range logs
@riverpod
Future<List<HabitLogEntity>> habitLogsByDateRange(
  Ref ref,
  int habitId,
  DateTime start,
  DateTime end,
) async {
  final useCase = ref.watch(getHabitLogsUseCaseProvider);
  return await useCase.getByDateRange(habitId, start, end);
}
