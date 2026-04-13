// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'multiple_products_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductVariant {

 String get colorName; String get colorHex; String get size; String get price; String get stock; String get sku; bool get isSelected;
/// Create a copy of ProductVariant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductVariantCopyWith<ProductVariant> get copyWith => _$ProductVariantCopyWithImpl<ProductVariant>(this as ProductVariant, _$identity);

  /// Serializes this ProductVariant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductVariant&&(identical(other.colorName, colorName) || other.colorName == colorName)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.size, size) || other.size == size)&&(identical(other.price, price) || other.price == price)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,colorName,colorHex,size,price,stock,sku,isSelected);

@override
String toString() {
  return 'ProductVariant(colorName: $colorName, colorHex: $colorHex, size: $size, price: $price, stock: $stock, sku: $sku, isSelected: $isSelected)';
}


}

/// @nodoc
abstract mixin class $ProductVariantCopyWith<$Res>  {
  factory $ProductVariantCopyWith(ProductVariant value, $Res Function(ProductVariant) _then) = _$ProductVariantCopyWithImpl;
@useResult
$Res call({
 String colorName, String colorHex, String size, String price, String stock, String sku, bool isSelected
});




}
/// @nodoc
class _$ProductVariantCopyWithImpl<$Res>
    implements $ProductVariantCopyWith<$Res> {
  _$ProductVariantCopyWithImpl(this._self, this._then);

  final ProductVariant _self;
  final $Res Function(ProductVariant) _then;

/// Create a copy of ProductVariant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? colorName = null,Object? colorHex = null,Object? size = null,Object? price = null,Object? stock = null,Object? sku = null,Object? isSelected = null,}) {
  return _then(_self.copyWith(
colorName: null == colorName ? _self.colorName : colorName // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductVariant].
extension ProductVariantPatterns on ProductVariant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductVariant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductVariant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductVariant value)  $default,){
final _that = this;
switch (_that) {
case _ProductVariant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductVariant value)?  $default,){
final _that = this;
switch (_that) {
case _ProductVariant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String colorName,  String colorHex,  String size,  String price,  String stock,  String sku,  bool isSelected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductVariant() when $default != null:
return $default(_that.colorName,_that.colorHex,_that.size,_that.price,_that.stock,_that.sku,_that.isSelected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String colorName,  String colorHex,  String size,  String price,  String stock,  String sku,  bool isSelected)  $default,) {final _that = this;
switch (_that) {
case _ProductVariant():
return $default(_that.colorName,_that.colorHex,_that.size,_that.price,_that.stock,_that.sku,_that.isSelected);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String colorName,  String colorHex,  String size,  String price,  String stock,  String sku,  bool isSelected)?  $default,) {final _that = this;
switch (_that) {
case _ProductVariant() when $default != null:
return $default(_that.colorName,_that.colorHex,_that.size,_that.price,_that.stock,_that.sku,_that.isSelected);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductVariant implements ProductVariant {
  const _ProductVariant({required this.colorName, required this.colorHex, required this.size, required this.price, required this.stock, required this.sku, this.isSelected = false});
  factory _ProductVariant.fromJson(Map<String, dynamic> json) => _$ProductVariantFromJson(json);

@override final  String colorName;
@override final  String colorHex;
@override final  String size;
@override final  String price;
@override final  String stock;
@override final  String sku;
@override@JsonKey() final  bool isSelected;

/// Create a copy of ProductVariant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductVariantCopyWith<_ProductVariant> get copyWith => __$ProductVariantCopyWithImpl<_ProductVariant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductVariantToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductVariant&&(identical(other.colorName, colorName) || other.colorName == colorName)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.size, size) || other.size == size)&&(identical(other.price, price) || other.price == price)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,colorName,colorHex,size,price,stock,sku,isSelected);

@override
String toString() {
  return 'ProductVariant(colorName: $colorName, colorHex: $colorHex, size: $size, price: $price, stock: $stock, sku: $sku, isSelected: $isSelected)';
}


}

/// @nodoc
abstract mixin class _$ProductVariantCopyWith<$Res> implements $ProductVariantCopyWith<$Res> {
  factory _$ProductVariantCopyWith(_ProductVariant value, $Res Function(_ProductVariant) _then) = __$ProductVariantCopyWithImpl;
@override @useResult
$Res call({
 String colorName, String colorHex, String size, String price, String stock, String sku, bool isSelected
});




}
/// @nodoc
class __$ProductVariantCopyWithImpl<$Res>
    implements _$ProductVariantCopyWith<$Res> {
  __$ProductVariantCopyWithImpl(this._self, this._then);

  final _ProductVariant _self;
  final $Res Function(_ProductVariant) _then;

/// Create a copy of ProductVariant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? colorName = null,Object? colorHex = null,Object? size = null,Object? price = null,Object? stock = null,Object? sku = null,Object? isSelected = null,}) {
  return _then(_ProductVariant(
colorName: null == colorName ? _self.colorName : colorName // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$MultipleProductsState {

 String get productName; String get productId; String get stockQuantity; String get sellingPrice; String get productDescription; String? get category; String? get subCategory; int get currentStep; int get totalSteps; List<String> get imagePaths; String? get videoPath; List<ProductVariant> get variants; bool get selectAll; bool get isCustomSizeMode; bool get showVariant; String? get selectedColorName; String? get selectedColorHex; String? get selectedSize;
/// Create a copy of MultipleProductsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MultipleProductsStateCopyWith<MultipleProductsState> get copyWith => _$MultipleProductsStateCopyWithImpl<MultipleProductsState>(this as MultipleProductsState, _$identity);

  /// Serializes this MultipleProductsState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MultipleProductsState&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.productDescription, productDescription) || other.productDescription == productDescription)&&(identical(other.category, category) || other.category == category)&&(identical(other.subCategory, subCategory) || other.subCategory == subCategory)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.totalSteps, totalSteps) || other.totalSteps == totalSteps)&&const DeepCollectionEquality().equals(other.imagePaths, imagePaths)&&(identical(other.videoPath, videoPath) || other.videoPath == videoPath)&&const DeepCollectionEquality().equals(other.variants, variants)&&(identical(other.selectAll, selectAll) || other.selectAll == selectAll)&&(identical(other.isCustomSizeMode, isCustomSizeMode) || other.isCustomSizeMode == isCustomSizeMode)&&(identical(other.showVariant, showVariant) || other.showVariant == showVariant)&&(identical(other.selectedColorName, selectedColorName) || other.selectedColorName == selectedColorName)&&(identical(other.selectedColorHex, selectedColorHex) || other.selectedColorHex == selectedColorHex)&&(identical(other.selectedSize, selectedSize) || other.selectedSize == selectedSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productName,productId,stockQuantity,sellingPrice,productDescription,category,subCategory,currentStep,totalSteps,const DeepCollectionEquality().hash(imagePaths),videoPath,const DeepCollectionEquality().hash(variants),selectAll,isCustomSizeMode,showVariant,selectedColorName,selectedColorHex,selectedSize);

@override
String toString() {
  return 'MultipleProductsState(productName: $productName, productId: $productId, stockQuantity: $stockQuantity, sellingPrice: $sellingPrice, productDescription: $productDescription, category: $category, subCategory: $subCategory, currentStep: $currentStep, totalSteps: $totalSteps, imagePaths: $imagePaths, videoPath: $videoPath, variants: $variants, selectAll: $selectAll, isCustomSizeMode: $isCustomSizeMode, showVariant: $showVariant, selectedColorName: $selectedColorName, selectedColorHex: $selectedColorHex, selectedSize: $selectedSize)';
}


}

/// @nodoc
abstract mixin class $MultipleProductsStateCopyWith<$Res>  {
  factory $MultipleProductsStateCopyWith(MultipleProductsState value, $Res Function(MultipleProductsState) _then) = _$MultipleProductsStateCopyWithImpl;
@useResult
$Res call({
 String productName, String productId, String stockQuantity, String sellingPrice, String productDescription, String? category, String? subCategory, int currentStep, int totalSteps, List<String> imagePaths, String? videoPath, List<ProductVariant> variants, bool selectAll, bool isCustomSizeMode, bool showVariant, String? selectedColorName, String? selectedColorHex, String? selectedSize
});




}
/// @nodoc
class _$MultipleProductsStateCopyWithImpl<$Res>
    implements $MultipleProductsStateCopyWith<$Res> {
  _$MultipleProductsStateCopyWithImpl(this._self, this._then);

  final MultipleProductsState _self;
  final $Res Function(MultipleProductsState) _then;

/// Create a copy of MultipleProductsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productName = null,Object? productId = null,Object? stockQuantity = null,Object? sellingPrice = null,Object? productDescription = null,Object? category = freezed,Object? subCategory = freezed,Object? currentStep = null,Object? totalSteps = null,Object? imagePaths = null,Object? videoPath = freezed,Object? variants = null,Object? selectAll = null,Object? isCustomSizeMode = null,Object? showVariant = null,Object? selectedColorName = freezed,Object? selectedColorHex = freezed,Object? selectedSize = freezed,}) {
  return _then(_self.copyWith(
productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as String,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as String,productDescription: null == productDescription ? _self.productDescription : productDescription // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,subCategory: freezed == subCategory ? _self.subCategory : subCategory // ignore: cast_nullable_to_non_nullable
as String?,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,totalSteps: null == totalSteps ? _self.totalSteps : totalSteps // ignore: cast_nullable_to_non_nullable
as int,imagePaths: null == imagePaths ? _self.imagePaths : imagePaths // ignore: cast_nullable_to_non_nullable
as List<String>,videoPath: freezed == videoPath ? _self.videoPath : videoPath // ignore: cast_nullable_to_non_nullable
as String?,variants: null == variants ? _self.variants : variants // ignore: cast_nullable_to_non_nullable
as List<ProductVariant>,selectAll: null == selectAll ? _self.selectAll : selectAll // ignore: cast_nullable_to_non_nullable
as bool,isCustomSizeMode: null == isCustomSizeMode ? _self.isCustomSizeMode : isCustomSizeMode // ignore: cast_nullable_to_non_nullable
as bool,showVariant: null == showVariant ? _self.showVariant : showVariant // ignore: cast_nullable_to_non_nullable
as bool,selectedColorName: freezed == selectedColorName ? _self.selectedColorName : selectedColorName // ignore: cast_nullable_to_non_nullable
as String?,selectedColorHex: freezed == selectedColorHex ? _self.selectedColorHex : selectedColorHex // ignore: cast_nullable_to_non_nullable
as String?,selectedSize: freezed == selectedSize ? _self.selectedSize : selectedSize // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MultipleProductsState].
extension MultipleProductsStatePatterns on MultipleProductsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MultipleProductsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MultipleProductsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MultipleProductsState value)  $default,){
final _that = this;
switch (_that) {
case _MultipleProductsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MultipleProductsState value)?  $default,){
final _that = this;
switch (_that) {
case _MultipleProductsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productName,  String productId,  String stockQuantity,  String sellingPrice,  String productDescription,  String? category,  String? subCategory,  int currentStep,  int totalSteps,  List<String> imagePaths,  String? videoPath,  List<ProductVariant> variants,  bool selectAll,  bool isCustomSizeMode,  bool showVariant,  String? selectedColorName,  String? selectedColorHex,  String? selectedSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MultipleProductsState() when $default != null:
return $default(_that.productName,_that.productId,_that.stockQuantity,_that.sellingPrice,_that.productDescription,_that.category,_that.subCategory,_that.currentStep,_that.totalSteps,_that.imagePaths,_that.videoPath,_that.variants,_that.selectAll,_that.isCustomSizeMode,_that.showVariant,_that.selectedColorName,_that.selectedColorHex,_that.selectedSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productName,  String productId,  String stockQuantity,  String sellingPrice,  String productDescription,  String? category,  String? subCategory,  int currentStep,  int totalSteps,  List<String> imagePaths,  String? videoPath,  List<ProductVariant> variants,  bool selectAll,  bool isCustomSizeMode,  bool showVariant,  String? selectedColorName,  String? selectedColorHex,  String? selectedSize)  $default,) {final _that = this;
switch (_that) {
case _MultipleProductsState():
return $default(_that.productName,_that.productId,_that.stockQuantity,_that.sellingPrice,_that.productDescription,_that.category,_that.subCategory,_that.currentStep,_that.totalSteps,_that.imagePaths,_that.videoPath,_that.variants,_that.selectAll,_that.isCustomSizeMode,_that.showVariant,_that.selectedColorName,_that.selectedColorHex,_that.selectedSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productName,  String productId,  String stockQuantity,  String sellingPrice,  String productDescription,  String? category,  String? subCategory,  int currentStep,  int totalSteps,  List<String> imagePaths,  String? videoPath,  List<ProductVariant> variants,  bool selectAll,  bool isCustomSizeMode,  bool showVariant,  String? selectedColorName,  String? selectedColorHex,  String? selectedSize)?  $default,) {final _that = this;
switch (_that) {
case _MultipleProductsState() when $default != null:
return $default(_that.productName,_that.productId,_that.stockQuantity,_that.sellingPrice,_that.productDescription,_that.category,_that.subCategory,_that.currentStep,_that.totalSteps,_that.imagePaths,_that.videoPath,_that.variants,_that.selectAll,_that.isCustomSizeMode,_that.showVariant,_that.selectedColorName,_that.selectedColorHex,_that.selectedSize);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MultipleProductsState implements MultipleProductsState {
  const _MultipleProductsState({this.productName = '', this.productId = '', this.stockQuantity = '', this.sellingPrice = '', this.productDescription = '', this.category, this.subCategory, this.currentStep = 1, this.totalSteps = 3, final  List<String> imagePaths = const [], this.videoPath, final  List<ProductVariant> variants = const [], this.selectAll = false, this.isCustomSizeMode = false, this.showVariant = false, this.selectedColorName, this.selectedColorHex, this.selectedSize}): _imagePaths = imagePaths,_variants = variants;
  factory _MultipleProductsState.fromJson(Map<String, dynamic> json) => _$MultipleProductsStateFromJson(json);

@override@JsonKey() final  String productName;
@override@JsonKey() final  String productId;
@override@JsonKey() final  String stockQuantity;
@override@JsonKey() final  String sellingPrice;
@override@JsonKey() final  String productDescription;
@override final  String? category;
@override final  String? subCategory;
@override@JsonKey() final  int currentStep;
@override@JsonKey() final  int totalSteps;
 final  List<String> _imagePaths;
@override@JsonKey() List<String> get imagePaths {
  if (_imagePaths is EqualUnmodifiableListView) return _imagePaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imagePaths);
}

@override final  String? videoPath;
 final  List<ProductVariant> _variants;
@override@JsonKey() List<ProductVariant> get variants {
  if (_variants is EqualUnmodifiableListView) return _variants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_variants);
}

@override@JsonKey() final  bool selectAll;
@override@JsonKey() final  bool isCustomSizeMode;
@override@JsonKey() final  bool showVariant;
@override final  String? selectedColorName;
@override final  String? selectedColorHex;
@override final  String? selectedSize;

/// Create a copy of MultipleProductsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MultipleProductsStateCopyWith<_MultipleProductsState> get copyWith => __$MultipleProductsStateCopyWithImpl<_MultipleProductsState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MultipleProductsStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MultipleProductsState&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.productDescription, productDescription) || other.productDescription == productDescription)&&(identical(other.category, category) || other.category == category)&&(identical(other.subCategory, subCategory) || other.subCategory == subCategory)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.totalSteps, totalSteps) || other.totalSteps == totalSteps)&&const DeepCollectionEquality().equals(other._imagePaths, _imagePaths)&&(identical(other.videoPath, videoPath) || other.videoPath == videoPath)&&const DeepCollectionEquality().equals(other._variants, _variants)&&(identical(other.selectAll, selectAll) || other.selectAll == selectAll)&&(identical(other.isCustomSizeMode, isCustomSizeMode) || other.isCustomSizeMode == isCustomSizeMode)&&(identical(other.showVariant, showVariant) || other.showVariant == showVariant)&&(identical(other.selectedColorName, selectedColorName) || other.selectedColorName == selectedColorName)&&(identical(other.selectedColorHex, selectedColorHex) || other.selectedColorHex == selectedColorHex)&&(identical(other.selectedSize, selectedSize) || other.selectedSize == selectedSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productName,productId,stockQuantity,sellingPrice,productDescription,category,subCategory,currentStep,totalSteps,const DeepCollectionEquality().hash(_imagePaths),videoPath,const DeepCollectionEquality().hash(_variants),selectAll,isCustomSizeMode,showVariant,selectedColorName,selectedColorHex,selectedSize);

@override
String toString() {
  return 'MultipleProductsState(productName: $productName, productId: $productId, stockQuantity: $stockQuantity, sellingPrice: $sellingPrice, productDescription: $productDescription, category: $category, subCategory: $subCategory, currentStep: $currentStep, totalSteps: $totalSteps, imagePaths: $imagePaths, videoPath: $videoPath, variants: $variants, selectAll: $selectAll, isCustomSizeMode: $isCustomSizeMode, showVariant: $showVariant, selectedColorName: $selectedColorName, selectedColorHex: $selectedColorHex, selectedSize: $selectedSize)';
}


}

/// @nodoc
abstract mixin class _$MultipleProductsStateCopyWith<$Res> implements $MultipleProductsStateCopyWith<$Res> {
  factory _$MultipleProductsStateCopyWith(_MultipleProductsState value, $Res Function(_MultipleProductsState) _then) = __$MultipleProductsStateCopyWithImpl;
@override @useResult
$Res call({
 String productName, String productId, String stockQuantity, String sellingPrice, String productDescription, String? category, String? subCategory, int currentStep, int totalSteps, List<String> imagePaths, String? videoPath, List<ProductVariant> variants, bool selectAll, bool isCustomSizeMode, bool showVariant, String? selectedColorName, String? selectedColorHex, String? selectedSize
});




}
/// @nodoc
class __$MultipleProductsStateCopyWithImpl<$Res>
    implements _$MultipleProductsStateCopyWith<$Res> {
  __$MultipleProductsStateCopyWithImpl(this._self, this._then);

  final _MultipleProductsState _self;
  final $Res Function(_MultipleProductsState) _then;

/// Create a copy of MultipleProductsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productName = null,Object? productId = null,Object? stockQuantity = null,Object? sellingPrice = null,Object? productDescription = null,Object? category = freezed,Object? subCategory = freezed,Object? currentStep = null,Object? totalSteps = null,Object? imagePaths = null,Object? videoPath = freezed,Object? variants = null,Object? selectAll = null,Object? isCustomSizeMode = null,Object? showVariant = null,Object? selectedColorName = freezed,Object? selectedColorHex = freezed,Object? selectedSize = freezed,}) {
  return _then(_MultipleProductsState(
productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as String,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as String,productDescription: null == productDescription ? _self.productDescription : productDescription // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,subCategory: freezed == subCategory ? _self.subCategory : subCategory // ignore: cast_nullable_to_non_nullable
as String?,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,totalSteps: null == totalSteps ? _self.totalSteps : totalSteps // ignore: cast_nullable_to_non_nullable
as int,imagePaths: null == imagePaths ? _self._imagePaths : imagePaths // ignore: cast_nullable_to_non_nullable
as List<String>,videoPath: freezed == videoPath ? _self.videoPath : videoPath // ignore: cast_nullable_to_non_nullable
as String?,variants: null == variants ? _self._variants : variants // ignore: cast_nullable_to_non_nullable
as List<ProductVariant>,selectAll: null == selectAll ? _self.selectAll : selectAll // ignore: cast_nullable_to_non_nullable
as bool,isCustomSizeMode: null == isCustomSizeMode ? _self.isCustomSizeMode : isCustomSizeMode // ignore: cast_nullable_to_non_nullable
as bool,showVariant: null == showVariant ? _self.showVariant : showVariant // ignore: cast_nullable_to_non_nullable
as bool,selectedColorName: freezed == selectedColorName ? _self.selectedColorName : selectedColorName // ignore: cast_nullable_to_non_nullable
as String?,selectedColorHex: freezed == selectedColorHex ? _self.selectedColorHex : selectedColorHex // ignore: cast_nullable_to_non_nullable
as String?,selectedSize: freezed == selectedSize ? _self.selectedSize : selectedSize // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
