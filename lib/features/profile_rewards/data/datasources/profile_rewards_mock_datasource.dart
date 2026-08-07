import '../models/user_profile_model.dart';
import '../models/reward_rule_model.dart';
import '../models/faq_model.dart';

class ProfileRewardsMockDatasource {
  UserProfileModel _userProfile = const UserProfileModel(
    id: '1',
    name: 'Customer',
    phone: '',
    email: '',
    address: '',
    avatarUrl: '',
    totalPoints: 0,
  );

  Future<UserProfileModel> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _userProfile;
  }

  Future<UserProfileModel> updateProfile(UserProfileModel profile) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _userProfile = profile;
    return _userProfile;
  }

  Future<List<RewardRuleModel>> getRewardRules() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [];
  }

  Future<List<FaqModel>> getFaqs() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [];
  }
}
