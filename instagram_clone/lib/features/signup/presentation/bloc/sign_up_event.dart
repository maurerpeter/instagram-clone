part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class SignUpButtonPressed extends SignUpEvent {
  final String email;
  final String password;

  const SignUpButtonPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
