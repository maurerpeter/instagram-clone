import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/chat/domain/entities/chat_message.dart';
import 'package:instagram_clone/features/chat/domain/entities/message.dart';
import 'package:instagram_clone/features/chat/domain/entities/send_message.dart';
import 'package:instagram_clone/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:instagram_clone/features/chat/presentation/widgets/left_bubble.dart';
import 'package:instagram_clone/features/chat/presentation/widgets/right_bubble.dart';
import 'package:instagram_clone/features/users/domain/entities/partial_user.dart';
import 'package:instagram_clone/features/users/domain/entities/user.dart';
import 'package:meta/meta.dart';

class ChatPage extends StatefulWidget {
  final ChatBloc chatBloc;
  final User user;
  const ChatPage({
    Key key,
    @required this.chatBloc,
    @required this.user,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _chatTextController = TextEditingController();
  List<ChatMessage> chatMessages;
  ScrollController scrollController = ScrollController();

  ChatBloc get _chatBloc => widget.chatBloc;
  User get _user => widget.user;

  int limit = 10;
  int offset = 0;

  @override
  void initState() {
    chatMessages = [];
    _chatBloc.add(
      LoadChat(
        limit: limit,
        offset: offset,
        user: PartialUser(
          id: _user.id,
          username: _user.username,
          profilePictureUrl: _user.profilePictureUrl,
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              CircleAvatar(
                child: _user.profilePictureUrl == null
                    ? const Text('No image')
                    : Image.network(_user.profilePictureUrl),
              ),
              Text(_user.username),
            ],
          ),
        ),
        body: BlocListener<ChatBloc, ChatState>(
          bloc: _chatBloc,
          listener: (context, state) {
            if (state is ChatError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            } else //
            if (state is ChatLoaded) {
              setState(() {
                chatMessages = state.messages;
              });
            }
            if (state is ChatMessageReceived) {
              setState(() {
                chatMessages.insert(0, state.message);
              });
            }
          },
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
                        reverse: true,
                        itemCount: chatMessages.length,
                        itemBuilder: (context, index) {
                          final chatMessage = chatMessages[index];
                          if (chatMessage is SendMessage) {
                            return RightBubble(content: chatMessage.content);
                          } else //
                          if (chatMessage is Message) {
                            if (chatMessage.from.username == _user.username) {
                              return LeftBubble(content: chatMessage.content);
                            }
                            return RightBubble(content: chatMessage.content);
                          }
                          return Container();
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _chatTextController,
                          onSubmitted: (String message) {
                            final sendMessage = SendMessage(
                              to: _user.username,
                              content: message,
                            );
                            _chatBloc.add(
                              SendChatMessage(
                                message: sendMessage,
                              ),
                            );
                            _chatTextController.clear();
                            setState(() {
                              chatMessages.insert(0, sendMessage);
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Write a message to ${_user.username}...',
                          ),
                        ),
                      ),
                      Container(
                        width: 50.0,
                        child: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            final sendMessage = SendMessage(
                              to: _user.username,
                              content: _chatTextController.text,
                            );
                            _chatBloc.add(
                              SendChatMessage(
                                message: sendMessage,
                              ),
                            );
                            setState(() {
                              chatMessages.insert(0, sendMessage);
                            });
                            _chatTextController.clear();
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
