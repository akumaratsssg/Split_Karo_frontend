import 'package:flutter_bloc/flutter_bloc.dart';
import 'signin_event.dart';
import 'signin_state.dart';
import 'signin_repository.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInRepository repository;

  SignInBloc({required this.repository}) : super(SignInInitial()) {
    on<SignInSubmitted>(_onSignInSubmitted);
  }

  Future<void> _onSignInSubmitted(
      SignInSubmitted event, Emitter<SignInState> emit) async {
    emit(SignInLoading());
    try {
      final response = await repository.signIn(event.email, event.password);
      final userName = response['user_name']; // Ensure this matches your API response key
      emit(SignInSuccess(userName: userName));
    } catch (e) {
      emit(SignInFailure(error: e.toString()));
    }
  }
}



