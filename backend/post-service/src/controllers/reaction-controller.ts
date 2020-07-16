import { RequestHandler } from 'express';
import {
  getReactionRepository,
  getUserRepository,
  getPostRepository,
} from '../database';
import { ReactionType } from '../constants';
import Reaction from '../database/models/reaction';
import { MessageBroker } from '../message-broker';
import { getUsername } from './util';

interface CreateReaction {
  post: string;
  type: ReactionType;
}

export const getReactions: RequestHandler = async (request, response) => {
  try {
    const { postId } = request.query as { postId?: string };
    const reactionRepository = getReactionRepository();
    const postRepository = getPostRepository();
    const posts = await postRepository.find({ relations: ['user'] });

    const reactions = await reactionRepository.findByPostId(postId);

    response.json(
      reactions.map(async (reaction) => {
        const post = posts.find((x) => x.id === reaction.post.id);
        if (!post) {
          throw new Error('No post');
        }
        reaction.post = post;
        return reaction.toJson();
      })
    );
  } catch (error) {
    console.error(error);
    response.sendStatus(500);
  }
};

export const getReactionById: RequestHandler = async (request, response) => {
  try {
    const { id } = request.params;
    const reactionRepository = getReactionRepository();
    const reaction = await reactionRepository.findOne({
      where: { id },
      relations: ['from', 'post'],
    });
    if (!reaction) {
      response.sendStatus(404);
      return;
    }
    const postRepository = getPostRepository();
    const post = await postRepository.findOne({
      where: { id: reaction.post.id },
      relations: ['user'],
    });
    if (!post) {
      throw new Error('No post');
    }
    reaction.post = post;
    response.json(reaction.toJson());
  } catch (error) {
    console.error(error);
    response.sendStatus(500);
  }
};

export const createReaction: RequestHandler = async (request, response) => {
  try {
    const createReaction = request.body as CreateReaction;
    const fromUsername = getUsername(request);

    const reactionRepository = getReactionRepository();
    const userRepository = getUserRepository();
    const postRepository = getPostRepository();

    const from = await userRepository.findOne({ username: fromUsername });
    if (!from) {
      response.sendStatus(404);
      return;
    }

    const post = await postRepository.findOne({
      where: { id: createReaction.post },
      relations: ['user'],
    });
    if (!post) {
      response.sendStatus(404);
      return;
    }

    const toBeReaction = new Reaction({
      from,
      post,
      type: createReaction.type,
    });
    const createdReaction = await reactionRepository.save(toBeReaction);

    createdReaction.post = post;
    await MessageBroker.sendReactionNotification(createdReaction);
    response.status(201).json(createdReaction.toJson());
  } catch (error) {
    console.error(error);
    response.sendStatus(500);
  }
};

export const removeReaction: RequestHandler = async (request, response) => {
  try {
    const { id } = request.params;
    const reactionRepository = getReactionRepository();
    const reaction = await reactionRepository.findOne({
      where: { id },
    });
    if (!reaction) {
      response.sendStatus(404);
      return;
    }
    await reactionRepository.remove(reaction);
    response.sendStatus(204);
  } catch (error) {
    console.error(error);
    response.sendStatus(500);
  }
};
