import 'package:bloc/bloc.dart';
import 'register_repository.dart';
import 'register_event.dart';
import 'register_state.dart';


class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository repository;

  RegisterBloc({required this.repository}) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<dynamic> _onRegisterSubmitted(
      RegisterSubmitted event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      await repository.register(event.fullName, event.email, event.password);
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(error: e.toString()));
    }
  }
}



