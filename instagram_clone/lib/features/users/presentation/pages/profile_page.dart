import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:instagram_clone/features/users/presentation/bloc/user_bloc.dart';
import 'package:meta/meta.dart';

class ProfilePage extends StatefulWidget {
  final AuthBloc authBloc;
  final UserBloc userBloc;

  const ProfilePage({
    Key key,
    @required this.authBloc,
    @required this.userBloc,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File _imageFile;

  AuthBloc get _authBloc => widget.authBloc;
  UserBloc get _userBloc => widget.userBloc;

  Future<void> updateProfilePicture() async {
    _userBloc.add(PatchUser(profilePicture: _imageFile));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      bloc: _userBloc,
      listener: (context, state) {
        if (state is PatchUserError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is PatchUserSuccess) {
          _clear();
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile picture updated'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                  onPressed: () {
                    _authBloc.add(LoggedOut());
                  },
                  child: const Text('Logout')),
              IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              IconButton(
                icon: Icon(Icons.photo_library),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        ),
        body: ListView(
          children: <Widget>[
            if (_imageFile != null) ...[
              Image.file(_imageFile),
              Row(
                children: <Widget>[
                  FlatButton(
                    onPressed: _cropImage,
                    child: Icon(Icons.crop),
                  ),
                  FlatButton(
                    onPressed: _clear,
                    child: Icon(Icons.refresh),
                  ),
                ],
              ),
              RaisedButton(
                onPressed: updateProfilePicture,
                child: const Text('Update Profile Picture'),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final File selected = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = selected;
    });
    _cropImage();
  }

  Future<void> _cropImage() async {
    final File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      maxWidth: 100,
      maxHeight: 100,
    );
    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }
}
