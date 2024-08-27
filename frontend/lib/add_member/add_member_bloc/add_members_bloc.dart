import 'package:bloc/bloc.dart';
import 'add_members_event.dart';
import 'add_members_state.dart';
import 'package:frontend/add_member/add_member_repo.dart';
import 'package:frontend/models/user.dart';

class AddMembersBloc extends Bloc<AddMembersEvent, AddMembersState> {
  final AddMembersRepo repo;

  AddMembersBloc(this.repo) : super(AddMembersInitial()) {
    on<SearchUserEvent>(_onSearchUserEvent);
    on<AddUserToGroupEvent>(_onAddUserToGroupEvent);
    on<SelectUserEvent>(_onSelectUserEvent);
  }

  Future<void> _onSearchUserEvent(
      SearchUserEvent event, Emitter<AddMembersState> emit) async {
    emit(UserSearchLoading());
    try {
      final userMap = await repo.searchUsers(event.userName);
      // Convert the single Map<String, dynamic> to User
      final user = User.fromJson(userMap);
      emit(UserSearchLoaded([user])); // Wrap user in a list if needed for consistency
    } catch (e) {
      print('Error searching users: $e');
      emit(AddMembersError('Failed to load users'));
    }
  }


  Future<void> _onAddUserToGroupEvent(
      AddUserToGroupEvent event, Emitter<AddMembersState> emit) async {
    try {
      await repo.addUserToGroup(event.userEmail, event.groupName);
      emit(AddUserSuccess(event.userEmail, event.groupName));
    } catch (e) {
      print('Error adding user to group: $e');
      emit(AddMembersError('Failed to add user to group'));
    }
  }

  void _onSelectUserEvent(
      SelectUserEvent event, Emitter<AddMembersState> emit) {
    if (state is UserSearchLoaded) {
      final currentState = state as UserSearchLoaded;
      emit(UserSearchLoaded(currentState.users, selectedUser: event.user));
    }
  }
}
