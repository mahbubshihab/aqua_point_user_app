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
        question: 'মীম ওয়াটার পয়েন্ট কি?',
        answer: 'মীম ওয়াটার পয়েন্ট হলো AQUA POINT অ্যাপের একটি রিওয়ার্ড প্রোগ্রাম, যার মাধ্যমে আপনি অ্যাপ ব্যবহার, সেবা গ্রহণ ও রেফারেলের মাধ্যমে পয়েন্ট অর্জন করতে পারবেন।',
      ),
      FaqModel(
        question: 'কিভাবে মীম ওয়াটার পয়েন্ট পাওয়ার জন্য বিবেচিত হবো?',
        answer: 'AQUA POINT অ্যাপে অ্যাকাউন্ট খোলার পর প্রতিটি সেবা গ্রহণ ও ক্রয়ের সাথে সাথে আপনি পয়েন্ট অর্জনের জন্য বিবেচিত হবেন।',
      ),
      FaqModel(
        question: 'মীম ওয়াটার পয়েন্ট অর্জন করবো কিভাবে?',
        answer: 'অ্যাপ ব্যবহার, পণ্য ও সেবা ক্রয়, সার্ভিস সম্পূর্ণকরণ এবং বন্ধুদের রেফার করার মাধ্যমে পয়েন্ট অর্জন করতে পারবেন।',
      ),
      FaqModel(
        question: 'শর্ত সমুহ',
        answer: 'রিওয়ার্ড পয়েন্টসমূহ অন্য কোন অ্যাকাউন্টে হস্তান্তর করা যাবে না এবং নির্দিষ্ট সময়সীমার মধ্যে ব্যবহার করতে হবে।',
      ),
    ];
  }
}
