part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthUninitialized extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({@required this.message});

  @override
  List<Object> get props => [message];
}
