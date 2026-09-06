// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CodeportError {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CodeportError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CodeportError()';
}


}

/// @nodoc
class $CodeportErrorCopyWith<$Res>  {
$CodeportErrorCopyWith(CodeportError _, $Res Function(CodeportError) __);
}


/// Adds pattern-matching-related methods to [CodeportError].
extension CodeportErrorPatterns on CodeportError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CodeportError_Auth value)?  auth,TResult Function( CodeportError_Network value)?  network,TResult Function( CodeportError_RateLimited value)?  rateLimited,TResult Function( CodeportError_NotFound value)?  notFound,TResult Function( CodeportError_Validation value)?  validation,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CodeportError_Auth() when auth != null:
return auth(_that);case CodeportError_Network() when network != null:
return network(_that);case CodeportError_RateLimited() when rateLimited != null:
return rateLimited(_that);case CodeportError_NotFound() when notFound != null:
return notFound(_that);case CodeportError_Validation() when validation != null:
return validation(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CodeportError_Auth value)  auth,required TResult Function( CodeportError_Network value)  network,required TResult Function( CodeportError_RateLimited value)  rateLimited,required TResult Function( CodeportError_NotFound value)  notFound,required TResult Function( CodeportError_Validation value)  validation,}){
final _that = this;
switch (_that) {
case CodeportError_Auth():
return auth(_that);case CodeportError_Network():
return network(_that);case CodeportError_RateLimited():
return rateLimited(_that);case CodeportError_NotFound():
return notFound(_that);case CodeportError_Validation():
return validation(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CodeportError_Auth value)?  auth,TResult? Function( CodeportError_Network value)?  network,TResult? Function( CodeportError_RateLimited value)?  rateLimited,TResult? Function( CodeportError_NotFound value)?  notFound,TResult? Function( CodeportError_Validation value)?  validation,}){
final _that = this;
switch (_that) {
case CodeportError_Auth() when auth != null:
return auth(_that);case CodeportError_Network() when network != null:
return network(_that);case CodeportError_RateLimited() when rateLimited != null:
return rateLimited(_that);case CodeportError_NotFound() when notFound != null:
return notFound(_that);case CodeportError_Validation() when validation != null:
return validation(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  auth,TResult Function( String field0)?  network,TResult Function( String resetAt)?  rateLimited,TResult Function()?  notFound,TResult Function( String field0)?  validation,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CodeportError_Auth() when auth != null:
return auth();case CodeportError_Network() when network != null:
return network(_that.field0);case CodeportError_RateLimited() when rateLimited != null:
return rateLimited(_that.resetAt);case CodeportError_NotFound() when notFound != null:
return notFound();case CodeportError_Validation() when validation != null:
return validation(_that.field0);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  auth,required TResult Function( String field0)  network,required TResult Function( String resetAt)  rateLimited,required TResult Function()  notFound,required TResult Function( String field0)  validation,}) {final _that = this;
switch (_that) {
case CodeportError_Auth():
return auth();case CodeportError_Network():
return network(_that.field0);case CodeportError_RateLimited():
return rateLimited(_that.resetAt);case CodeportError_NotFound():
return notFound();case CodeportError_Validation():
return validation(_that.field0);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  auth,TResult? Function( String field0)?  network,TResult? Function( String resetAt)?  rateLimited,TResult? Function()?  notFound,TResult? Function( String field0)?  validation,}) {final _that = this;
switch (_that) {
case CodeportError_Auth() when auth != null:
return auth();case CodeportError_Network() when network != null:
return network(_that.field0);case CodeportError_RateLimited() when rateLimited != null:
return rateLimited(_that.resetAt);case CodeportError_NotFound() when notFound != null:
return notFound();case CodeportError_Validation() when validation != null:
return validation(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class CodeportError_Auth extends CodeportError {
  const CodeportError_Auth(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CodeportError_Auth);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CodeportError.auth()';
}


}




/// @nodoc


class CodeportError_Network extends CodeportError {
  const CodeportError_Network(this.field0): super._();
  

 final  String field0;

/// Create a copy of CodeportError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CodeportError_NetworkCopyWith<CodeportError_Network> get copyWith => _$CodeportError_NetworkCopyWithImpl<CodeportError_Network>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CodeportError_Network&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'CodeportError.network(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $CodeportError_NetworkCopyWith<$Res> implements $CodeportErrorCopyWith<$Res> {
  factory $CodeportError_NetworkCopyWith(CodeportError_Network value, $Res Function(CodeportError_Network) _then) = _$CodeportError_NetworkCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$CodeportError_NetworkCopyWithImpl<$Res>
    implements $CodeportError_NetworkCopyWith<$Res> {
  _$CodeportError_NetworkCopyWithImpl(this._self, this._then);

  final CodeportError_Network _self;
  final $Res Function(CodeportError_Network) _then;

/// Create a copy of CodeportError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(CodeportError_Network(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CodeportError_RateLimited extends CodeportError {
  const CodeportError_RateLimited({required this.resetAt}): super._();
  

 final  String resetAt;

/// Create a copy of CodeportError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CodeportError_RateLimitedCopyWith<CodeportError_RateLimited> get copyWith => _$CodeportError_RateLimitedCopyWithImpl<CodeportError_RateLimited>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CodeportError_RateLimited&&(identical(other.resetAt, resetAt) || other.resetAt == resetAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,resetAt);
}

@override
String toString() {
    return 'CodeportError.rateLimited(resetAt: $resetAt)';
}


}

/// @nodoc
abstract mixin class $CodeportError_RateLimitedCopyWith<$Res> implements $CodeportErrorCopyWith<$Res> {
  factory $CodeportError_RateLimitedCopyWith(CodeportError_RateLimited value, $Res Function(CodeportError_RateLimited) _then) = _$CodeportError_RateLimitedCopyWithImpl;
@useResult
$Res call({
 String resetAt
});




}
/// @nodoc
class _$CodeportError_RateLimitedCopyWithImpl<$Res>
    implements $CodeportError_RateLimitedCopyWith<$Res> {
  _$CodeportError_RateLimitedCopyWithImpl(this._self, this._then);

  final CodeportError_RateLimited _self;
  final $Res Function(CodeportError_RateLimited) _then;

/// Create a copy of CodeportError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? resetAt = null,}) {
  return _then(CodeportError_RateLimited(
resetAt: null == resetAt ? _self.resetAt : resetAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CodeportError_NotFound extends CodeportError {
  const CodeportError_NotFound(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CodeportError_NotFound);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CodeportError.notFound()';
}


}




/// @nodoc


class CodeportError_Validation extends CodeportError {
  const CodeportError_Validation(this.field0): super._();
  

 final  String field0;

/// Create a copy of CodeportError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CodeportError_ValidationCopyWith<CodeportError_Validation> get copyWith => _$CodeportError_ValidationCopyWithImpl<CodeportError_Validation>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CodeportError_Validation&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'CodeportError.validation(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $CodeportError_ValidationCopyWith<$Res> implements $CodeportErrorCopyWith<$Res> {
  factory $CodeportError_ValidationCopyWith(CodeportError_Validation value, $Res Function(CodeportError_Validation) _then) = _$CodeportError_ValidationCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$CodeportError_ValidationCopyWithImpl<$Res>
    implements $CodeportError_ValidationCopyWith<$Res> {
  _$CodeportError_ValidationCopyWithImpl(this._self, this._then);

  final CodeportError_Validation _self;
  final $Res Function(CodeportError_Validation) _then;

/// Create a copy of CodeportError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(CodeportError_Validation(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
