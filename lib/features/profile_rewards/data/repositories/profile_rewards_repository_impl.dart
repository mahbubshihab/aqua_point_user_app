import '../../domain/entities/user_profile_entity.dart';
import '../../domain/entities/reward_rule_entity.dart';
import '../../domain/entities/faq_entity.dart';
import '../../domain/repositories/profile_rewards_repository.dart';
import '../datasources/profile_rewards_remote_datasource.dart';
import '../models/user_profile_model.dart';

class ProfileRewardsRepositoryImpl implements ProfileRewardsRepository {
  final ProfileRewardsRemoteDatasource datasource;

  ProfileRewardsRepositoryImpl({required this.datasource});

  @override
  Future<UserProfileEntity> getUserProfile() async {
    return await datasource.getUserProfile();
  }

  @override
  Future<UserProfileEntity> updateProfile(UserProfileEntity profile) async {
    final model = UserProfileModel.fromEntity(profile);
    return await datasource.updateProfile(model);
  }

  @override
  Future<List<RewardRuleEntity>> getRewardRules() async {
    return await datasource.getRewardRules();
  }

  @override
  Future<List<FaqEntity>> getFaqs() async {
    return await datasource.getFaqs();
  }
}

