import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_clone/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:instagram_clone/features/chat/domain/repositories/chat_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/message_broker/message_broker.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/chat/data/datasources/message_remote_data_source.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/comment/data/datasources/comment_remote_data_source.dart';
import 'features/comment/data/repositories/comment_repository_impl.dart';
import 'features/comment/domain/repositories/comment_repository.dart';
import 'features/comment/presentation/bloc/comment_bloc.dart';
import 'features/follow/presentation/bloc/follow_bloc.dart';
import 'features/login/presentation/bloc/login_bloc.dart';
import 'features/notifications/presentation/bloc/notification_bloc.dart';
import 'features/posts/data/datasrouces/post_remote_data_source.dart';
import 'features/posts/data/repositories/post_repository_impl.dart';
import 'features/posts/domain/repositories/post_repository.dart';
import 'features/posts/presentation/bloc/post_bloc.dart';
import 'features/reaction/data/datasources/reaction_remote_data_source.dart';
import 'features/reaction/data/repositories/reaction_repository_impl.dart';
import 'features/reaction/domain/repositories/reaction_repository.dart';
import 'features/reaction/presentation/bloc/reaction_bloc.dart';
import 'features/signup/presentation/bloc/sign_up_bloc.dart';
import 'features/users/data/datasources/user_remote_data_source.dart';
import 'features/users/data/repositories/user_repository_impl.dart';
import 'features/users/domain/repositories/user_repository.dart';
import 'features/users/presentation/bloc/user_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  //! Message broker
  sl.registerLazySingleton<MessageBroker>(
    () => MessageBroker(authRepository: sl<AuthRepository>()),
  );

  //! Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(authRepository: sl<AuthRepository>()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl<AuthRemoteDataSource>(),
      authLocalDataSource: sl<AuthLocalDataSource>(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(storage: sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl<http.Client>()),
  );

  //! Features - Login
  // Bloc
  sl.registerFactory(
    () => LoginBloc(
      authRepository: sl<AuthRepository>(),
      authBloc: sl<AuthBloc>(),
    ),
  );

  //! Features - SignUp
  // Bloc
  sl.registerFactory(
    () => SignUpBloc(
      authRepository: sl<AuthRepository>(),
      authBloc: sl<AuthBloc>(),
    ),
  );

  //! Features - Users
  // Bloc
  sl.registerFactory(
    () => UserBloc(userRepository: sl<UserRepository>()),
  );

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      authRepository: sl<AuthRepository>(),
      remoteDataSource: sl<UserRemoteDataSource>(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(client: sl<http.Client>()),
  );

  //! Features - Follow
  // Bloc
  sl.registerFactory(
    () => FollowBloc(userRepository: sl<UserRepository>()),
  );

  //! Features - Posts
  // Bloc
  sl.registerFactory(
    () => PostBloc(postRepository: sl<PostRepository>()),
  );

  // Repository
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      authRepository: sl<AuthRepository>(),
      remoteDataSource: sl<PostRemoteDataSource>(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(client: sl<http.Client>()),
  );

  //! Features - Reactions
  // Bloc
  sl.registerFactory(
    () => ReactionBloc(reactionRepository: sl<ReactionRepository>()),
  );

  // Repository
  sl.registerLazySingleton<ReactionRepository>(
    () => ReactionRepositoryImpl(
      remoteDataSource: sl<ReactionRemoteDataSource>(),
      authRepository: sl<AuthRepository>(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ReactionRemoteDataSource>(
    () => ReactionRemoteDataSourceImpl(client: sl<http.Client>()),
  );

  //! Features - Comments
  // Bloc
  sl.registerFactory(
    () => CommentBloc(commentRepository: sl<CommentRepository>()),
  );

  // Repository
  sl.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(
      remoteDataSource: sl<CommentRemoteDataSource>(),
      authRepository: sl<AuthRepository>(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<CommentRemoteDataSource>(
    () => CommentRemoteDataSourceImpl(client: sl<http.Client>()),
  );

  //! Features - Notifications
  // Bloc
  sl.registerFactory(() => NotificationBloc());

  //! Features - Chat
  // Bloc
  sl.registerFactory(
    () => ChatBloc(
      chatRepository: sl<ChatRepository>(),
      messageBroker: sl<MessageBroker>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      authRepository: sl<AuthRepository>(),
      remoteDataSource: sl<MessageRemoteDataSource>(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<MessageRemoteDataSource>(
    () => MessageRemoteDataSourceImpl(client: sl<http.Client>()),
  );

  //! Core

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
}
