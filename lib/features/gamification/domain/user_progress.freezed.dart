// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProgress _$UserProgressFromJson(Map<String, dynamic> json) {
  return _UserProgress.fromJson(json);
}

/// @nodoc
mixin _$UserProgress {
  int get points => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  int get totalFocusMinutes => throw _privateConstructorUsedError;
  int get completedSessions => throw _privateConstructorUsedError;
  List<String> get unlockedAchievements => throw _privateConstructorUsedError;

  /// Serializes this UserProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProgressCopyWith<UserProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProgressCopyWith<$Res> {
  factory $UserProgressCopyWith(
          UserProgress value, $Res Function(UserProgress) then) =
      _$UserProgressCopyWithImpl<$Res, UserProgress>;
  @useResult
  $Res call(
      {int points,
      int level,
      int totalFocusMinutes,
      int completedSessions,
      List<String> unlockedAchievements});
}

/// @nodoc
class _$UserProgressCopyWithImpl<$Res, $Val extends UserProgress>
    implements $UserProgressCopyWith<$Res> {
  _$UserProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? points = null,
    Object? level = null,
    Object? totalFocusMinutes = null,
    Object? completedSessions = null,
    Object? unlockedAchievements = null,
  }) {
    return _then(_value.copyWith(
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      totalFocusMinutes: null == totalFocusMinutes
          ? _value.totalFocusMinutes
          : totalFocusMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      completedSessions: null == completedSessions
          ? _value.completedSessions
          : completedSessions // ignore: cast_nullable_to_non_nullable
              as int,
      unlockedAchievements: null == unlockedAchievements
          ? _value.unlockedAchievements
          : unlockedAchievements // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProgressImplCopyWith<$Res>
    implements $UserProgressCopyWith<$Res> {
  factory _$$UserProgressImplCopyWith(
          _$UserProgressImpl value, $Res Function(_$UserProgressImpl) then) =
      __$$UserProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int points,
      int level,
      int totalFocusMinutes,
      int completedSessions,
      List<String> unlockedAchievements});
}

/// @nodoc
class __$$UserProgressImplCopyWithImpl<$Res>
    extends _$UserProgressCopyWithImpl<$Res, _$UserProgressImpl>
    implements _$$UserProgressImplCopyWith<$Res> {
  __$$UserProgressImplCopyWithImpl(
      _$UserProgressImpl _value, $Res Function(_$UserProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? points = null,
    Object? level = null,
    Object? totalFocusMinutes = null,
    Object? completedSessions = null,
    Object? unlockedAchievements = null,
  }) {
    return _then(_$UserProgressImpl(
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      totalFocusMinutes: null == totalFocusMinutes
          ? _value.totalFocusMinutes
          : totalFocusMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      completedSessions: null == completedSessions
          ? _value.completedSessions
          : completedSessions // ignore: cast_nullable_to_non_nullable
              as int,
      unlockedAchievements: null == unlockedAchievements
          ? _value._unlockedAchievements
          : unlockedAchievements // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProgressImpl implements _UserProgress {
  const _$UserProgressImpl(
      {this.points = 0,
      this.level = 1,
      this.totalFocusMinutes = 0,
      this.completedSessions = 0,
      final List<String> unlockedAchievements = const []})
      : _unlockedAchievements = unlockedAchievements;

  factory _$UserProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProgressImplFromJson(json);

  @override
  @JsonKey()
  final int points;
  @override
  @JsonKey()
  final int level;
  @override
  @JsonKey()
  final int totalFocusMinutes;
  @override
  @JsonKey()
  final int completedSessions;
  final List<String> _unlockedAchievements;
  @override
  @JsonKey()
  List<String> get unlockedAchievements {
    if (_unlockedAchievements is EqualUnmodifiableListView)
      return _unlockedAchievements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unlockedAchievements);
  }

  @override
  String toString() {
    return 'UserProgress(points: $points, level: $level, totalFocusMinutes: $totalFocusMinutes, completedSessions: $completedSessions, unlockedAchievements: $unlockedAchievements)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProgressImpl &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.totalFocusMinutes, totalFocusMinutes) ||
                other.totalFocusMinutes == totalFocusMinutes) &&
            (identical(other.completedSessions, completedSessions) ||
                other.completedSessions == completedSessions) &&
            const DeepCollectionEquality()
                .equals(other._unlockedAchievements, _unlockedAchievements));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      points,
      level,
      totalFocusMinutes,
      completedSessions,
      const DeepCollectionEquality().hash(_unlockedAchievements));

  /// Create a copy of UserProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProgressImplCopyWith<_$UserProgressImpl> get copyWith =>
      __$$UserProgressImplCopyWithImpl<_$UserProgressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProgressImplToJson(
      this,
    );
  }
}

abstract class _UserProgress implements UserProgress {
  const factory _UserProgress(
      {final int points,
      final int level,
      final int totalFocusMinutes,
      final int completedSessions,
      final List<String> unlockedAchievements}) = _$UserProgressImpl;

  factory _UserProgress.fromJson(Map<String, dynamic> json) =
      _$UserProgressImpl.fromJson;

  @override
  int get points;
  @override
  int get level;
  @override
  int get totalFocusMinutes;
  @override
  int get completedSessions;
  @override
  List<String> get unlockedAchievements;

  /// Create a copy of UserProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProgressImplCopyWith<_$UserProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
