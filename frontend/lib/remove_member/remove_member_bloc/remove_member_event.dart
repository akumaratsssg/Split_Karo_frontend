import 'package:equatable/equatable.dart';

abstract class RemoveMemberEvent extends Equatable {
  const RemoveMemberEvent();

  @override
  List<Object> get props => [];
}

class RemoveMemberRequested extends RemoveMemberEvent {
  final String userEmail;
  final String groupName;

  const RemoveMemberRequested({
    required this.userEmail,
    required this.groupName,
  });

  @override
  List<Object> get props => [userEmail, groupName];
}

