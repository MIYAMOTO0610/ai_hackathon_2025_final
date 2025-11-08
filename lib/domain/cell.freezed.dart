// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cell.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Cell implements DiagnosticableTreeMixin {

 Uint8List? get image; String? get kanji; int? get strokeCount;
/// Create a copy of Cell
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CellCopyWith<Cell> get copyWith => _$CellCopyWithImpl<Cell>(this as Cell, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Cell'))
    ..add(DiagnosticsProperty('image', image))..add(DiagnosticsProperty('kanji', kanji))..add(DiagnosticsProperty('strokeCount', strokeCount));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cell&&const DeepCollectionEquality().equals(other.image, image)&&(identical(other.kanji, kanji) || other.kanji == kanji)&&(identical(other.strokeCount, strokeCount) || other.strokeCount == strokeCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(image),kanji,strokeCount);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Cell(image: $image, kanji: $kanji, strokeCount: $strokeCount)';
}


}

/// @nodoc
abstract mixin class $CellCopyWith<$Res>  {
  factory $CellCopyWith(Cell value, $Res Function(Cell) _then) = _$CellCopyWithImpl;
@useResult
$Res call({
 Uint8List? image, String? kanji, int? strokeCount
});




}
/// @nodoc
class _$CellCopyWithImpl<$Res>
    implements $CellCopyWith<$Res> {
  _$CellCopyWithImpl(this._self, this._then);

  final Cell _self;
  final $Res Function(Cell) _then;

/// Create a copy of Cell
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? image = freezed,Object? kanji = freezed,Object? strokeCount = freezed,}) {
  return _then(_self.copyWith(
image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as Uint8List?,kanji: freezed == kanji ? _self.kanji : kanji // ignore: cast_nullable_to_non_nullable
as String?,strokeCount: freezed == strokeCount ? _self.strokeCount : strokeCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Cell].
extension CellPatterns on Cell {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Cell value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Cell() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Cell value)  $default,){
final _that = this;
switch (_that) {
case _Cell():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Cell value)?  $default,){
final _that = this;
switch (_that) {
case _Cell() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Uint8List? image,  String? kanji,  int? strokeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Cell() when $default != null:
return $default(_that.image,_that.kanji,_that.strokeCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Uint8List? image,  String? kanji,  int? strokeCount)  $default,) {final _that = this;
switch (_that) {
case _Cell():
return $default(_that.image,_that.kanji,_that.strokeCount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Uint8List? image,  String? kanji,  int? strokeCount)?  $default,) {final _that = this;
switch (_that) {
case _Cell() when $default != null:
return $default(_that.image,_that.kanji,_that.strokeCount);case _:
  return null;

}
}

}

/// @nodoc


class _Cell with DiagnosticableTreeMixin implements Cell {
  const _Cell({this.image, this.kanji, this.strokeCount});
  

@override final  Uint8List? image;
@override final  String? kanji;
@override final  int? strokeCount;

/// Create a copy of Cell
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CellCopyWith<_Cell> get copyWith => __$CellCopyWithImpl<_Cell>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Cell'))
    ..add(DiagnosticsProperty('image', image))..add(DiagnosticsProperty('kanji', kanji))..add(DiagnosticsProperty('strokeCount', strokeCount));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cell&&const DeepCollectionEquality().equals(other.image, image)&&(identical(other.kanji, kanji) || other.kanji == kanji)&&(identical(other.strokeCount, strokeCount) || other.strokeCount == strokeCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(image),kanji,strokeCount);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Cell(image: $image, kanji: $kanji, strokeCount: $strokeCount)';
}


}

/// @nodoc
abstract mixin class _$CellCopyWith<$Res> implements $CellCopyWith<$Res> {
  factory _$CellCopyWith(_Cell value, $Res Function(_Cell) _then) = __$CellCopyWithImpl;
@override @useResult
$Res call({
 Uint8List? image, String? kanji, int? strokeCount
});




}
/// @nodoc
class __$CellCopyWithImpl<$Res>
    implements _$CellCopyWith<$Res> {
  __$CellCopyWithImpl(this._self, this._then);

  final _Cell _self;
  final $Res Function(_Cell) _then;

/// Create a copy of Cell
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? image = freezed,Object? kanji = freezed,Object? strokeCount = freezed,}) {
  return _then(_Cell(
image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as Uint8List?,kanji: freezed == kanji ? _self.kanji : kanji // ignore: cast_nullable_to_non_nullable
as String?,strokeCount: freezed == strokeCount ? _self.strokeCount : strokeCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
