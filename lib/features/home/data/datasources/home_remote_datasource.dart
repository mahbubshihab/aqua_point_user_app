import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/core/services/firebase_service.dart';
import '../../domain/entities/blog_entity.dart';
import '../../domain/entities/hydration_entity.dart';
import '../../domain/entities/water_quality_entity.dart';
import '../models/banner_model.dart';
import '../models/company_info_model.dart';

class HomeRemoteDatasource {
  final FirebaseFirestore _firestore;

  HomeRemoteDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseService.firestore;

  Future<List<BannerModel>> fetchBanners() async {
    try {
      QuerySnapshot snapshot;
      try {
        snapshot = await _firestore
            .collection('banners')
            .where('isActive', isEqualTo: true)
            .orderBy('createdAt', descending: true)
            .get();
      } catch (_) {
        snapshot = await _firestore
            .collection('banners')
            .where('isActive', isEqualTo: true)
            .get();
      }

      return snapshot.docs
          .map((doc) => BannerModel.fromFirestore(doc))
          .where((banner) => banner.imageUrl.isNotEmpty)
          .toList();
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
}
