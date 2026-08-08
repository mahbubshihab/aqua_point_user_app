import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/category_entity.dart';
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

  const HomeLoaded({
    this.tabIndex = 0,
    this.banners = const [],
    this.companyInfo = const CompanyInfoEntity(),
    required this.hydration,
    required this.waterQuality,
    required this.blogs,
    this.categories = const [],
  });

  HomeLoaded copyWith({
    int? tabIndex,
    List<BannerEntity>? banners,
    CompanyInfoEntity? companyInfo,
    HydrationEntity? hydration,
    WaterQualityEntity? waterQuality,
    List<BlogEntity>? blogs,
    List<CategoryEntity>? categories,
  }) {
    return HomeLoaded(
      tabIndex: tabIndex ?? this.tabIndex,
      banners: banners ?? this.banners,
      companyInfo: companyInfo ?? this.companyInfo,
      hydration: hydration ?? this.hydration,
      waterQuality: waterQuality ?? this.waterQuality,
      blogs: blogs ?? this.blogs,
      categories: categories ?? this.categories,
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
      ];
}


class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
