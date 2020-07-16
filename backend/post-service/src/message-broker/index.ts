/* eslint-disable no-case-declarations */
import amqp from 'amqplib';
import { config } from '../config';
import {
  getUserRepository,
  getFollowRepository,
  getPostRepository,
} from '../database';
import User from '../database/models/user';
import Follow from '../database/models/follow';
import Reaction from '../database/models/reaction';
import {
  ReactionNotification,
  PostNotification,
  CommentNotification,
} from './notification-interfaces';
import Post from '../database/models/post';
import Comment from '../database/models/comment';

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

const POST_SERVICE_QUEUE = 'post-service-user-sync';

class MessageBrokerSingleton {
  private connection: amqp.Connection;
  private channel: amqp.Channel;
  private userUpdatesQueue: string;

  connect = async (): Promise<void> => {
    try {
      this.connection = await amqp.connect(config.AMQP_URL);
      this.channel = await this.connection.createChannel();
      this.userUpdatesQueue = POST_SERVICE_QUEUE;
      await this.listenToUserUpdates();
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

  sendPostNotification = async (post: Post): Promise<void> => {
    const userRepository = getUserRepository();
    const userFollowers = await userRepository.findFollowersOfUser(
      post.user.username
    );
    const userQueues = userFollowers.map((follower) => follower.username);
    userQueues.map(async (userQueue) => {
      await this.channel.assertQueue(userQueue);
      const postNotification: PostNotification = {
        type: 'post',
        post: post.toJson(),
      };
      this.channel.sendToQueue(
        userQueue,
        Buffer.from(JSON.stringify(postNotification))
      );
    });
  };

  sendReactionNotification = async (reaction: Reaction): Promise<void> => {
    const postRepository = getPostRepository();
    const post = await postRepository.findOne({
      where: { id: reaction.post.id },
      relations: ['user'],
    });
    if (!post) {
      throw new Error('No post');
    }

    reaction.post = post;
    const userQueue = reaction.post.user.username;
    await this.channel.assertQueue(userQueue);
    const reactionNotification: ReactionNotification = {
      type: 'reaction',
      reaction: reaction.toJson(),
    };
    this.channel.sendToQueue(
      userQueue,
      Buffer.from(JSON.stringify(reactionNotification))
    );
  };

  sendCommentNotification = async (comment: Comment): Promise<void> => {
    const userQueue = comment.post.user.username;
    await this.channel.assertQueue(userQueue);
    const commentNotification: CommentNotification = {
      type: 'comment',
      comment: comment.toJson(),
    };
    this.channel.sendToQueue(
      userQueue,
      Buffer.from(JSON.stringify(commentNotification))
    );
  };
}

export const MessageBroker = new MessageBrokerSingleton();
