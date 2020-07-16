import 'package:instagram_clone/features/chat/domain/entities/message.dart';
import 'package:instagram_clone/features/users/data/models/partial_user_model.dart';
import 'package:meta/meta.dart';

class MessageModel extends Message {
  const MessageModel({
    @required String id,
    @required PartialUserModel from,
    @required PartialUserModel to,
    @required String content,
    @required DateTime date,
  }) : super(
          id: id,
          from: from,
          to: to,
          content: content,
          date: date,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      from: PartialUserModel.fromJson(json['from']),
      to: PartialUserModel.fromJson(json['to']),
      content: json['content'],
      date: DateTime.parse(json['date']),
    );
  }
}
