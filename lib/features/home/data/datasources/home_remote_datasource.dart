import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/core/services/firebase_service.dart';
import '../../../products/data/models/product_model.dart';
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

      return snapshot.docs.map((docSnap) => ProductModel.fromFirestore(docSnap)).toList();
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
      return [];
    } catch (_) {
      return [];
    }
  }

}

