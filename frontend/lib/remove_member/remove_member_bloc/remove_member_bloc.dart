import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'remove_member_event.dart'; // Import events
import 'remove_member_state.dart'; // Import states
import 'package:frontend/remove_member/remove_member_repo.dart'; // Import repository

class RemoveMemberBloc extends Bloc<RemoveMemberEvent, RemoveMemberState> {
  final RemoveMemberRepo removeMemberRepo;

  RemoveMemberBloc(this.removeMemberRepo) : super(RemoveMemberInitial()) {
    on<RemoveMemberRequested>(_onRemoveMemberRequested);
  }

  Future<void> _onRemoveMemberRequested(
      RemoveMemberRequested event, Emitter<RemoveMemberState> emit) async {
    emit(RemoveMemberLoading());
    try {
      await removeMemberRepo.removeMember(event.userEmail, event.groupName);
      emit(RemoveMemberSuccess());
    } catch (e) {
      emit(RemoveMemberFailure(e.toString()));
    }
  }
}

