import 'package:equatable/equatable.dart';
import '../../domain/entities/service_request_entity.dart';

abstract class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object?> get props => [];
}

class LoadServicesHistory extends ServicesEvent {
  const LoadServicesHistory();
}

class SelectHistoryTab extends ServicesEvent {
  final int tabIndex;

  const SelectHistoryTab(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class SubmitServiceRequest extends ServicesEvent {
  final ServiceRequestEntity request;

  const SubmitServiceRequest(this.request);

  @override
  List<Object?> get props => [request];
}
