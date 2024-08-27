import 'package:equatable/equatable.dart';
import 'package:frontend/models/user.dart';

abstract class AddMembersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchUserEvent extends AddMembersEvent {
  final String userName;

  SearchUserEvent(this.userName);

  @override
  List<Object?> get props => [userName];
}

class AddUserToGroupEvent extends AddMembersEvent {
  final String userEmail;
  final String groupName;

  AddUserToGroupEvent(this.userEmail, this.groupName);

  @override
  List<Object?> get props => [userEmail, groupName];
}

class SelectUserEvent extends AddMembersEvent {
  final User user;

  SelectUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}
