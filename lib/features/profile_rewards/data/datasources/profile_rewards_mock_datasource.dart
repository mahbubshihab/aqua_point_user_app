import '../models/user_profile_model.dart';
import '../models/reward_rule_model.dart';
import '../models/faq_model.dart';

class ProfileRewardsMockDatasource {
  UserProfileModel _userProfile = const UserProfileModel(
    id: '1',
    name: 'Customer',
    phone: '+880 1712-345678',
    email: 'customer@aquapoint.com',
    address: 'Dhaka, Bangladesh',
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
    return const [
      RewardRuleModel(
        title: 'App Usage',
        description: 'Earn 1 reward point for every 10 minutes you spend using the app.',
        points: 1,
        iconName: 'timer_outlined',
      ),
      RewardRuleModel(
        title: 'Purchase & Invoices',
        description: 'Earn 5 reward points for every 100 Taka spent on products or services.',
        points: 5,
        iconName: 'shopping_bag_outlined',
      ),
      RewardRuleModel(
        title: 'Service Completion',
        description: 'Get 10 reward points for every service successfully completed.',
        points: 10,
        iconName: 'build_circle_outlined',
      ),
      RewardRuleModel(
        title: 'Refer a Friend',
        description: 'Get 50 points when a friend joins using your referral link.',
        points: 50,
        iconName: 'card_giftcard_outlined',
      ),
    ];
  }

  Future<List<FaqModel>> getFaqs() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      FaqModel(
        question: 'What are Aqua Point Points?',
        answer: 'Aqua Point Points is a reward program in the AQUA POINT app where you can earn points through app usage, receiving services, and referring friends.',
      ),
      FaqModel(
        question: 'How do I qualify for Aqua Point Points?',
        answer: 'After creating an account on the AQUA POINT app, you qualify to earn reward points with every service request and purchase.',
      ),
      FaqModel(
        question: 'How can I earn points?',
        answer: 'You can earn points by using the app, purchasing products & services, completing service requests, and referring friends.',
      ),
      FaqModel(
        question: 'Terms & Conditions',
        answer: 'Reward points cannot be transferred to another account and must be redeemed within the valid period.',
      ),
    ];
  }
}
