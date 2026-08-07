import '../../domain/entities/product_entity.dart';

class ProductsMockDatasource {
  final List<ProductEntity> _products = [
    const ProductEntity(
      id: 'PROD-101',
      name: 'Aqua Point Premium RO System',
      photoUrl: 'https://images.unsplash.com/photo-1548839140-29a749e1bc4e',
      warrantyDetails: '1 Year Active Warranty',
      purchaseDate: '15 Jan 2026',
      isCustom: false,
    ),
    const ProductEntity(
      id: 'PROD-102',
      name: 'Smart Alkaline Filter Cartridge',
      photoUrl: 'https://images.unsplash.com/photo-1527613426441-4da17471b66d',
      warrantyDetails: '6 Months Active Warranty',
      purchaseDate: '10 Feb 2026',
      isCustom: false,
    ),
  ];

  Future<List<ProductEntity>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_products);
  }

  Future<void> addProduct(ProductEntity product) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _products.insert(0, product);
  }
}
