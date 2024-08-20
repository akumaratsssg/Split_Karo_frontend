import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/user_home/user_home_repository.dart';
import 'package:frontend/models/group.dart';
import 'user_home_event.dart';
import 'user_home_state.dart';

class UserHomeBloc extends Bloc<UserHomeEvent, UserHomeState> {
  final UserHomeRepository userHomeRepository;

  UserHomeBloc({required this.userHomeRepository}) : super(UserHomeInitial()) {
    on<FetchUserGroups>(_onFetchUserGroups);
  }

  // Method to handle the FetchUserGroups event
  Future<void> _onFetchUserGroups(FetchUserGroups event, Emitter<UserHomeState> emit) async {
    emit(UserHomeLoading());
    try {
      // Fetch the user groups from the repository
      final List<Group> groups = await userHomeRepository.fetchUserGroups();
      // Emit the loaded state with the fetched groups
      emit(UserHomeLoaded(groups: groups));
    } catch (e) {
      // Emit an error state if something goes wrong
      emit(UserHomeError(message: e.toString()));
    }
  }
}



