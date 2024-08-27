import 'package:equatable/equatable.dart';

abstract class ViewGroupMembersEvent extends Equatable {
  const ViewGroupMembersEvent();

  @override
  List<Object> get props => [];
}

class FetchGroupMembers extends ViewGroupMembersEvent {
  final String groupName;

  const FetchGroupMembers(this.groupName);

  @override
  List<Object> get props => [groupName];
}

