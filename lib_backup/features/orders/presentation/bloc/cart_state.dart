import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  final double shippingFee;

  const CartState({
    this.items = const [],
    this.shippingFee = 60.0,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get totalAmount => items.isEmpty ? 0.0 : subtotal + shippingFee;
  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    List<CartItem>? items,
    double? shippingFee,
  }) {
    return CartState(
      items: items ?? this.items,
      shippingFee: shippingFee ?? this.shippingFee,
    );
  }

  @override
  List<Object?> get props => [items, shippingFee];
}
