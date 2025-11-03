import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit_entity.freezed.dart';

@freezed
class HabitEntity with _$HabitEntity {
  const factory HabitEntity({
    required int id,
    required String name,
    required String description,
    required int goalCount, // 하루 목표 횟수
    required int color,
    required String icon,
    required DateTime createdAt,
  }) = _HabitEntity;
}
