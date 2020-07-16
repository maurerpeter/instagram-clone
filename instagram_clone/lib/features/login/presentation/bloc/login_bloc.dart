import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  final AuthBloc authBloc;

  LoginBloc({
    @required this.authRepository,
    @required this.authBloc,
  });

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      final token = await authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      yield* token.fold((failure) async* {
        yield const LoginFailure(error: SERVER_FAILURE_MESSAGE);
      }, (jwtToken) async* {
        authBloc.add(LoggedIn(token: jwtToken.token));
        yield LoginSuccess();
      });
    }
  }
}
