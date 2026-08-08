import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../models/product_model.dart';

class ProductsMockDatasource {
  final List<ProductEntity> _customProducts = [];

  static const List<CategoryEntity> defaultCategories = [
    CategoryEntity(
      id: 'cat_ro',
      name: 'RO Water Purifiers',
      icon: 'water_drop',
      imageUrl: 'https://images.unsplash.com/photo-1548839140-29a749e1cf4e?w=500&q=80',
    ),
    CategoryEntity(
      id: 'cat_filters',
      name: 'Filter Cartridges',
      icon: 'filter_alt',
      imageUrl: 'https://images.unsplash.com/photo-1617155093730-a8bf47be792d?w=500&q=80',
    ),
    CategoryEntity(
      id: 'cat_membranes',
      name: 'Membranes & Filters',
      icon: 'blur_on',
      imageUrl: 'https://images.unsplash.com/photo-1585837575652-267c041d77d4?w=500&q=80',
    ),
    CategoryEntity(
      id: 'cat_uv_uf',
      name: 'UV & UF Systems',
      icon: 'wb_sunny',
      imageUrl: 'https://images.unsplash.com/photo-1527613426441-4da17471b66d?w=500&q=80',
    ),
    CategoryEntity(
      id: 'cat_parts',
      name: 'Accessories & Parts',
      icon: 'build',
      imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=500&q=80',
    ),
  ];

  static const List<ProductEntity> defaultProducts = [
    ProductEntity(
      id: 'p1',
      name: 'Aqua Point Pro Max RO+UV+UF',
      photoUrl: 'https://images.unsplash.com/photo-1548839140-29a749e1cf4e?w=600&q=80',
      images: [
        'https://images.unsplash.com/photo-1548839140-29a749e1cf4e?w=600&q=80',
        'https://images.unsplash.com/photo-1585837575652-267c041d77d4?w=600&q=80',
        'https://images.unsplash.com/photo-1617155093730-a8bf47be792d?w=600&q=80',
        'https://images.unsplash.com/photo-1527613426441-4da17471b66d?w=600&q=80',
      ],
      warrantyDetails: '2 Years Official Warranty',
      purchaseDate: 'Available',
      price: 14500.0,
      originalPrice: 18000.0,
      category: 'RO Water Purifiers',
      rating: 4.9,
      reviewsCount: 142,
      description: 'Advanced 7-stage RO+UV+UF+Alkaline purification system for home and office.',
    ),
    ProductEntity(
      id: 'p2',
      name: 'Aqua Pure Smart Alkaline RO',
      photoUrl: 'https://images.unsplash.com/photo-1585837575652-267c041d77d4?w=600&q=80',
      images: [
        'https://images.unsplash.com/photo-1585837575652-267c041d77d4?w=600&q=80',
        'https://images.unsplash.com/photo-1548839140-29a749e1cf4e?w=600&q=80',
        'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=600&q=80',
      ],
      warrantyDetails: '2 Years Official Warranty',
      purchaseDate: 'Available',
      price: 18900.0,
      originalPrice: 22500.0,
      category: 'RO Water Purifiers',
      rating: 4.8,
      reviewsCount: 98,
      description: 'Smart IoT enabled water purifier with real-time TDS and filter life display.',
    ),
    ProductEntity(
      id: 'p3',
      name: 'Aqua Shield Countertop RO',
      photoUrl: 'https://images.unsplash.com/photo-1617155093730-a8bf47be792d?w=600&q=80',
      images: [
        'https://images.unsplash.com/photo-1617155093730-a8bf47be792d?w=600&q=80',
        'https://images.unsplash.com/photo-1548839140-29a749e1cf4e?w=600&q=80',
      ],
      warrantyDetails: '1 Year Official Warranty',
      purchaseDate: 'Available',
      price: 11200.0,
      originalPrice: 13500.0,
      category: 'RO Water Purifiers',
      rating: 4.7,
      reviewsCount: 64,
      description: 'Sleek, compact countertop RO purifier perfect for modern kitchens.',
    ),
    ProductEntity(
      id: 'p4',
      name: '5-Stage Pre-Filter Cartridge Set',
      photoUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=600&q=80',
      images: [
        'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=600&q=80',
        'https://images.unsplash.com/photo-1527613426441-4da17471b66d?w=600&q=80',
        'https://images.unsplash.com/photo-1585837575652-267c041d77d4?w=600&q=80',
      ],
      warrantyDetails: '6 Months Replacement Warranty',
      purchaseDate: 'Available',
      price: 1200.0,
      originalPrice: 1500.0,
      category: 'Filter Cartridges',
      rating: 4.9,
      reviewsCount: 210,
      description: 'High-density sediment, GAC, and CTO carbon block filter set.',
    ),
    ProductEntity(
      id: 'p5',
      name: 'Dual Sediment & Carbon Filter',
      photoUrl: 'https://images.unsplash.com/photo-1527613426441-4da17471b66d?w=600&q=80',
      images: [
        'https://images.unsplash.com/photo-1527613426441-4da17471b66d?w=600&q=80',
        'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=600&q=80',
      ],
      warrantyDetails: '6 Months Warranty',
      purchaseDate: 'Available',
      price: 650.0,
      originalPrice: 850.0,
      category: 'Filter Cartridges',
      rating: 4.8,
      reviewsCount: 88,
      description: 'Removes chlorine, bad odor, fine particles, and rust from tap water.',
    ),
    ProductEntity(
      id: 'p6',
      name: 'Post Carbon Taste Enhancer Filter',
      photoUrl: 'https://images.unsplash.com/photo-1548839140-29a749e1cf4e?w=600&q=80',
      images: [
        'https://images.unsplash.com/photo-1548839140-29a749e1cf4e?w=600&q=80',
        'https://images.unsplash.com/photo-1585837575652-267c041d77d4?w=600&q=80',
      ],
      warrantyDetails: '6 Months Warranty',
      purchaseDate: 'Available',
      price: 450.0,
      originalPrice: 600.0,
      category: 'Filter Cartridges',
      rating: 4.6,
      reviewsCount: 54,
      description: 'Restores natural mineral taste and balances pH level in purified water.',
    ),
    ProductEntity(
      id: 'p7',
      name: 'Hi-Tech 100 GPD RO Membrane',
      photoUrl: 'https://images.unsplash.com/photo-1585837575652-267c041d77d4?w=600&q=80',
      images: [
        'https://images.unsplash.com/photo-1585837575652-267c041d77d4?w=600&q=80',
        'https://images.unsplash.com/photo-1617155093730-a8bf47be792d?w=600&q=80',
      ],
      warrantyDetails: '1 Year Warranty',
      purchaseDate: 'Available',
      price: 1850.0,
      originalPrice: 2200.0,
      category: 'Membranes & Filters',
      rating: 4.9,
      reviewsCount: 175,
      description: 'High rejection 0.0001 micron polyamide thin-film composite membrane.',
    ),
    ProductEntity(
      id: 'p8',
      name: 'Vontron 75 GPD High Recovery Membrane',
      photoUrl: 'https://images.unsplash.com/photo-1617155093730-a8bf47be792d?w=600&q=80',
      images: [
        'https://images.unsplash.com/photo-1617155093730-a8bf47be792d?w=600&q=80',
        'https://images.unsplash.com/photo-1548839140-29a749e1cf4e?w=600&q=80',
      ],
      warrantyDetails: '1 Year Warranty',
      purchaseDate: 'Available',
      price: 1600.0,
      originalPrice: 1950.0,
      category: 'Membranes & Filters',
      rating: 4.8,
      reviewsCount: 119,
      description: 'Reduces water waste by up to 40% with ultra-efficient filtration.',
    ),
    ProductEntity(
      id: 'p9',
      name: 'Stainless Steel UV Disinfection Chamber 11W',
      photoUrl: 'https://images.unsplash.com/photo-1527613426441-4da17471b66d?w=600&q=80',
      images: [
        'https://images.unsplash.com/photo-1527613426441-4da17471b66d?w=600&q=80',
        'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=600&q=80',
      ],
      warrantyDetails: '1 Year Warranty',
      purchaseDate: 'Available',
      price: 2400.0,
      originalPrice: 2900.0,
      category: 'UV & UF Systems',
      rating: 4.7,
      reviewsCount: 76,
      description: 'Kills 99.99% of bacteria and viruses without chemical treatment.',
    ),
    ProductEntity(
      id: 'p10',
      name: 'Hollow Fiber UF Ultrafiltration Membrane',
      photoUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=600&q=80',
      images: [
        'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=600&q=80',
        'https://images.unsplash.com/photo-1527613426441-4da17471b66d?w=600&q=80',
      ],
      warrantyDetails: '1 Year Warranty',
      purchaseDate: 'Available',
      price: 950.0,
      originalPrice: 1200.0,
      category: 'UV & UF Systems',
      rating: 4.8,
      reviewsCount: 62,
      description: '0.01 micron mechanical filtration retaining essential minerals.',
    ),
    ProductEntity(
      id: 'p11',
      name: 'High Pressure Booster Pump 24V DC',
      photoUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=600&q=80',
      images: [
        'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=600&q=80',
        'https://images.unsplash.com/photo-1585837575652-267c041d77d4?w=600&q=80',
      ],
      warrantyDetails: '1 Year Warranty',
      purchaseDate: 'Available',
      price: 2100.0,
      originalPrice: 2600.0,
      category: 'Accessories & Parts',
      rating: 4.9,
      reviewsCount: 130,
      description: 'Heavy duty silent booster pump for low water pressure homes.',
    ),
    ProductEntity(
      id: 'p12',
      name: 'Automatic Solenoid Valve & High Cut-off Switch',
      photoUrl: 'https://images.unsplash.com/photo-1585837575652-267c041d77d4?w=600&q=80',
      images: [
        'https://images.unsplash.com/photo-1585837575652-267c041d77d4?w=600&q=80',
        'https://images.unsplash.com/photo-1548839140-29a749e1cf4e?w=600&q=80',
      ],
      warrantyDetails: '6 Months Warranty',
      purchaseDate: 'Available',
      price: 480.0,
      originalPrice: 650.0,
      category: 'Accessories & Parts',
      rating: 4.7,
      reviewsCount: 45,
      description: 'Prevents water overflow and automatically stops pump when tank is full.',
    ),
    ProductEntity(
      id: 'p13',
      name: 'Digital TDS Testing Meter Pen',
      photoUrl: 'https://images.unsplash.com/photo-1548839140-29a749e1cf4e?w=600&q=80',
      images: [
        'https://images.unsplash.com/photo-1548839140-29a749e1cf4e?w=600&q=80',
        'https://images.unsplash.com/photo-1617155093730-a8bf47be792d?w=600&q=80',
      ],
      warrantyDetails: '1 Year Replacement Warranty',
      purchaseDate: 'Available',
      price: 350.0,
      originalPrice: 500.0,
      category: 'Accessories & Parts',
      rating: 4.8,
      reviewsCount: 290,
      description: 'Accurate handheld digital water purity and PPM tester.',
    ),
  ];

  Future<List<ProductEntity>> fetchProducts() async {
    List<ProductEntity> firestoreProducts = [];
    try {
      final snapshot = await FirebaseFirestore.instance.collection('products').get();
      if (snapshot.docs.isNotEmpty) {
        firestoreProducts = snapshot.docs.map((docSnap) => ProductModel.fromFirestore(docSnap)).toList();
      }
    } catch (e) {
      // Fallback if offline or Firestore error
    }

    final combined = <ProductEntity>[];
    combined.addAll(_customProducts);
    if (firestoreProducts.isNotEmpty) {
      combined.addAll(firestoreProducts);
    } else {
      combined.addAll(defaultProducts);
    }
    return combined;
  }

  Future<List<CategoryEntity>> fetchCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('categories').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((docSnap) {
          final data = docSnap.data();
          return CategoryEntity(
            id: docSnap.id,
            name: data['name'] ?? data['title'] ?? 'Category',
            icon: data['icon'],
            imageUrl: data['imageUrl'],
            productCount: (data['productCount'] as num?)?.toInt() ?? 0,
          );
        }).toList();
      }
    } catch (e) {
      // Fallback
    }

    return defaultCategories;
  }

  Future<void> addProduct(ProductEntity product) async {
    try {
      await FirebaseFirestore.instance.collection('products').add({
        'name': product.name,
        'imageUrl': product.photoUrl,
        'warranty': product.warrantyDetails,
        'createdAt': FieldValue.serverTimestamp(),
        'price': product.price,
        'category': product.category,
        'description': product.description,
      });
    } catch (e) {
      // Fallback
    }
    _customProducts.insert(0, product);
  }
}
