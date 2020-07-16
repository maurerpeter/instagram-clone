import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/widgets/loading_indicator.dart';
import 'package:instagram_clone/features/follow/presentation/bloc/follow_bloc.dart';
import 'package:instagram_clone/features/users/presentation/bloc/user_bloc.dart';
import 'package:meta/meta.dart';

class FindPeoplePage extends StatefulWidget {
  final UserBloc userBloc;
  final FollowBloc followBloc;

  const FindPeoplePage({
    Key key,
    @required this.userBloc,
    @required this.followBloc,
  }) : super(key: key);

  @override
  _FindPeoplePageState createState() => _FindPeoplePageState();
}

class _FindPeoplePageState extends State<FindPeoplePage> {
  bool isSearching = false;
  final _searchTextController = TextEditingController();

  UserBloc get _userBloc => widget.userBloc;
  FollowBloc get _followBloc => widget.followBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? const Text('Discover People')
            : TextField(
                onSubmitted: (String text) {
                  _userBloc.add(GetUsers(text ?? ''));
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
      body: BlocListener<FollowBloc, FollowState>(
        listener: (context, state) {
          if (state is FollowError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          } else //
          if (state is FollowSuccess) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: const Text('Successfully followed'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: BlocConsumer<UserBloc, UserState>(
          bloc: _userBloc,
          listener: (context, state) {
            if (state is GetUsersError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is GetUsersLoading) {
              return LoadingIndicator();
            } else //
            if (state is UsersLoaded) {
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
                        _followBloc.add(FollowUser(users[index].id));
                      },
                      child: const Text('Follow'),
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
