import 'package:equatable/equatable.dart';

abstract class BalancesEvent extends Equatable {
  const BalancesEvent();

  @override
  List<Object> get props => [];
}

class LoadBalances extends BalancesEvent {
  final String groupName;

  LoadBalances({required this.groupName});

  @override
  List<Object> get props => [groupName];
}

