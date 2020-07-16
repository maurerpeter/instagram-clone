import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/widgets/loading_indicator.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/sign_up_bloc.dart';

class SignUpForm extends StatefulWidget {
  final SignUpBloc signUpBloc;
  final AuthBloc authBloc;

  const SignUpForm({
    Key key,
    @required this.signUpBloc,
    @required this.authBloc,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  SignUpBloc get _signUpBloc => widget.signUpBloc;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      bloc: _signUpBloc,
      builder: (
        BuildContext context,
        SignUpState state,
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
                    state is! SignUpLoading ? _onLoginButtonPressed : null,
                child: const Text('Sign Up'),
              ),
              Container(
                child: state is SignUpLoading ? LoadingIndicator() : null,
              ),
            ],
          ),
        );
      },
    );
  }

  void _onLoginButtonPressed() {
    _signUpBloc.add(SignUpButtonPressed(
      email: _emailController.text,
      password: _passwordController.text,
    ));
  }
}
