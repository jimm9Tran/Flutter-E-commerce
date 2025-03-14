import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String? street;
  final String? apartment;
  final String? city;
  final String? postalCode;
  final String? country;

  const Address({
    required this.street,
    required this.apartment,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  bool get isEmpty =>
      street == null &&
      apartment == null &&
      city == null &&
      postalCode == null &&
      country == null;

  bool get isNotEmpty =>
      street != null &&
      apartment != null &&
      city != null &&
      postalCode != null &&
      country != null;
  @override
  List<Object?> get props => [street, apartment, city, postalCode, country];
}
