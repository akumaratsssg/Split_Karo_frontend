import 'package:flutter_bloc/flutter_bloc.dart';
import 'view_group_mem_event.dart';
import 'view_group_mem_state.dart';
import 'package:frontend/viewGroupMember/viewGroupMemRepo.dart';

class ViewGroupMembersBloc extends Bloc<ViewGroupMembersEvent, ViewGroupMembersState> {
  final ViewGroupMembersRepo viewGroupMembersRepo;

  ViewGroupMembersBloc(this.viewGroupMembersRepo) : super(ViewGroupMembersInitial()) {
    on<FetchGroupMembers>(_onFetchGroupMembers);
  }

  void _onFetchGroupMembers(
      FetchGroupMembers event, Emitter<ViewGroupMembersState> emit) async {
    emit(ViewGroupMembersLoading());

    try {
      final groupMembers = await viewGroupMembersRepo.getGroupMembers(event.groupName);
      emit(ViewGroupMembersLoaded(groupMembers));
    } catch (e) {
      emit(ViewGroupMembersError(e.toString()));
    }
  }
}

