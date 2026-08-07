import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_rewards_repository.dart';
import 'profile_rewards_event.dart';
import 'profile_rewards_state.dart';

class ProfileRewardsBloc extends Bloc<ProfileRewardsEvent, ProfileRewardsState> {
  final ProfileRewardsRepository repository;

  ProfileRewardsBloc({required this.repository})
      : super(const ProfileRewardsInitial()) {
    on<LoadProfileData>(_onLoadProfileData);
    on<UpdateProfile>(_onUpdateProfile);
    on<LogoutUser>(_onLogoutUser);
  }

  Future<void> _onLoadProfileData(
    LoadProfileData event,
    Emitter<ProfileRewardsState> emit,
  ) async {
    emit(const ProfileRewardsLoading());
    try {
      final userProfile = await repository.getUserProfile();
      final rewardRules = await repository.getRewardRules();
      final faqs = await repository.getFaqs();

      emit(ProfileRewardsLoaded(
        userProfile: userProfile,
        rewardRules: rewardRules,
        faqs: faqs,
      ));
    } catch (e) {
      emit(ProfileRewardsError(message: e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileRewardsState> emit,
  ) async {
    final currentState = state;
    emit(const ProfileUpdating());
    try {
      final updatedProfile = await repository.updateProfile(event.profile);
      emit(ProfileUpdateSuccess(updatedProfile: updatedProfile));

      if (currentState is ProfileRewardsLoaded) {
        emit(currentState.copyWith(userProfile: updatedProfile));
      } else {
        final rewardRules = await repository.getRewardRules();
        final faqs = await repository.getFaqs();
        emit(ProfileRewardsLoaded(
          userProfile: updatedProfile,
          rewardRules: rewardRules,
          faqs: faqs,
        ));
      }
    } catch (e) {
      emit(ProfileRewardsError(message: e.toString()));
    }
  }

  Future<void> _onLogoutUser(
    LogoutUser event,
    Emitter<ProfileRewardsState> emit,
  ) async {
    emit(const UserLoggedOutState());
  }
}
