import '../entities/user_profile_entity.dart';
import '../entities/reward_rule_entity.dart';
import '../entities/faq_entity.dart';

abstract class ProfileRewardsRepository {
  Future<UserProfileEntity> getUserProfile();
  Future<UserProfileEntity> updateProfile(UserProfileEntity profile);
  Future<List<RewardRuleEntity>> getRewardRules();
  Future<List<FaqEntity>> getFaqs();
}
