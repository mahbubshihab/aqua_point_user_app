import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeData extends HomeEvent {
  const LoadHomeData();
}

class IncrementHydration extends HomeEvent {
  const IncrementHydration();
}

class DecrementHydration extends HomeEvent {
  const DecrementHydration();
}

class SelectTab extends HomeEvent {
  final int tabIndex;

  const SelectTab(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}
