part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class LoadChat extends ChatEvent {
  final PartialUser user;
  final int limit;
  final int offset;

  const LoadChat({
    @required this.user,
    @required this.limit,
    @required this.offset,
  });

  @override
  List<Object> get props => [user, limit, offset];
}

class SendChatMessage extends ChatEvent {
  final SendMessage message;

  const SendChatMessage({@required this.message});

  @override
  List<Object> get props => [message];
}

class NewChatMessage extends ChatEvent {
  final Message message;

  const NewChatMessage({@required this.message});

  @override
  List<Object> get props => [message];
}
