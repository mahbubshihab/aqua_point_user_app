import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile_entity.dart';

abstract class ProfileRewardsEvent extends Equatable {
  const ProfileRewardsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileData extends ProfileRewardsEvent {
  const LoadProfileData();
}

class UpdateProfile extends ProfileRewardsEvent {
  final UserProfileEntity profile;

  const UpdateProfile({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class LogoutUser extends ProfileRewardsEvent {
  const LogoutUser();
}
