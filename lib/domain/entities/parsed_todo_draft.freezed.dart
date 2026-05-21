// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parsed_todo_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ParsedTodoDraft {
  String get title => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  List<String> get mentions => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  Priority? get priority => throw _privateConstructorUsedError;
  List<String> get subTasks => throw _privateConstructorUsedError;

  /// Create a copy of ParsedTodoDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParsedTodoDraftCopyWith<ParsedTodoDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParsedTodoDraftCopyWith<$Res> {
  factory $ParsedTodoDraftCopyWith(
    ParsedTodoDraft value,
    $Res Function(ParsedTodoDraft) then,
  ) = _$ParsedTodoDraftCopyWithImpl<$Res, ParsedTodoDraft>;
  @useResult
  $Res call({
    String title,
    DateTime? dueDate,
    List<String> mentions,
    List<String> tags,
    Priority? priority,
    List<String> subTasks,
  });
}

/// @nodoc
class _$ParsedTodoDraftCopyWithImpl<$Res, $Val extends ParsedTodoDraft>
    implements $ParsedTodoDraftCopyWith<$Res> {
  _$ParsedTodoDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParsedTodoDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? dueDate = freezed,
    Object? mentions = null,
    Object? tags = null,
    Object? priority = freezed,
    Object? subTasks = null,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            dueDate: freezed == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            mentions: null == mentions
                ? _value.mentions
                : mentions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            priority: freezed == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as Priority?,
            subTasks: null == subTasks
                ? _value.subTasks
                : subTasks // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ParsedTodoDraftImplCopyWith<$Res>
    implements $ParsedTodoDraftCopyWith<$Res> {
  factory _$$ParsedTodoDraftImplCopyWith(
    _$ParsedTodoDraftImpl value,
    $Res Function(_$ParsedTodoDraftImpl) then,
  ) = __$$ParsedTodoDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String title,
    DateTime? dueDate,
    List<String> mentions,
    List<String> tags,
    Priority? priority,
    List<String> subTasks,
  });
}

/// @nodoc
class __$$ParsedTodoDraftImplCopyWithImpl<$Res>
    extends _$ParsedTodoDraftCopyWithImpl<$Res, _$ParsedTodoDraftImpl>
    implements _$$ParsedTodoDraftImplCopyWith<$Res> {
  __$$ParsedTodoDraftImplCopyWithImpl(
    _$ParsedTodoDraftImpl _value,
    $Res Function(_$ParsedTodoDraftImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ParsedTodoDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? dueDate = freezed,
    Object? mentions = null,
    Object? tags = null,
    Object? priority = freezed,
    Object? subTasks = null,
  }) {
    return _then(
      _$ParsedTodoDraftImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        dueDate: freezed == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        mentions: null == mentions
            ? _value._mentions
            : mentions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        priority: freezed == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as Priority?,
        subTasks: null == subTasks
            ? _value._subTasks
            : subTasks // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc

class _$ParsedTodoDraftImpl implements _ParsedTodoDraft {
  const _$ParsedTodoDraftImpl({
    required this.title,
    this.dueDate,
    final List<String> mentions = const <String>[],
    final List<String> tags = const <String>[],
    this.priority,
    final List<String> subTasks = const <String>[],
  }) : _mentions = mentions,
       _tags = tags,
       _subTasks = subTasks;

  @override
  final String title;
  @override
  final DateTime? dueDate;
  final List<String> _mentions;
  @override
  @JsonKey()
  List<String> get mentions {
    if (_mentions is EqualUnmodifiableListView) return _mentions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mentions);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final Priority? priority;
  final List<String> _subTasks;
  @override
  @JsonKey()
  List<String> get subTasks {
    if (_subTasks is EqualUnmodifiableListView) return _subTasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subTasks);
  }

  @override
  String toString() {
    return 'ParsedTodoDraft(title: $title, dueDate: $dueDate, mentions: $mentions, tags: $tags, priority: $priority, subTasks: $subTasks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParsedTodoDraftImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            const DeepCollectionEquality().equals(other._mentions, _mentions) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            const DeepCollectionEquality().equals(other._subTasks, _subTasks));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    dueDate,
    const DeepCollectionEquality().hash(_mentions),
    const DeepCollectionEquality().hash(_tags),
    priority,
    const DeepCollectionEquality().hash(_subTasks),
  );

  /// Create a copy of ParsedTodoDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParsedTodoDraftImplCopyWith<_$ParsedTodoDraftImpl> get copyWith =>
      __$$ParsedTodoDraftImplCopyWithImpl<_$ParsedTodoDraftImpl>(
        this,
        _$identity,
      );
}

abstract class _ParsedTodoDraft implements ParsedTodoDraft {
  const factory _ParsedTodoDraft({
    required final String title,
    final DateTime? dueDate,
    final List<String> mentions,
    final List<String> tags,
    final Priority? priority,
    final List<String> subTasks,
  }) = _$ParsedTodoDraftImpl;

  @override
  String get title;
  @override
  DateTime? get dueDate;
  @override
  List<String> get mentions;
  @override
  List<String> get tags;
  @override
  Priority? get priority;
  @override
  List<String> get subTasks;

  /// Create a copy of ParsedTodoDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParsedTodoDraftImplCopyWith<_$ParsedTodoDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
