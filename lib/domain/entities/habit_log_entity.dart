import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_log_entity.freezed.dart';

@freezed
class HabitLogEntity with _$HabitLogEntity {
  const factory HabitLogEntity({
    required int habitId,
    required DateTime date,
    required int completedCount, // 실제 완료한 횟수
    required DateTime createdAt,
  }) = _HabitLogEntity;
}
