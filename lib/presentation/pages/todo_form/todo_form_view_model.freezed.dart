// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_form_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TodoFormState {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  Priority get priority => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  int? get folderId => throw _privateConstructorUsedError;
  bool get isSaving => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of TodoFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TodoFormStateCopyWith<TodoFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodoFormStateCopyWith<$Res> {
  factory $TodoFormStateCopyWith(
    TodoFormState value,
    $Res Function(TodoFormState) then,
  ) = _$TodoFormStateCopyWithImpl<$Res, TodoFormState>;
  @useResult
  $Res call({
    String title,
    String description,
    Priority priority,
    DateTime? dueDate,
    int? folderId,
    bool isSaving,
    String? errorMessage,
  });
}

/// @nodoc
class _$TodoFormStateCopyWithImpl<$Res, $Val extends TodoFormState>
    implements $TodoFormStateCopyWith<$Res> {
  _$TodoFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TodoFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? priority = null,
    Object? dueDate = freezed,
    Object? folderId = freezed,
    Object? isSaving = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as Priority,
            dueDate: freezed == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            folderId: freezed == folderId
                ? _value.folderId
                : folderId // ignore: cast_nullable_to_non_nullable
                      as int?,
            isSaving: null == isSaving
                ? _value.isSaving
                : isSaving // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TodoFormStateImplCopyWith<$Res>
    implements $TodoFormStateCopyWith<$Res> {
  factory _$$TodoFormStateImplCopyWith(
    _$TodoFormStateImpl value,
    $Res Function(_$TodoFormStateImpl) then,
  ) = __$$TodoFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String title,
    String description,
    Priority priority,
    DateTime? dueDate,
    int? folderId,
    bool isSaving,
    String? errorMessage,
  });
}

/// @nodoc
class __$$TodoFormStateImplCopyWithImpl<$Res>
    extends _$TodoFormStateCopyWithImpl<$Res, _$TodoFormStateImpl>
    implements _$$TodoFormStateImplCopyWith<$Res> {
  __$$TodoFormStateImplCopyWithImpl(
    _$TodoFormStateImpl _value,
    $Res Function(_$TodoFormStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TodoFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? priority = null,
    Object? dueDate = freezed,
    Object? folderId = freezed,
    Object? isSaving = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$TodoFormStateImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as Priority,
        dueDate: freezed == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        folderId: freezed == folderId
            ? _value.folderId
            : folderId // ignore: cast_nullable_to_non_nullable
                  as int?,
        isSaving: null == isSaving
            ? _value.isSaving
            : isSaving // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$TodoFormStateImpl implements _TodoFormState {
  const _$TodoFormStateImpl({
    required this.title,
    required this.description,
    required this.priority,
    this.dueDate,
    this.folderId,
    this.isSaving = false,
    this.errorMessage,
  });

  @override
  final String title;
  @override
  final String description;
  @override
  final Priority priority;
  @override
  final DateTime? dueDate;
  @override
  final int? folderId;
  @override
  @JsonKey()
  final bool isSaving;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'TodoFormState(title: $title, description: $description, priority: $priority, dueDate: $dueDate, folderId: $folderId, isSaving: $isSaving, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodoFormStateImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.folderId, folderId) ||
                other.folderId == folderId) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    description,
    priority,
    dueDate,
    folderId,
    isSaving,
    errorMessage,
  );

  /// Create a copy of TodoFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TodoFormStateImplCopyWith<_$TodoFormStateImpl> get copyWith =>
      __$$TodoFormStateImplCopyWithImpl<_$TodoFormStateImpl>(this, _$identity);
}

abstract class _TodoFormState implements TodoFormState {
  const factory _TodoFormState({
    required final String title,
    required final String description,
    required final Priority priority,
    final DateTime? dueDate,
    final int? folderId,
    final bool isSaving,
    final String? errorMessage,
  }) = _$TodoFormStateImpl;

  @override
  String get title;
  @override
  String get description;
  @override
  Priority get priority;
  @override
  DateTime? get dueDate;
  @override
  int? get folderId;
  @override
  bool get isSaving;
  @override
  String? get errorMessage;

  /// Create a copy of TodoFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TodoFormStateImplCopyWith<_$TodoFormStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
