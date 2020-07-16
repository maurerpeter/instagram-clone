part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatError extends ChatState {
  final String message;

  const ChatError({@required this.message});

  @override
  List<Object> get props => [message];
}

class ChatLoaded extends ChatState {
  final List<Message> messages;

  const ChatLoaded({@required this.messages});

  @override
  List<Object> get props => [messages];
}

class ChatMessageReceived extends ChatState {
  final Message message;

  const ChatMessageReceived({@required this.message});

  @override
  List<Object> get props => [message];
}
