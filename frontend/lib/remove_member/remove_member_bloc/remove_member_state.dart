import 'package:equatable/equatable.dart';

abstract class RemoveMemberState extends Equatable {
  const RemoveMemberState();

  @override
  List<Object> get props => [];
}

class RemoveMemberInitial extends RemoveMemberState {}

class RemoveMemberLoading extends RemoveMemberState {}

class RemoveMemberSuccess extends RemoveMemberState {}

class RemoveMemberFailure extends RemoveMemberState {
  final String error;

  const RemoveMemberFailure(this.error);

  @override
  List<Object> get props => [error];
}
