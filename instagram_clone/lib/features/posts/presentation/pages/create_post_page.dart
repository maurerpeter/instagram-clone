import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:meta/meta.dart';

import 'package:instagram_clone/env/config_reader.dart';
import 'package:instagram_clone/features/posts/presentation/bloc/post_bloc.dart';
import 'package:instagram_clone/features/posts/presentation/widgets/video_player.dart';

class CreatePostPage extends StatefulWidget {
  final String url = ConfigReader.getPostsUrl();
  final PostBloc postBloc;

  CreatePostPage({
    Key key,
    @required this.postBloc,
  }) : super(key: key);

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  File _imageFile;
  File _videoFile;
  final _descriptionController = TextEditingController();

  PostBloc get _postBloc => widget.postBloc;

  Future<void> uploadImage() async {
    _postBloc.add(CreatePost(
      description: _descriptionController.text ?? 'No description',
      media: _imageFile,
    ));
  }

  Future<void> uploadVideo() async {
    _postBloc.add(CreatePost(
      description: _descriptionController.text ?? 'No description',
      media: _videoFile,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      bloc: _postBloc,
      listener: (context, state) {
        if (state is CreatePostError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is PostCreated) {
          _clear();
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: const Text('Post created'),
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
              IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              IconButton(
                icon: Icon(Icons.photo_library),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
              IconButton(
                icon: Icon(Icons.videocam),
                onPressed: () => _pickVideo(ImageSource.camera),
              ),
              IconButton(
                icon: Icon(Icons.video_library),
                onPressed: () => _pickVideo(ImageSource.gallery),
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                controller: _descriptionController,
              ),
              RaisedButton(
                onPressed: uploadImage,
                child: const Text('Upload Post'),
              ),
            ] else
            //
            if (_videoFile != null) ...[
              VideoPlayerWidget(
                videoPlayerController: VideoPlayerController.file(_videoFile),
                looping: true,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                controller: _descriptionController,
              ),
              FlatButton(
                onPressed: _clear,
                child: Icon(Icons.refresh),
              ),
              RaisedButton(
                onPressed: uploadVideo,
                child: const Text('Upload Post'),
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
      _videoFile = null;
    });
  }

  Future<void> _pickVideo(ImageSource source) async {
    final File selected = await ImagePicker.pickVideo(source: source);
    setState(() {
      _videoFile = selected;
      _imageFile = null;
    });
  }

  Future<void> _cropImage() async {
    final File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      maxWidth: 512,
      maxHeight: 512,
    );
    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  void _clear() {
    setState(() {
      _imageFile = null;
      _videoFile = null;
    });
  }
}
