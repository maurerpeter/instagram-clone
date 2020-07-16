import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({@required this.authRepository});

  @override
  AuthState get initialState => AuthUninitialized();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppStarted) {
      // TODO: CHECK IF THE TOKEN IS EXPIRED
      final hasTokenEither = await authRepository.hasToken();

      yield* hasTokenEither.fold(
        (failure) async* {
          yield const AuthError(message: CACHE_FAILURE_MESSAGE);
        },
        (hasToken) async* {
          if (hasToken) {
            yield AuthAuthenticated();
          } else {
            yield AuthUnauthenticated();
          }
        },
      );
    } else
    //
    if (event is LoggedIn) {
      yield AuthLoading();

      final persistedEither = await authRepository.persistToken(event.token);

      yield* persistedEither.fold((failure) async* {
        yield const AuthError(message: CACHE_FAILURE_MESSAGE);
      }, (_) async* {
        yield AuthAuthenticated();
      });
    } else
    //
    if (event is LoggedOut) {
      yield AuthLoading();

      final deletedEither = await authRepository.deleteToken();

      yield* deletedEither.fold((failure) async* {
        yield const AuthError(message: CACHE_FAILURE_MESSAGE);
      }, (_) async* {
        yield AuthUnauthenticated();
      });
    }
  }
}
