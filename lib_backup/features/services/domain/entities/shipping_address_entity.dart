import 'package:equatable/equatable.dart';

class ShippingAddressEntity extends Equatable {
  final String id;
  final String addressLine;
  final String city;
  final bool isDefault;

  const ShippingAddressEntity({
    required this.id,
    required this.addressLine,
    required this.city,
    required this.isDefault,
  });

  String get fullAddress => '$addressLine, $city';

  @override
  List<Object?> get props => [id, addressLine, city, isDefault];
}
