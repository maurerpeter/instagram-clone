import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/auth/domain/entities/jwt_token.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:instagram_clone/features/chat/data/datasources/message_remote_data_source.dart';
import 'package:instagram_clone/features/chat/domain/entities/message.dart';
import 'package:instagram_clone/features/chat/domain/repositories/chat_repository.dart';
import 'package:meta/meta.dart';

class ChatRepositoryImpl implements ChatRepository {
  final AuthRepository authRepository;
  final MessageRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({
    @required this.authRepository,
    @required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Message>>> getMessages({
    String username,
    int limit,
    int offset,
  }) async {
    try {
      final jwtToken = await _getJwtToken();
      final List<Message> messages = await remoteDataSource.getMessages(
        jwtToken: jwtToken,
        username: username,
        limit: limit,
        offset: offset,
      );
      return Right(messages);
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
