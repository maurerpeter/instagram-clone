import 'package:flutter/material.dart';
import 'package:instagram_clone/features/login/presentation/pages/login_page.dart';
import 'package:instagram_clone/features/signup/presentation/pages/sign_up_page.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key key}) : super(key: key);

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  String currentPage = '/';

  @override
  Widget build(BuildContext context) {
    if (currentPage == '/') {
      return Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              const Placeholder(),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    currentPage = '/login';
                  });
                },
                child: const Text('Login'),
              ),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    currentPage = '/signup';
                  });
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      );
    } else if (currentPage == '/login') {
      return LoginPage(goBack: goBack);
    } else if (currentPage == '/signup') {
      return SignUpPage(goBack: goBack);
    }
    return null;
  }

  void goBack() {
    setState(() {
      currentPage = '/';
    });
  }
}
