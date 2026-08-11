import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/inbox_support_repository.dart';
import 'inbox_support_event.dart';
import 'inbox_support_state.dart';

class InboxSupportBloc extends Bloc<InboxSupportEvent, InboxSupportState> {
  final InboxSupportRepository repository;

  InboxSupportBloc({required this.repository}) : super(const InboxSupportInitial()) {
    on<LoadInboxData>(_onLoadInboxData);
    on<SelectInboxTab>(_onSelectInboxTab);
    on<SubmitSupportInquiry>(_onSubmitSupportInquiry);
  }

  Future<void> _onLoadInboxData(
    LoadInboxData event,
    Emitter<InboxSupportState> emit,
  ) async {
    emit(const InboxSupportLoading());
    try {
      final notifications = await repository.getNotifications();
      final chatMessages = await repository.getChatMessages();
      emit(InboxSupportLoaded(
        selectedTabIndex: 0,
        notifications: notifications,
        chatMessages: chatMessages,
      ));
    } catch (e) {
      emit(InboxSupportError(e.toString()));
    }
  }

  void _onSelectInboxTab(
    SelectInboxTab event,
    Emitter<InboxSupportState> emit,
  ) {
    if (state is InboxSupportLoaded) {
      final currentState = state as InboxSupportLoaded;
      emit(currentState.copyWith(selectedTabIndex: event.index));
    }
  }

  Future<void> _onSubmitSupportInquiry(
    SubmitSupportInquiry event,
    Emitter<InboxSupportState> emit,
  ) async {
    final previousState = state;
    emit(const InquirySubmitting());
    try {
      await repository.submitSupportInquiry(
        fullName: event.fullName,
        phoneNumber: event.phoneNumber,
        subject: event.subject,
        message: event.message,
      );
      emit(const InquirySubmittedSuccess(message: 'Inquiry sent successfully!'));
      if (previousState is InboxSupportLoaded) {
        emit(previousState);
      } else {
        add(const LoadInboxData());
      }
    } catch (e) {
      emit(InboxSupportError(e.toString()));
    }
  }
}
