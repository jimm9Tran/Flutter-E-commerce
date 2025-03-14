import 'package:equatable/equatable.dart';

class WishlistProduct extends Equatable {
  const WishlistProduct({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.productExits,
    required this.productOutOfStock,
  });
  final String productId;
  final String productName;
  final String productImage;
  final double productPrice;
  final bool productExits;
  final bool productOutOfStock;
  @override
  List<dynamic> get props => [
        productId,
        productName,
        productImage,
        productPrice,
        productExits,
        productOutOfStock
      ];

  const WishlistProduct.empty()
      : productId = 'Test String',
        productName = 'Test String',
        productImage = 'Test String',
        productPrice = 1.0,
        productExits = true,
        productOutOfStock = true;
}
