import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/entities/reward_rule_entity.dart';
import '../../domain/entities/faq_entity.dart';

abstract class ProfileRewardsState extends Equatable {
  const ProfileRewardsState();

  @override
  List<Object?> get props => [];
}

class ProfileRewardsInitial extends ProfileRewardsState {
  const ProfileRewardsInitial();
}

class ProfileRewardsLoading extends ProfileRewardsState {
  const ProfileRewardsLoading();
}

class ProfileRewardsLoaded extends ProfileRewardsState {
  final UserProfileEntity userProfile;
  final List<RewardRuleEntity> rewardRules;
  final List<FaqEntity> faqs;

  const ProfileRewardsLoaded({
    required this.userProfile,
    required this.rewardRules,
    required this.faqs,
  });

  ProfileRewardsLoaded copyWith({
    UserProfileEntity? userProfile,
    List<RewardRuleEntity>? rewardRules,
    List<FaqEntity>? faqs,
  }) {
    return ProfileRewardsLoaded(
      userProfile: userProfile ?? this.userProfile,
      rewardRules: rewardRules ?? this.rewardRules,
      faqs: faqs ?? this.faqs,
    );
  }

  @override
  List<Object?> get props => [userProfile, rewardRules, faqs];
}

class ProfileUpdating extends ProfileRewardsState {
  const ProfileUpdating();
}

class ProfileUpdateSuccess extends ProfileRewardsState {
  final UserProfileEntity updatedProfile;

  const ProfileUpdateSuccess({required this.updatedProfile});

  @override
  List<Object?> get props => [updatedProfile];
}

class ProfileRewardsError extends ProfileRewardsState {
  final String message;

  const ProfileRewardsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class UserLoggedOutState extends ProfileRewardsState {
  const UserLoggedOutState();
}
