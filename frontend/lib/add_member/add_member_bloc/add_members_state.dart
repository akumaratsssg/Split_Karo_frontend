import 'package:equatable/equatable.dart';
import 'package:frontend/models/user.dart';

abstract class AddMembersState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Initial state when no action is taken
class AddMembersInitial extends AddMembersState {}

// State while searching for users
class UserSearchLoading extends AddMembersState {}

// State when users have been loaded after search
class UserSearchLoaded extends AddMembersState {
  final List<User> users; // A list of user suggestions
  final User? selectedUser; // Track the selected user

  UserSearchLoaded(this.users, {this.selectedUser});

  @override
  List<Object?> get props => [users, selectedUser ?? ''];
}

// State when there's an error
class AddMembersError extends AddMembersState {
  final String message;

  AddMembersError(this.message);

  @override
  List<Object?> get props => [message];
}

// State when a user has been successfully added
class AddUserSuccess extends AddMembersState {
  final String userEmail;
  final String groupName;

  AddUserSuccess(this.userEmail, this.groupName);

  @override
  List<Object?> get props => [userEmail, groupName];
}
