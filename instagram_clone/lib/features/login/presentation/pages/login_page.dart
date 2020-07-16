import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:instagram_clone/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:instagram_clone/features/login/presentation/bloc/login_bloc.dart';
import 'package:instagram_clone/features/login/presentation/widgets/login_form.dart';
import '../../../../injection_container.dart';

class LoginPage extends StatefulWidget {
  final Function goBack;
  const LoginPage({Key key, this.goBack}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;
  AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _loginBloc = LoginBloc(
      authRepository: sl<AuthRepository>(),
      authBloc: _authBloc,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.goBack();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => widget.goBack(),
          ),
        ),
        body: LoginForm(
          authBloc: _authBloc,
          loginBloc: _loginBloc,
        ),
      ),
    );
  }
}
