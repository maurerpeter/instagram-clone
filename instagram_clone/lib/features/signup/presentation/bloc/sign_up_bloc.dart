import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepository;
  final AuthBloc authBloc;

  SignUpBloc({
    @required this.authRepository,
    @required this.authBloc,
  });

  @override
  SignUpState get initialState => SignUpInitial();

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is SignUpButtonPressed) {
      yield SignUpLoading();

      final token = await authRepository.signUpWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      yield* token.fold((failure) async* {
        yield const SignUpFailure(error: SERVER_FAILURE_MESSAGE);
      }, (_) async* {
        yield SignUpSuccess();
      });
    }
  }
}
