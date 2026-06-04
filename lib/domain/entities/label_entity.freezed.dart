// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'label_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LabelEntity {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Create a copy of LabelEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LabelEntityCopyWith<LabelEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LabelEntityCopyWith<$Res> {
  factory $LabelEntityCopyWith(
    LabelEntity value,
    $Res Function(LabelEntity) then,
  ) = _$LabelEntityCopyWithImpl<$Res, LabelEntity>;
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class _$LabelEntityCopyWithImpl<$Res, $Val extends LabelEntity>
    implements $LabelEntityCopyWith<$Res> {
  _$LabelEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LabelEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LabelEntityImplCopyWith<$Res>
    implements $LabelEntityCopyWith<$Res> {
  factory _$$LabelEntityImplCopyWith(
    _$LabelEntityImpl value,
    $Res Function(_$LabelEntityImpl) then,
  ) = __$$LabelEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class __$$LabelEntityImplCopyWithImpl<$Res>
    extends _$LabelEntityCopyWithImpl<$Res, _$LabelEntityImpl>
    implements _$$LabelEntityImplCopyWith<$Res> {
  __$$LabelEntityImplCopyWithImpl(
    _$LabelEntityImpl _value,
    $Res Function(_$LabelEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LabelEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$LabelEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LabelEntityImpl implements _LabelEntity {
  const _$LabelEntityImpl({required this.id, required this.name});

  @override
  final int id;
  @override
  final String name;

  @override
  String toString() {
    return 'LabelEntity(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LabelEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of LabelEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LabelEntityImplCopyWith<_$LabelEntityImpl> get copyWith =>
      __$$LabelEntityImplCopyWithImpl<_$LabelEntityImpl>(this, _$identity);
}

abstract class _LabelEntity implements LabelEntity {
  const factory _LabelEntity({
    required final int id,
    required final String name,
  }) = _$LabelEntityImpl;

  @override
  int get id;
  @override
  String get name;

  /// Create a copy of LabelEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LabelEntityImplCopyWith<_$LabelEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
