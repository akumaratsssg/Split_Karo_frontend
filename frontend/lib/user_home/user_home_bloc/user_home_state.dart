import 'package:equatable/equatable.dart';
import 'package:frontend/models/group.dart';

// Define the base state class for UserHome
abstract class UserHomeState extends Equatable {
  @override
  List<Object> get props => [];
}

// State when the UserHome is in its initial state
class UserHomeInitial extends UserHomeState {}

// State while loading the user groups
class UserHomeLoading extends UserHomeState {}

// State when user groups are successfully loaded
class UserHomeLoaded extends UserHomeState {
  final List<Group> groups;

  UserHomeLoaded({required this.groups});

  @override
  List<Object> get props => [groups];
}

// State when there is an error loading user groups
class UserHomeError extends UserHomeState {
  final String message;

  UserHomeError({required this.message});

  @override
  List<Object> get props => [message];
}


