import { Repository, EntityRepository } from 'typeorm';
import Message from '../models/message';
import { getUserRepository } from '..';

interface MessageFindOptions {
  limit?: string;
  offset?: string;
  toUsername?: string;
  fromUsername?: string;
}

const paginate = (
  messages: Message[],
  take: number,
  skip: number
): Message[] => {
  return messages.slice(skip * take, (skip + 1) * take);
};

@EntityRepository(Message)
export class MessageRepository extends Repository<Message> {
  findByUsersWithPagination = async (
    options: MessageFindOptions
  ): Promise<Message[]> => {
    const { limit, offset, toUsername, fromUsername } = options;

    if (!toUsername || !fromUsername) {
      throw new Error();
    }

    if (limit === undefined || offset === undefined) {
      return this.getMessagesOfUsers(toUsername, fromUsername);
    }

    const take = parseInt(limit);
    const skip = parseInt(offset);

    const messagesOfUsers = await this.getMessagesOfUsers(
      toUsername,
      fromUsername
    );

    return paginate(messagesOfUsers, take, skip);
  };

  private getMessagesOfUsers = async (
    toUsername: string,
    fromUsername: string
  ): Promise<Message[]> => {
    const userRepository = getUserRepository();

    const toUser = await userRepository.findOne({ username: toUsername });
    if (!toUser) {
      throw new Error();
    }

    const fromUser = await userRepository.findOne({ username: fromUsername });
    if (!fromUser) {
      throw new Error();
    }

    const messages = await this.find({
      relations: ['to', 'from'],
      order: { date: 'DESC' },
    });

    const messagesOfUsers = messages.filter(
      (message) =>
        (message.to.username === toUsername &&
          message.from.username === fromUsername) ||
        (message.to.username === fromUsername &&
          message.from.username === toUsername)
    );
    return messagesOfUsers;
  };
}
