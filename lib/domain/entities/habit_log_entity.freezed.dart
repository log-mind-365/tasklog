// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_log_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HabitLogEntity {
  int get habitId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get completedCount => throw _privateConstructorUsedError; // 실제 완료한 횟수
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of HabitLogEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HabitLogEntityCopyWith<HabitLogEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitLogEntityCopyWith<$Res> {
  factory $HabitLogEntityCopyWith(
    HabitLogEntity value,
    $Res Function(HabitLogEntity) then,
  ) = _$HabitLogEntityCopyWithImpl<$Res, HabitLogEntity>;
  @useResult
  $Res call({
    int habitId,
    DateTime date,
    int completedCount,
    DateTime createdAt,
  });
}

/// @nodoc
class _$HabitLogEntityCopyWithImpl<$Res, $Val extends HabitLogEntity>
    implements $HabitLogEntityCopyWith<$Res> {
  _$HabitLogEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HabitLogEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? habitId = null,
    Object? date = null,
    Object? completedCount = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            habitId: null == habitId
                ? _value.habitId
                : habitId // ignore: cast_nullable_to_non_nullable
                      as int,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completedCount: null == completedCount
                ? _value.completedCount
                : completedCount // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HabitLogEntityImplCopyWith<$Res>
    implements $HabitLogEntityCopyWith<$Res> {
  factory _$$HabitLogEntityImplCopyWith(
    _$HabitLogEntityImpl value,
    $Res Function(_$HabitLogEntityImpl) then,
  ) = __$$HabitLogEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int habitId,
    DateTime date,
    int completedCount,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$HabitLogEntityImplCopyWithImpl<$Res>
    extends _$HabitLogEntityCopyWithImpl<$Res, _$HabitLogEntityImpl>
    implements _$$HabitLogEntityImplCopyWith<$Res> {
  __$$HabitLogEntityImplCopyWithImpl(
    _$HabitLogEntityImpl _value,
    $Res Function(_$HabitLogEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HabitLogEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? habitId = null,
    Object? date = null,
    Object? completedCount = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$HabitLogEntityImpl(
        habitId: null == habitId
            ? _value.habitId
            : habitId // ignore: cast_nullable_to_non_nullable
                  as int,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completedCount: null == completedCount
            ? _value.completedCount
            : completedCount // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$HabitLogEntityImpl implements _HabitLogEntity {
  const _$HabitLogEntityImpl({
    required this.habitId,
    required this.date,
    required this.completedCount,
    required this.createdAt,
  });

  @override
  final int habitId;
  @override
  final DateTime date;
  @override
  final int completedCount;
  // 실제 완료한 횟수
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'HabitLogEntity(habitId: $habitId, date: $date, completedCount: $completedCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitLogEntityImpl &&
            (identical(other.habitId, habitId) || other.habitId == habitId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.completedCount, completedCount) ||
                other.completedCount == completedCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, habitId, date, completedCount, createdAt);

  /// Create a copy of HabitLogEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitLogEntityImplCopyWith<_$HabitLogEntityImpl> get copyWith =>
      __$$HabitLogEntityImplCopyWithImpl<_$HabitLogEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _HabitLogEntity implements HabitLogEntity {
  const factory _HabitLogEntity({
    required final int habitId,
    required final DateTime date,
    required final int completedCount,
    required final DateTime createdAt,
  }) = _$HabitLogEntityImpl;

  @override
  int get habitId;
  @override
  DateTime get date;
  @override
  int get completedCount; // 실제 완료한 횟수
  @override
  DateTime get createdAt;

  /// Create a copy of HabitLogEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HabitLogEntityImplCopyWith<_$HabitLogEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
