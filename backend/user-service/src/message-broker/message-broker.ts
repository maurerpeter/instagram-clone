import amqp from 'amqplib';
import { config } from '../config';
import { UserDTO } from '../database/models/user';
import Follow from '../database/models/follow';

interface UserMessage {
  username: string;
  profilePictureUrl?: string;
}

export interface UserUpdateMessage {
  method: 'CREATE' | 'UPDATE' | 'DELETE';
  user?: UserMessage;
  follow?: {
    followed: UserMessage;
    follower: UserMessage;
  };
}

export interface FollowNotification {
  type: 'follow';
  follower: UserDTO;
}

const POST_SERVICE_USER_QUEUE = 'post-service-user-sync';
const CHAT_SERVICE_USER_QUEUE = 'chat-service-user-sync';

class MessageBrokerSingleton {
  private connection: amqp.Connection;
  private channel: amqp.Channel;
  private serviceQueues: string[];

  connect = async (): Promise<void> => {
    try {
      this.connection = await amqp.connect(config.AMQP_URL);
      this.channel = await this.connection.createChannel();
      this.serviceQueues = [POST_SERVICE_USER_QUEUE, CHAT_SERVICE_USER_QUEUE];
      console.log('message-broker connected');
    } catch (error) {
      console.error('message-broker', error);
      setTimeout(() => this.connect(), 1000);
    }
  };

  syncWithServices = async (
    userUpdateMessage: UserUpdateMessage
  ): Promise<void> => {
    try {
      await Promise.all(
        this.serviceQueues.map(async (serviceQueue) => {
          await this.channel.assertQueue(serviceQueue);
          return this.channel.sendToQueue(
            serviceQueue,
            Buffer.from(JSON.stringify(userUpdateMessage))
          );
        })
      );
    } catch (error) {
      console.error('[user-service] user-synchronizer', error);
    }
  };

  sendFollowNotification = async (follow: Follow): Promise<void> => {
    const userQueue = follow.followed.username;
    await this.channel.assertQueue(userQueue);
    const followNotification: FollowNotification = {
      type: 'follow',
      follower: follow.follower.toJson(),
    };
    this.channel.sendToQueue(
      userQueue,
      Buffer.from(JSON.stringify(followNotification))
    );
  };

  close = (): void => {
    this.channel.close();
    this.connection.close();
  };
}

export const MessageBroker = new MessageBrokerSingleton();
