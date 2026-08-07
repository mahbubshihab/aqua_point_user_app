import '../../domain/entities/product_entity.dart';

class ProductsMockDatasource {
  final List<ProductEntity> _products = [];

  Future<List<ProductEntity>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_products);
  }

  Future<void> addProduct(ProductEntity product) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _products.insert(0, product);
  }
}
