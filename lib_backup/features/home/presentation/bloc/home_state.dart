import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/category_entity.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/entities/blog_entity.dart';
import '../../domain/entities/company_info_entity.dart';
import '../../domain/entities/hydration_entity.dart';
import '../../domain/entities/water_quality_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final int tabIndex;
  final List<BannerEntity> banners;
  final CompanyInfoEntity companyInfo;
  final HydrationEntity hydration;
  final WaterQualityEntity waterQuality;
  final List<BlogEntity> blogs;
  final List<CategoryEntity> categories;
  final List<ProductEntity> openTypeProducts;
  final List<ProductEntity> boxTypeProducts;
  final List<ProductEntity> hotColdNormalProducts;
  final List<ProductEntity> cabinetTypeProducts;

  const HomeLoaded({
    this.tabIndex = 0,
    this.banners = const [],
    this.companyInfo = const CompanyInfoEntity(),
    required this.hydration,
    required this.waterQuality,
    required this.blogs,
    this.categories = const [],
    this.openTypeProducts = const [],
    this.boxTypeProducts = const [],
    this.hotColdNormalProducts = const [],
    this.cabinetTypeProducts = const [],
  });

  HomeLoaded copyWith({
    int? tabIndex,
    List<BannerEntity>? banners,
    CompanyInfoEntity? companyInfo,
    HydrationEntity? hydration,
    WaterQualityEntity? waterQuality,
    List<BlogEntity>? blogs,
    List<CategoryEntity>? categories,
    List<ProductEntity>? openTypeProducts,
    List<ProductEntity>? boxTypeProducts,
    List<ProductEntity>? hotColdNormalProducts,
    List<ProductEntity>? cabinetTypeProducts,
  }) {
    return HomeLoaded(
      tabIndex: tabIndex ?? this.tabIndex,
      banners: banners ?? this.banners,
      companyInfo: companyInfo ?? this.companyInfo,
      hydration: hydration ?? this.hydration,
      waterQuality: waterQuality ?? this.waterQuality,
      blogs: blogs ?? this.blogs,
      categories: categories ?? this.categories,
      openTypeProducts: openTypeProducts ?? this.openTypeProducts,
      boxTypeProducts: boxTypeProducts ?? this.boxTypeProducts,
      hotColdNormalProducts: hotColdNormalProducts ?? this.hotColdNormalProducts,
      cabinetTypeProducts: cabinetTypeProducts ?? this.cabinetTypeProducts,
    );
  }

  @override
  List<Object?> get props => [
        tabIndex,
        banners,
        companyInfo,
        hydration,
        waterQuality,
        blogs,
        categories,
        openTypeProducts,
        boxTypeProducts,
        hotColdNormalProducts,
        cabinetTypeProducts,
      ];
}


class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
