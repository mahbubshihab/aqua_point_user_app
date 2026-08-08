import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile_model.dart';
import '../models/reward_rule_model.dart';
import '../models/faq_model.dart';

class ProfileRewardsRemoteDatasource {
  UserProfileModel _userProfile = const UserProfileModel(
    id: '',
    name: '',
    phone: '',
    email: '',
    address: '',
    avatarUrl: '',
    totalPoints: 0,
  );

  Future<UserProfileModel> getUserProfile() async {
    return _userProfile;
  }

  Future<UserProfileModel> updateProfile(UserProfileModel profile) async {
    _userProfile = profile;
    return _userProfile;
  }

  Future<List<RewardRuleModel>> getRewardRules() async {
    return const [];
  }

  Future<List<FaqModel>> getFaqs() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('faqs').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((docSnap) {
          final data = docSnap.data();
          return FaqModel(
            question: data['question'] ?? '',
            answer: data['answer'] ?? '',
          );
        }).toList();
      }
    } catch (e) {
      // Ignored
    }
    return const [];
  }
}


