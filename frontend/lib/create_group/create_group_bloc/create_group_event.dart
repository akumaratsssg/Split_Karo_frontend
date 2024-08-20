import 'package:equatable/equatable.dart';

abstract class CreateGroupEvent extends Equatable {
  const CreateGroupEvent();

  @override
  List<Object> get props => [];
}

class CreateGroupSubmitted extends CreateGroupEvent {
  final String groupName;
  final String groupDescription;

  const CreateGroupSubmitted(this.groupName, this.groupDescription);

  @override
  List<Object> get props => [groupName, groupDescription];
}
