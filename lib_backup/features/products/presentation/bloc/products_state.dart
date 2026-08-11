import 'package:equatable/equatable.dart';
import '../../domain/entities/category_entity.dart';
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
  final List<ProductEntity> myProducts;
  final List<CategoryEntity> categories;

  const ProductsLoaded(
    this.products, {
    this.myProducts = const [],
    this.categories = const [],
  });

  @override
  List<Object?> get props => [products, myProducts, categories];
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
