import 'dart:convert';

import 'package:frontend/core/common/entities/address.dart';
import 'package:frontend/core/common/entities/user.dart';
import 'package:frontend/core/utils/typedefs.dart';
import 'package:frontend/core/common/models/address_model.dart';
import 'package:frontend/src/wishlist/data/models/wishlist_product_model.dart';
import 'package:frontend/src/wishlist/domain/entities/wishlist_product.dart';

class UserModel extends User {
  const UserModel(
      {required super.id,
      required super.name,
      required super.email,
      required super.isAdmin,
      required super.wishlish,
      super.address,
      super.phone});

  User copyWith({
    String? id,
    String? name,
    String? email,
    bool? isAdmin,
    List<WishlistProduct>? wishlish,
    Address? address,
    String? phone,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isAdmin: isAdmin ?? this.isAdmin,
      wishlish: wishlish ?? this.wishlish,
      address: address ?? this.address,
      phone: phone ?? this.phone,
    );
  }

  const UserModel.empty()
      : this(
            id: "test String",
            name: "test String",
            email: "test String",
            isAdmin: true,
            wishlish: const [],
            address: null,
            phone: null);

  DataMap toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isAdmin': isAdmin,
      'wishlish': wishlish
          .map((product) => (product as WishlistProductModel).toMap())
          .toList(),
      if (address != null) 'address': (address as AddressModel).toMap(),
      if (phone != null) 'phone': phone
    };
  }

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final address = AddressModel.fromMap({
      if (map case {'street': String street}) 'street': street,
      if (map case {'apartment': String apartment}) 'apartment': apartment,
      if (map case {'city': String city}) 'city': city,
      if (map case {'postalCode': String postalCode}) 'postalCode': postalCode,
      if (map case {'country': String country}) 'country': country,
    });
    return UserModel(
      id: map['id'] as String? ?? map['_id'] as String,
      name: map['name'],
      email: map['email'],
      isAdmin: map['isAdmin'],
      wishlish: List<DataMap>.from(map['wishlish'] as List)
          .map(WishlistProductModel.fromMap)
          .toList(),
      address: address.isEmpty ? null : address,
      phone: map['phone'],
    );
  }

  String toJson() => jsonEncode(toMap());
}

// 4:17:16