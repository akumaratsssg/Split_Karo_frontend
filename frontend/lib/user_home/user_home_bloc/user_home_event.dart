import 'package:equatable/equatable.dart';

// Define the base event class for UserHome
abstract class UserHomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Event to fetch the list of user groups
class FetchUserGroups extends UserHomeEvent {}


