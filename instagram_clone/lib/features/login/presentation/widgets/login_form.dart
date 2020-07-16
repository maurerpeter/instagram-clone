import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/widgets/loading_indicator.dart';
import 'package:instagram_clone/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:instagram_clone/features/login/presentation/bloc/login_bloc.dart';

class LoginForm extends StatefulWidget {
  final LoginBloc loginBloc;
  final AuthBloc authBloc;

  const LoginForm({
    Key key,
    @required this.loginBloc,
    @required this.authBloc,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginBloc get _loginBloc => widget.loginBloc;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      bloc: _loginBloc,
      builder: (
        BuildContext context,
        LoginState state,
      ) {
        return Form(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'email'),
                controller: _emailController,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'password'),
                controller: _passwordController,
                obscureText: true,
              ),
              RaisedButton(
                onPressed:
                    state is! LoginLoading ? _onLoginButtonPressed : null,
                child: const Text('Login'),
              ),
              Container(
                child: state is LoginLoading ? LoadingIndicator() : null,
              ),
            ],
          ),
        );
      },
    );
  }

  void _onLoginButtonPressed() {
    _loginBloc.add(LoginButtonPressed(
      email: _emailController.text,
      password: _passwordController.text,
    ));
  }
}
