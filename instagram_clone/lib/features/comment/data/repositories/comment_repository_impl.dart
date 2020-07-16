import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/auth/domain/entities/jwt_token.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:instagram_clone/features/comment/data/datasources/comment_remote_data_source.dart';
import 'package:instagram_clone/features/comment/domain/entities/comment.dart';
import 'package:instagram_clone/features/comment/domain/repositories/comment_repository.dart';
import 'package:meta/meta.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;
  final AuthRepository authRepository;

  CommentRepositoryImpl({
    @required this.remoteDataSource,
    @required this.authRepository,
  });

  @override
  Future<Either<Failure, Unit>> createComment({
    String postId,
    String content,
  }) async {
    try {
      final jwtToken = await _getJwtToken();
      await remoteDataSource.createComment(
        jwtToken: jwtToken,
        postId: postId,
        content: content,
      );
      return Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteComment(String id) async {
    try {
      final jwtToken = await _getJwtToken();
      await remoteDataSource.deleteComment(jwtToken: jwtToken, id: id);
      return Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> getComments({String postId}) async {
    try {
      final jwtToken = await _getJwtToken();
      final List<Comment> comments = await remoteDataSource.getComments(
        jwtToken: jwtToken,
        postId: postId,
      );
      return Right(comments);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  /// Throws [ServerException] when no token is found
  Future<JwtToken> _getJwtToken() async {
    final failureOrToken = await authRepository.getToken();
    final jwtToken = failureOrToken.fold(
      (_) {
        throw ServerException();
      },
      (token) => token,
    );
    return jwtToken;
  }
}
