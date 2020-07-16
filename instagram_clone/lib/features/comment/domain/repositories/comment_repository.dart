import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/comment/domain/entities/comment.dart';
import 'package:meta/meta.dart';

abstract class CommentRepository {
  Future<Either<Failure, List<Comment>>> getComments({
    @required String postId,
  });

  Future<Either<Failure, Unit>> createComment({
    @required String postId,
    @required String content,
  });

  Future<Either<Failure, Unit>> deleteComment(String id);
}
