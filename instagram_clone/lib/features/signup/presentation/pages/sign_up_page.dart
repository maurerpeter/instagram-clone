import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';

import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/sign_up_bloc.dart';
import '../widgets/sign_up_form.dart';

class SignUpPage extends StatefulWidget {
  final Function goBack;
  const SignUpPage({Key key, this.goBack}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  SignUpBloc _signUpBloc;
  AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _signUpBloc = SignUpBloc(
      authRepository: sl<AuthRepository>(),
      authBloc: _authBloc,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          widget.goBack();
        }
      },
      bloc: _signUpBloc,
      child: WillPopScope(
        onWillPop: () async {
          widget.goBack();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('SignUp'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => widget.goBack(),
            ),
          ),
          body: SignUpForm(
            authBloc: _authBloc,
            signUpBloc: _signUpBloc,
          ),
        ),
      ),
    );
  }
}
