// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'folder_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FolderEntity {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get color => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  /// Create a copy of FolderEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FolderEntityCopyWith<FolderEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FolderEntityCopyWith<$Res> {
  factory $FolderEntityCopyWith(
    FolderEntity value,
    $Res Function(FolderEntity) then,
  ) = _$FolderEntityCopyWithImpl<$Res, FolderEntity>;
  @useResult
  $Res call({int id, String name, int color, int order});
}

/// @nodoc
class _$FolderEntityCopyWithImpl<$Res, $Val extends FolderEntity>
    implements $FolderEntityCopyWith<$Res> {
  _$FolderEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FolderEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = null,
    Object? order = null,
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
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as int,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FolderEntityImplCopyWith<$Res>
    implements $FolderEntityCopyWith<$Res> {
  factory _$$FolderEntityImplCopyWith(
    _$FolderEntityImpl value,
    $Res Function(_$FolderEntityImpl) then,
  ) = __$$FolderEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, int color, int order});
}

/// @nodoc
class __$$FolderEntityImplCopyWithImpl<$Res>
    extends _$FolderEntityCopyWithImpl<$Res, _$FolderEntityImpl>
    implements _$$FolderEntityImplCopyWith<$Res> {
  __$$FolderEntityImplCopyWithImpl(
    _$FolderEntityImpl _value,
    $Res Function(_$FolderEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FolderEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? color = null,
    Object? order = null,
  }) {
    return _then(
      _$FolderEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as int,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$FolderEntityImpl implements _FolderEntity {
  const _$FolderEntityImpl({
    required this.id,
    required this.name,
    required this.color,
    required this.order,
  });

  @override
  final int id;
  @override
  final String name;
  @override
  final int color;
  @override
  final int order;

  @override
  String toString() {
    return 'FolderEntity(id: $id, name: $name, color: $color, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FolderEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.order, order) || other.order == order));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, color, order);

  /// Create a copy of FolderEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FolderEntityImplCopyWith<_$FolderEntityImpl> get copyWith =>
      __$$FolderEntityImplCopyWithImpl<_$FolderEntityImpl>(this, _$identity);
}

abstract class _FolderEntity implements FolderEntity {
  const factory _FolderEntity({
    required final int id,
    required final String name,
    required final int color,
    required final int order,
  }) = _$FolderEntityImpl;

  @override
  int get id;
  @override
  String get name;
  @override
  int get color;
  @override
  int get order;

  /// Create a copy of FolderEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FolderEntityImplCopyWith<_$FolderEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
