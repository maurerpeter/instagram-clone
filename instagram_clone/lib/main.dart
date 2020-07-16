import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/message_broker/message_broker.dart';
import 'package:instagram_clone/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:instagram_clone/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:instagram_clone/features/follow/presentation/bloc/follow_bloc.dart';
import 'package:instagram_clone/features/reaction/presentation/bloc/reaction_bloc.dart';

import 'core/widgets/loading_indicator.dart';
import 'env/config_reader.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/home_page.dart';
import 'features/auth/presentation/pages/initial_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/chat/data/models/message_model.dart';
import 'features/notifications/domain/entities/comment_notification.dart';
import 'features/notifications/domain/entities/follow_notification.dart';
import 'features/notifications/domain/entities/post_notification.dart';
import 'features/notifications/domain/entities/reaction_notification.dart';
import 'features/notifications/presentation/bloc/notification_bloc.dart';
import 'features/notifications/presentation/pages/notifications_page.dart';
import 'features/posts/presentation/bloc/post_bloc.dart';
import 'features/posts/presentation/pages/create_post_page.dart';
import 'features/posts/presentation/pages/posts_page.dart';
import 'features/users/presentation/bloc/user_bloc.dart';
import 'features/users/presentation/pages/find_people_page.dart';
import 'features/users/presentation/pages/profile_page.dart';
import 'injection_container.dart' as di;

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    // ignore: avoid_print
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // ignore: avoid_print
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    // ignore: avoid_print
    print(error);
  }
}

// ignore: avoid_void_async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConfigReader.initialize();
  await di.init();
  BlocSupervisor.delegate = SimpleBlocDelegate();

  di.sl<MessageBroker>();
  await (() {
    return Future.delayed(const Duration(seconds: 1));
  })();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>()..add(AppStarted()),
        ),
        BlocProvider<PostBloc>(
          create: (context) => di.sl<PostBloc>(),
        ),
        BlocProvider<ReactionBloc>(
          create: (context) => di.sl<ReactionBloc>(),
        ),
        BlocProvider<CommentBloc>(
          create: (context) => di.sl<CommentBloc>(),
        ),
        BlocProvider<UserBloc>(
          create: (context) => di.sl<UserBloc>(),
        ),
        BlocProvider<FollowBloc>(
          create: (context) => di.sl<FollowBloc>(),
        ),
        BlocProvider<NotificationBloc>(
          create: (context) => di.sl<NotificationBloc>(),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => di.sl<ChatBloc>(),
        ),
      ],
      child: App(authRepository: di.sl<AuthRepository>()),
    ),
  );
}

class App extends StatelessWidget {
  final AuthRepository authRepository;

  const App({Key key, @required this.authRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthUninitialized) {
              return SplashPage();
            } else
            //
            if (state is AuthAuthenticated) {
              final MessageBroker messageBroker = di.sl<MessageBroker>();
              final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
              final PostBloc postBloc = BlocProvider.of<PostBloc>(context);
              final ReactionBloc reactionBloc =
                  BlocProvider.of<ReactionBloc>(context);
              final CommentBloc commentBloc =
                  BlocProvider.of<CommentBloc>(context);
              final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
              final FollowBloc followBloc =
                  BlocProvider.of<FollowBloc>(context);
              final NotificationBloc notificationBloc =
                  BlocProvider.of<NotificationBloc>(context);
              final ChatBloc chatBloc = BlocProvider.of<ChatBloc>(context);

              messageBroker.subscribeToMessages(
                followNotificationCallback: (json) {
                  notificationBloc.add(
                    NewFollowNotification(
                        notification: FollowNotification.fromJson(json)),
                  );
                },
                postNotificationCallback: (json) {
                  notificationBloc.add(
                    NewPostNotification(
                        notification: PostNotification.fromJson(json)),
                  );
                },
                reactionNotificationCallback: (json) {
                  notificationBloc.add(
                    NewReactionNotification(
                        notification: ReactionNotification.fromJson(json)),
                  );
                },
                commentNotificationCallback: (json) {
                  notificationBloc.add(
                    NewCommentNotification(
                        notification: CommentNotification.fromJson(json)),
                  );
                },
                chatNotificationCallback: (json) {
                  chatBloc.add(NewChatMessage(
                      message: MessageModel.fromJson(json['message'])));
                },
              );

              final postsPage = PostsPage(
                postBloc: postBloc,
                reactionBloc: reactionBloc,
                commentBloc: commentBloc,
              );
              final findPeoplePage = FindPeoplePage(
                userBloc: userBloc..add(const GetUsers('')),
                followBloc: followBloc,
              );
              final createPostPage = CreatePostPage(postBloc: postBloc);
              final notificationsPage =
                  NotificationsPage(notificationBloc: notificationBloc);
              final profilePage =
                  ProfilePage(authBloc: authBloc, userBloc: userBloc);
              return HomePage(
                userBloc: userBloc,
                chatBloc: chatBloc,
                postsPage: postsPage,
                findPeoplePage: findPeoplePage,
                createPostPage: createPostPage,
                notificationsPage: notificationsPage,
                profilePage: profilePage,
              );
            } else
            //
            if (state is AuthUnauthenticated) {
              return const InitialPage();
            } else
            //
            if (state is AuthLoading) {
              return LoadingIndicator();
            }
            if (state is AuthError) {
              return Center(child: Text(state.message));
            }
            // This case should not happen. If it happens, null will trigger
            // an error, which is the expected behaviour.
            return null;
          },
        ),
      ),
    );
  }
}
