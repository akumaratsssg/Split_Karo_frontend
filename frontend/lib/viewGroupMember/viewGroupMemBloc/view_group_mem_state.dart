import 'package:equatable/equatable.dart';
import 'package:frontend/models/group_member.dart';

abstract class ViewGroupMembersState extends Equatable {
  const ViewGroupMembersState();

  @override
  List<Object> get props => [];
}

class ViewGroupMembersInitial extends ViewGroupMembersState {}

class ViewGroupMembersLoading extends ViewGroupMembersState {}

class ViewGroupMembersLoaded extends ViewGroupMembersState {
  final List<GroupMember> groupMembers;

  const ViewGroupMembersLoaded(this.groupMembers);

  @override
  List<Object> get props => [groupMembers];
}

class ViewGroupMembersError extends ViewGroupMembersState {
  final String message;

  const ViewGroupMembersError(this.message);

  @override
  List<Object> get props => [message];
}

