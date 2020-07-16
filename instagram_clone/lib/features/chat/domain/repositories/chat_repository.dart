import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/chat/domain/entities/message.dart';
import 'package:meta/meta.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<Message>>> getMessages({
    @required String username,
    @required int limit,
    @required int offset,
  });
}
