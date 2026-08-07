import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_mock_datasource.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsMockDatasource datasource;

  ProductsRepositoryImpl({required this.datasource});

  @override
  Future<List<ProductEntity>> getProducts() async {
    return await datasource.fetchProducts();
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    return await datasource.fetchCategories();
  }

  @override
  Future<void> addProduct(ProductEntity product) async {
    await datasource.addProduct(product);
  }
}
