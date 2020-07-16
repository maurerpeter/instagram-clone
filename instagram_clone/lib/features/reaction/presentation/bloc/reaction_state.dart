part of 'reaction_bloc.dart';

abstract class ReactionState extends Equatable {
  const ReactionState();

  @override
  List<Object> get props => [];
}

class ReactionInitial extends ReactionState {}

class CreateReactionLoading extends ReactionState {}

class CreateReactionError extends ReactionState {
  final String message;

  const CreateReactionError({@required this.message});

  @override
  List<Object> get props => [message];
}

class ReactionCreated extends ReactionState {}

class GetReactionsLoading extends ReactionState {}

class GetReactionsError extends ReactionState {
  final String message;

  const GetReactionsError({@required this.message});

  @override
  List<Object> get props => [message];
}

class ReactionsLoaded extends ReactionState {
  final List<Reaction> reactions;

  const ReactionsLoaded({@required this.reactions});

  @override
  List<Object> get props => [reactions];
}
