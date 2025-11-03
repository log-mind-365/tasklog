// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HabitEntity {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get goalCount => throw _privateConstructorUsedError; // 하루 목표 횟수
  int get color => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of HabitEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HabitEntityCopyWith<HabitEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitEntityCopyWith<$Res> {
  factory $HabitEntityCopyWith(
    HabitEntity value,
    $Res Function(HabitEntity) then,
  ) = _$HabitEntityCopyWithImpl<$Res, HabitEntity>;
  @useResult
  $Res call({
    int id,
    String name,
    String description,
    int goalCount,
    int color,
    String icon,
    DateTime createdAt,
  });
}

/// @nodoc
class _$HabitEntityCopyWithImpl<$Res, $Val extends HabitEntity>
    implements $HabitEntityCopyWith<$Res> {
  _$HabitEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HabitEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? goalCount = null,
    Object? color = null,
    Object? icon = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            goalCount: null == goalCount
                ? _value.goalCount
                : goalCount // ignore: cast_nullable_to_non_nullable
                      as int,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as int,
            icon: null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$HabitEntityImplCopyWith<$Res>
    implements $HabitEntityCopyWith<$Res> {
  factory _$$HabitEntityImplCopyWith(
    _$HabitEntityImpl value,
    $Res Function(_$HabitEntityImpl) then,
  ) = __$$HabitEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String description,
    int goalCount,
    int color,
    String icon,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$HabitEntityImplCopyWithImpl<$Res>
    extends _$HabitEntityCopyWithImpl<$Res, _$HabitEntityImpl>
    implements _$$HabitEntityImplCopyWith<$Res> {
  __$$HabitEntityImplCopyWithImpl(
    _$HabitEntityImpl _value,
    $Res Function(_$HabitEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HabitEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? goalCount = null,
    Object? color = null,
    Object? icon = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$HabitEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        goalCount: null == goalCount
            ? _value.goalCount
            : goalCount // ignore: cast_nullable_to_non_nullable
                  as int,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as int,
        icon: null == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$HabitEntityImpl implements _HabitEntity {
  const _$HabitEntityImpl({
    required this.id,
    required this.name,
    required this.description,
    required this.goalCount,
    required this.color,
    required this.icon,
    required this.createdAt,
  });

  @override
  final int id;
  @override
  final String name;
  @override
  final String description;
  @override
  final int goalCount;
  // 하루 목표 횟수
  @override
  final int color;
  @override
  final String icon;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'HabitEntity(id: $id, name: $name, description: $description, goalCount: $goalCount, color: $color, icon: $icon, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.goalCount, goalCount) ||
                other.goalCount == goalCount) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    goalCount,
    color,
    icon,
    createdAt,
  );

  /// Create a copy of HabitEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitEntityImplCopyWith<_$HabitEntityImpl> get copyWith =>
      __$$HabitEntityImplCopyWithImpl<_$HabitEntityImpl>(this, _$identity);
}

abstract class _HabitEntity implements HabitEntity {
  const factory _HabitEntity({
    required final int id,
    required final String name,
    required final String description,
    required final int goalCount,
    required final int color,
    required final String icon,
    required final DateTime createdAt,
  }) = _$HabitEntityImpl;

  @override
  int get id;
  @override
  String get name;
  @override
  String get description;
  @override
  int get goalCount; // 하루 목표 횟수
  @override
  int get color;
  @override
  String get icon;
  @override
  DateTime get createdAt;

  /// Create a copy of HabitEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HabitEntityImplCopyWith<_$HabitEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
