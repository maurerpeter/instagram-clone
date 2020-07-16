import 'package:instagram_clone/features/chat/domain/entities/chat_message.dart';
import 'package:meta/meta.dart';

class SendMessage extends ChatMessage {
  final String to;
  final String content;

  const SendMessage({
    @required this.to,
    @required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'to': to,
      'content': content,
    };
  }

  @override
  List<Object> get props => [to, content];
}
