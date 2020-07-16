import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/message_broker/message_broker.dart';
import 'package:instagram_clone/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:instagram_clone/features/chat/data/models/message_model.dart';
import 'package:instagram_clone/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:instagram_clone/features/chat/presentation/pages/messages_page.dart';
import 'package:instagram_clone/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:instagram_clone/features/follow/presentation/bloc/follow_bloc.dart';
import 'package:instagram_clone/features/notifications/domain/entities/comment_notification.dart';
import 'package:instagram_clone/features/notifications/domain/entities/follow_notification.dart';
import 'package:instagram_clone/features/notifications/domain/entities/post_notification.dart';
import 'package:instagram_clone/features/notifications/domain/entities/reaction_notification.dart';
import 'package:instagram_clone/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:instagram_clone/features/notifications/presentation/pages/notifications_page.dart';
import 'package:instagram_clone/features/posts/presentation/bloc/post_bloc.dart';
import 'package:instagram_clone/features/posts/presentation/pages/create_post_page.dart';
import 'package:instagram_clone/features/posts/presentation/pages/posts_page.dart';
import 'package:instagram_clone/features/reaction/presentation/bloc/reaction_bloc.dart';
import 'package:instagram_clone/features/users/presentation/bloc/user_bloc.dart';
import 'package:instagram_clone/features/users/presentation/pages/find_people_page.dart';
import 'package:instagram_clone/features/users/presentation/pages/profile_page.dart';
import 'package:meta/meta.dart';

import '../../../../injection_container.dart';

class HomePage extends StatefulWidget {
  final UserBloc userBloc;
  final ChatBloc chatBloc;

  final PostsPage postsPage;
  final FindPeoplePage findPeoplePage;
  final CreatePostPage createPostPage;
  final NotificationsPage notificationsPage;
  final ProfilePage profilePage;

  const HomePage({
    Key key,
    @required this.userBloc,
    @required this.chatBloc,
    @required this.postsPage,
    @required this.findPeoplePage,
    @required this.createPostPage,
    @required this.notificationsPage,
    @required this.profilePage,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget> _children = [];
  UserBloc get _userBloc => widget.userBloc;
  ChatBloc get _chatBloc => widget.chatBloc;

  PostsPage get _postPage => widget.postsPage;
  FindPeoplePage get _findPeoplePage => widget.findPeoplePage;
  CreatePostPage get _createPostPage => widget.createPostPage;
  NotificationsPage get _notificationPage => widget.notificationsPage;
  ProfilePage get _profilePage => widget.profilePage;

  @override
  void initState() {
    _children = [
      _postPage,
      _findPeoplePage,
      _createPostPage,
      _notificationPage,
      _profilePage,
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram Clone'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessagesPage(
                    userBloc: _userBloc,
                    chatBloc: _chatBloc,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTabTapped,
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: const Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: const Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: const Text('New Post'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: const Text('Notifications'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: const Text('Profile'),
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
