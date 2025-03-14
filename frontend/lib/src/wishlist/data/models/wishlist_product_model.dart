import 'dart:convert';

import 'package:frontend/core/utils/typedefs.dart';
import 'package:frontend/src/wishlist/domain/entities/wishlist_product.dart';

class WishlistProductModel extends WishlistProduct {
  const WishlistProductModel({
    required super.productId,
    required super.productName,
    required super.productImage,
    required super.productPrice,
    required super.productExits,
    required super.productOutOfStock,
  });

  const WishlistProductModel.empty()
      : this(
          productId: 'Test String',
          productName: 'Test String',
          productImage: 'Test String',
          productPrice: 1.0,
          productExits: true,
          productOutOfStock: true,
        );

  factory WishlistProductModel.fromJson(String source) =>
      WishlistProductModel.fromMap(jsonDecode(source) as DataMap);

  WishlistProductModel.fromMap(DataMap map)
      : this(
          productId: map['productId'] as String,
          productName: map['productName'] as String,
          productImage: map['productImage'] as String,
          productPrice: (map['productPrice'] as num).toDouble(),
          productExits: map['productExits'] as bool,
          productOutOfStock: map['productOutOfStock'] as bool,
        );

  WishlistProductModel copyWith({
    String? productId,
    String? productName,
    String? productImage,
    double? productPrice,
    bool? productExits,
    bool? productOutOfStock,
  }) {
    return WishlistProductModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      productPrice: productPrice ?? this.productPrice,
      productExits: productExits ?? this.productExits,
      productOutOfStock: productOutOfStock ?? this.productOutOfStock,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'productPrice': productPrice,
      'productExits': productExits,
      'productOutOfStock': productOutOfStock,
    };
  }

  String toJson() => jsonDecode(toMap() as String);
}
