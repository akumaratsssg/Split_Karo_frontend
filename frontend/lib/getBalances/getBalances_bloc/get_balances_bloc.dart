import 'package:flutter_bloc/flutter_bloc.dart';
import 'get_balances_event.dart';
import 'get_balances_state.dart';
import 'package:frontend/getBalances/getBalance_repo.dart';

class BalancesBloc extends Bloc<BalancesEvent, BalancesState> {
  final BalancesRepository balancesRepository;

  BalancesBloc(this.balancesRepository) : super(BalancesInitial()) {
    on<LoadBalances>(_onLoadBalances);
  }

  void _onLoadBalances(LoadBalances event, Emitter<BalancesState> emit) async {
    try {
      emit(BalancesLoading());
      final balances = await balancesRepository.fetchBalances(event.groupName);
      emit(BalancesLoaded(balances: balances));
    } catch (e) {
      emit(BalancesError(message: e.toString()));
    }
  }
}
