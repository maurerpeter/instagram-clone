/* eslint-disable no-case-declarations */
import amqp from 'amqplib';
import { config } from '../config';
import {
  getUserRepository,
  getFollowRepository,
  getMessageRepository,
} from '../database';
import User from '../database/models/user';
import Follow from '../database/models/follow';
import Message, { MessageDTO } from '../database/models/message';

export interface ChatMessage {
  from: string; // username
  to: string; //username
  content: string;
}

interface UserMessage {
  username: string;
  profilePictureUrl?: string;
}

interface FollowMessage {
  followed: UserMessage;
  follower: UserMessage;
}

export interface UserUpdateMessage {
  method: 'CREATE' | 'UPDATE' | 'DELETE';
  user?: UserMessage;
  follow?: FollowMessage;
}

export interface ChatNotification {
  type: 'chat';
  message: MessageDTO;
}

const CHAT_SERVICE_USER_QUEUE = 'chat-service-user-sync';
const INCOMING_MESSAGES_QUEUE = 'chat-send-queue';

class MessageBrokerSingleton {
  private connection: amqp.Connection;
  private channel: amqp.Channel;
  private userUpdatesQueue: string;
  private incomingMessagesQueue: string;

  connect = async (): Promise<void> => {
    try {
      this.connection = await amqp.connect(config.AMQP_URL);
      this.channel = await this.connection.createChannel();
      this.userUpdatesQueue = CHAT_SERVICE_USER_QUEUE;
      this.incomingMessagesQueue = INCOMING_MESSAGES_QUEUE;
      await this.listenToUserUpdates();
      await this.listenToIncomingMessages();
      console.log('message-broker connected');
    } catch (error) {
      console.error('message-broker', error);
      setTimeout(() => this.connect(), 1000);
    }
  };

  close = (): void => {
    this.channel.close();
    this.connection.close();
  };

  private listenToIncomingMessages = async (): Promise<void> => {
    await this.channel.assertQueue(this.incomingMessagesQueue);
    this.channel.consume(this.incomingMessagesQueue, async (message) => {
      if (message) {
        try {
          const chatMessage = JSON.parse(
            message.content.toString()
          ) as ChatMessage;
          console.log(
            `received message from user{username:${chatMessage.from}}`
          );
          await this.handleChatMessage(chatMessage);
          this.channel.ack(message);
        } catch (error) {
          setTimeout(() => this.channel.nack(message), 1000);
        }
      }
    });
  };

  private handleChatMessage = async (message: ChatMessage): Promise<void> => {
    const userRepository = getUserRepository();

    const to = await userRepository.findOne({ username: message.to });
    if (!to) {
      throw new Error(`to-user{username:${message.to}} can't be found`);
    }

    const from = await userRepository.findOne({ username: message.from });
    if (!from) {
      throw new Error(`to-user{username:${message.from}} can't be found`);
    }

    const messageRepository = getMessageRepository();
    const toBeMessage = new Message({ to, from, content: message.content });

    const createdMessage = await messageRepository.save(toBeMessage);
    const toUserQueue = to.username;
    await this.channel.assertQueue(toUserQueue);
    const chatNotification: ChatNotification = {
      type: 'chat',
      message: createdMessage.toJson(),
    };
    this.channel.sendToQueue(
      toUserQueue,
      Buffer.from(JSON.stringify(chatNotification))
    );
  };

  private listenToUserUpdates = async (): Promise<void> => {
    await this.channel.assertQueue(this.userUpdatesQueue);
    this.channel.consume(this.userUpdatesQueue, async (message) => {
      if (message) {
        try {
          const userUpdateMessage = JSON.parse(
            message.content.toString()
          ) as UserUpdateMessage;
          console.log(
            `received from user-service: ${JSON.stringify(userUpdateMessage)}`
          );
          await this.handleUserUpdateMessage(userUpdateMessage);
          console.log(`message ${JSON.stringify(userUpdateMessage)} handled`);
          this.channel.ack(message);
        } catch (error) {
          console.log(error);
        }
      }
    });
  };

  private handleUserUpdateMessage = async (
    userUpdateMessage: UserUpdateMessage
  ): Promise<void> => {
    const { method, user, follow } = userUpdateMessage;
    if (user) {
      this.handleUserUpdate(method, user);
    }
    if (follow) {
      this.handleFollowUpdate(method, follow);
    }
  };

  private handleUserUpdate = async (
    method: 'CREATE' | 'UPDATE' | 'DELETE',
    user: UserMessage
  ): Promise<void> => {
    const userRepository = getUserRepository();
    switch (method) {
      case 'CREATE':
        const toBeUser = new User(user);
        await userRepository.save(toBeUser);
        break;
      case 'UPDATE':
        const userToBeUpdated = await userRepository.findOne({
          username: user.username,
        });
        if (!userToBeUpdated) {
          const errorMessage = `user{username: ${user.username}} could not be found`;
          console.error(errorMessage);
          throw new Error(errorMessage);
        }
        userToBeUpdated.profilePictureUrl = user.profilePictureUrl;
        await userRepository.save(userToBeUpdated);
        break;
      case 'DELETE':
        await userRepository.delete({
          username: user.username,
        });
        break;
    }
  };

  private handleFollowUpdate = async (
    method: 'CREATE' | 'UPDATE' | 'DELETE',
    follow: FollowMessage
  ): Promise<void> => {
    const followRepository = getFollowRepository();
    const userRepository = getUserRepository();
    const followed = await userRepository.findOne({
      username: follow.followed.username,
    });
    const follower = await userRepository.findOne({
      username: follow.follower.username,
    });
    if (!followed) {
      const errorMessage = `followed user{username: ${follow.followed.username}} could not be found.`;
      console.error(errorMessage);
      throw new Error(errorMessage);
    }
    if (!follower) {
      const errorMessage = `follower user{username: ${follow.follower.username}} could not be found.`;
      console.error(errorMessage);
      throw new Error(errorMessage);
    }
    switch (method) {
      case 'CREATE':
      // fallthrough
      case 'UPDATE':
        /* eslint-disable-next-line no-case-declarations */
        const toBeFollow = new Follow({ followed, follower });
        await followRepository.save(toBeFollow);
        break;
      case 'DELETE':
        await followRepository.delete({
          followed,
          follower,
        });
        break;
    }
  };
}

export const MessageBroker = new MessageBrokerSingleton();
