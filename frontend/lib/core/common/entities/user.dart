import 'package:equatable/equatable.dart';
import 'package:frontend/core/common/entities/address.dart';
import 'package:frontend/src/wishlist/domain/entities/wishlist_product.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final bool isAdmin;
  final List<WishlistProduct> wishlish;
  final Address? address;
  final String? phone;

  @override
  List<Object> get props => [id, name, email, isAdmin, wishlish.length];

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.isAdmin,
    required this.wishlish,
    this.address,
    this.phone,
  });

  const User.empty()
      : id = "test String",
        name = "test String",
        email = "test String",
        isAdmin = true,
        wishlish = const [],
        address = null,
        phone = null;
}
