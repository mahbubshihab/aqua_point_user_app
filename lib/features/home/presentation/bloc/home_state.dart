import 'package:equatable/equatable.dart';
import '../../domain/entities/blog_entity.dart';
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
  final HydrationEntity hydration;
  final WaterQualityEntity waterQuality;
  final List<BlogEntity> blogs;

  const HomeLoaded({
    this.tabIndex = 0,
    required this.hydration,
    required this.waterQuality,
    required this.blogs,
  });

  HomeLoaded copyWith({
    int? tabIndex,
    HydrationEntity? hydration,
    WaterQualityEntity? waterQuality,
    List<BlogEntity>? blogs,
  }) {
    return HomeLoaded(
      tabIndex: tabIndex ?? this.tabIndex,
      hydration: hydration ?? this.hydration,
      waterQuality: waterQuality ?? this.waterQuality,
      blogs: blogs ?? this.blogs,
    );
  }

  @override
  List<Object?> get props => [tabIndex, hydration, waterQuality, blogs];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
