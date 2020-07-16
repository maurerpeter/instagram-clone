import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/widgets/loading_indicator.dart';
import 'package:instagram_clone/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:instagram_clone/features/chat/presentation/pages/chat_page.dart';
import 'package:instagram_clone/features/users/presentation/bloc/user_bloc.dart';
import 'package:meta/meta.dart';

class MessagesPage extends StatefulWidget {
  final UserBloc userBloc;
  final ChatBloc chatBloc;
  const MessagesPage({
    Key key,
    @required this.userBloc,
    @required this.chatBloc,
  }) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  bool isSearching = false;
  final _searchTextController = TextEditingController();

  UserBloc get _userBloc => widget.userBloc;
  ChatBloc get _chatBloc => widget.chatBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? const Text('Message')
            : TextField(
                onSubmitted: (String text) {
                  _userBloc.add(GetFollowedUsers(text ?? ''));
                  setState(() {
                    isSearching = !isSearching;
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.white),
                  hintText: 'Search People',
                ),
                controller: _searchTextController),
        actions: <Widget>[
          IconButton(
            icon: Icon(!isSearching ? Icons.search : Icons.cancel),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
            },
          ),
        ],
      ),
      body: BlocConsumer<UserBloc, UserState>(
        bloc: _userBloc,
        listener: (context, state) {
          if (state is GetFollowedUsersError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GetFollowedUsersLoading) {
            return LoadingIndicator();
          } else //
          if (state is FollowedUsersLoaded) {
            final users = state.users;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(users[index].username),
                  leading: CircleAvatar(
                    child: users[index].profilePictureUrl == null
                        ? const Text('No image')
                        : Image.network(users[index].profilePictureUrl),
                  ),
                  trailing: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            user: users[index],
                            chatBloc: _chatBloc,
                          ),
                        ),
                      );
                    },
                    child: const Text('Message'),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
