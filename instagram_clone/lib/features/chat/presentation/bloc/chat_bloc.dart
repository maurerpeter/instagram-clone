import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/core/message_broker/message_broker.dart';
import 'package:instagram_clone/features/chat/domain/entities/message.dart';
import 'package:instagram_clone/features/chat/domain/entities/send_message.dart';
import 'package:instagram_clone/features/chat/domain/repositories/chat_repository.dart';
import 'package:instagram_clone/features/users/domain/entities/partial_user.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final MessageBroker messageBroker;

  ChatBloc({
    @required this.chatRepository,
    @required this.messageBroker,
  });

  @override
  ChatState get initialState => ChatInitial();

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is LoadChat) {
      yield ChatLoading();
      final failureOrMessages = await chatRepository.getMessages(
        username: event.user.username,
        limit: event.limit,
        offset: event.offset,
      );
      yield failureOrMessages.fold(
        (failure) => ChatError(message: _mapFailureToMessage(failure)),
        (messages) => ChatLoaded(messages: messages),
      );
    } else //
    if (event is NewChatMessage) {
      yield ChatMessageReceived(message: event.message);
    } else //
    if (event is SendChatMessage) {
      try {
        messageBroker.sendMessage(event.message);
      } catch (error) {
        yield ChatError(message: error.toString());
      }
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
