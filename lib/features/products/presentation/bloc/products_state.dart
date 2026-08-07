import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsLoaded extends ProductsState {
  final List<ProductEntity> products;

  const ProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductAdding extends ProductsState {
  const ProductAdding();
}

class ProductAddSuccess extends ProductsState {
  const ProductAddSuccess();
}

class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object?> get props => [message];
}
