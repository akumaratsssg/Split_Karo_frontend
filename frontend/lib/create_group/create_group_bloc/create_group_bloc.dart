import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_group_event.dart';
import 'create_group_state.dart';
import '../create_group_repo.dart';

class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupState> {
  final CreateGroupRepository createGroupRepository;

  CreateGroupBloc({required this.createGroupRepository}) : super(CreateGroupInitial()){
    on<CreateGroupSubmitted>(_onCreateGroupSubmitted);
  }

  Future<void> _onCreateGroupSubmitted(
      CreateGroupSubmitted event, Emitter<CreateGroupState> emit) async {
    emit(CreateGroupLoading());

    try {
      await createGroupRepository.createGroup(
          event.groupName, event.groupDescription);
      emit(CreateGroupSuccess());
    } catch (e) {
      emit(CreateGroupFailure(error: e.toString()));
    }
  }

}
