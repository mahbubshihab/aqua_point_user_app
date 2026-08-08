import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/core/services/firebase_service.dart';
import '../../../products/domain/entities/category_entity.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/entities/blog_entity.dart';
import '../../domain/entities/hydration_entity.dart';
import '../../domain/entities/water_quality_entity.dart';
import '../models/banner_model.dart';
import '../models/company_info_model.dart';

class HomeRemoteDatasource {
  final FirebaseFirestore _firestore;

  HomeRemoteDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseService.firestore;

  Future<List<ProductEntity>> fetchProductsByType(String type, {int limit = 10}) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('type', isEqualTo: type)
          .limit(limit)
          .get();

      return snapshot.docs.map((docSnap) {
        final data = docSnap.data();
        final rawPrice = data['price'];
        final rawOrigPrice = data['originalPrice'] ?? data['oldPrice'];
        final rawRating = data['rating'];
        final rawReviews = data['reviewsCount'];

        return ProductEntity(
          id: docSnap.id,
          name: data['name'] ?? data['title'] ?? 'Water Purifier',
          photoUrl: data['imageUrl'] ?? data['cloudinary_url'] ?? data['photoUrl'],
          warrantyDetails: data['warranty'] ?? data['warrantyDetails'] ?? '1 Year Warranty',
          purchaseDate: data['createdAt'] != null ? data['createdAt'].toString() : 'Available',
          isCustom: data['isCustom'] ?? false,
          price: rawPrice != null ? (rawPrice as num).toDouble() : 0.0,
          originalPrice: rawOrigPrice != null ? (rawOrigPrice as num).toDouble() : null,
          category: data['category'] ?? data['categoryId'] ?? 'RO Water Purifiers',
          type: data['type'],
          rating: rawRating != null ? (rawRating as num).toDouble() : 4.8,
          reviewsCount: rawReviews != null ? (rawReviews as num).toInt() : 0,
          description: data['description'] ?? 'High quality water purification system.',
          inStock: data['inStock'] ?? true,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<BannerModel>> fetchBanners() async {
    try {
      QuerySnapshot snapshot;
      try {
        snapshot = await _firestore
            .collection('banners')
            .where('isActive', isEqualTo: true)
            .orderBy('createdAt', descending: true)
            .limit(15)
            .get();
      } catch (_) {
        snapshot = await _firestore
            .collection('banners')
            .where('isActive', isEqualTo: true)
            .limit(15)
            .get();
      }

      final List<BannerModel> banners = [];
      for (final doc in snapshot.docs) {
        final model = BannerModel.fromFirestore(doc);
        if (model.imageUrl.isNotEmpty) {
          banners.add(model);
        }
      }
      return banners;
    } catch (e) {
      rethrow;
    }
  }

  Future<CompanyInfoModel> fetchCompanyInfo() async {
    try {
      final doc = await _firestore.collection('company_info').doc('main').get();
      if (doc.exists) {
        return CompanyInfoModel.fromFirestore(doc);
      }
      return const CompanyInfoModel();
    } catch (_) {
      return const CompanyInfoModel();
    }
  }

  Future<HydrationEntity> fetchHydrationData() async {
    return const HydrationEntity(
      currentGlasses: 0,
      targetGlasses: 8,
    );
  }

  Future<WaterQualityEntity> fetchWaterQualityData() async {
    return const WaterQualityEntity(
      tds: 18,
      status: 'Excellent',
      iron: 0.01,
      ph: 7.2,
      hardness: 'Soft',
    );
  }

  Future<List<BlogEntity>> fetchBlogs() async {
    return const [];
  }

  Future<List<CategoryEntity>> fetchCategories() async {
    try {
      QuerySnapshot snapshot;
      try {
        snapshot = await _firestore
            .collection('categories')
            .where('isActive', isEqualTo: true)
            .get();
      } catch (_) {
        snapshot = await _firestore.collection('categories').get();
      }

      if (snapshot.docs.isNotEmpty) {
        final List<CategoryEntity> categories = [];
        for (final doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final name = data['name'] ?? data['title'] ?? 'Category';
          final icon = data['icon'];
          final imageUrl = data['imageUrl'] ?? data['image'] ?? data['photoUrl'];
          final count = (data['productCount'] as num?)?.toInt() ?? 0;
          categories.add(CategoryEntity(
            id: doc.id,
            name: name,
            icon: icon,
            imageUrl: imageUrl,
            productCount: count,
          ));
        }
        return categories;
      }
      return _fallbackCategories;
    } catch (_) {
      return _fallbackCategories;
    }
  }

  static const List<CategoryEntity> _fallbackCategories = [
    CategoryEntity(
      id: 'cat_1',
      name: 'RO Purifiers',
      imageUrl: 'https://images.unsplash.com/photo-1548839140-29a749e1bc4e?w=500&auto=format&fit=crop&q=60',
      productCount: 12,
    ),
    CategoryEntity(
      id: 'cat_2',
      name: 'Filter Cartridges',
      imageUrl: 'https://images.unsplash.com/photo-1628102491629-778571d893a3?w=500&auto=format&fit=crop&q=60',
      productCount: 8,
    ),
    CategoryEntity(
      id: 'cat_3',
      name: 'Spare Parts',
      imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=500&auto=format&fit=crop&q=60',
      productCount: 15,
    ),
    CategoryEntity(
      id: 'cat_4',
      name: 'Water Softeners',
      imageUrl: 'https://images.unsplash.com/photo-1527613426441-4da17471b66d?w=500&auto=format&fit=crop&q=60',
      productCount: 6,
    ),
  ];
}

