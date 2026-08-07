import '../entities/category_entity.dart';
import '../entities/product_entity.dart';

abstract class ProductsRepository {
  Future<List<ProductEntity>> getProducts();
  Future<List<CategoryEntity>> getCategories();
  Future<void> addProduct(ProductEntity product);
}
