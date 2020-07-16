import 'package:instagram_clone/features/chat/domain/entities/chat_message.dart';
import 'package:instagram_clone/features/users/domain/entities/partial_user.dart';
import 'package:meta/meta.dart';

class Message extends ChatMessage {
  final String id;
  final PartialUser from;
  final PartialUser to;
  final String content;
  final DateTime date;

  const Message({
    @required this.id,
    @required this.from,
    @required this.to,
    @required this.content,
    @required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'from': from.id,
      'to': to.id,
      'content': content,
    };
  }

  @override
  List<Object> get props => [id, from, to, content, date];
}
