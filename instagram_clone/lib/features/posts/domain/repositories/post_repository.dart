import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getPosts({
    @required int limit,
    @required int offset,
  });

  Future<Either<Failure, Unit>> createPost(
      {@required String description, @required File media});

  Future<Either<Failure, Unit>> deletePost(String id);
}
