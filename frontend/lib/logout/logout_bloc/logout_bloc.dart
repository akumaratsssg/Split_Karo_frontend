// logout_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'logout_event.dart';
import 'logout_state.dart';
import 'package:frontend/logout/logout_repo.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutRepository logoutRepository;

  LogoutBloc({required this.logoutRepository}) : super(LogoutInitial()) {
    on<PerformLogout>((event, emit) async {
      emit(LogoutLoading());
      try {
        await logoutRepository.logout();
        emit(LogoutSuccess());
      } catch (e) {
        emit(LogoutFailure(e.toString()));
      }
    });
  }
}

