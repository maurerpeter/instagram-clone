import { RequestHandler } from 'express';
import {
  getCommentRepository,
  getUserRepository,
  getPostRepository,
} from '../database';
import Comment from '../database/models/comment';
import { MessageBroker } from '../message-broker';
import { getUsername } from './util';

interface CreateComment {
  post: string;
  content: string;
}

export const getComments: RequestHandler = async (request, response) => {
  try {
    const { postId } = request.query as { postId?: string };
    const commentRepository = getCommentRepository();
    const postRepository = getPostRepository();
    const posts = await postRepository.find({ relations: ['user'] });

    const comments = await commentRepository.findByPostId(postId);

    response.json(
      comments.map((comment) => {
        const post = posts.find((x) => x.id === comment.post.id);
        if (!post) {
          throw new Error('No post');
        }
        comment.post = post;
        return comment.toJson();
      })
    );
  } catch (error) {
    console.error(error);
    response.sendStatus(500);
  }
};

export const getCommentById: RequestHandler = async (request, response) => {
  try {
    const { id } = request.params;
    const commentRepository = getCommentRepository();
    const comment = await commentRepository.findOne({
      where: { id },
      relations: ['from', 'post'],
    });
    if (!comment) {
      response.sendStatus(404);
      return;
    }
    const postRepository = getPostRepository();
    const post = await postRepository.findOne({
      where: { id: comment.post.id },
      relations: ['user'],
    });
    if (!post) {
      throw new Error('No post');
    }
    comment.post = post;
    response.json(comment.toJson());
  } catch (error) {
    console.error(error);
    response.sendStatus(500);
  }
};

export const createComment: RequestHandler = async (request, response) => {
  try {
    const createComment = request.body as CreateComment;
    const fromUsername = getUsername(request);

    const commentRepository = getCommentRepository();
    const userRepository = getUserRepository();
    const postRepository = getPostRepository();

    const from = await userRepository.findOne({ username: fromUsername });
    if (!from) {
      response.sendStatus(404);
      return;
    }

    const post = await postRepository.findOne({
      where: { id: createComment.post },
      relations: ['user'],
    });
    if (!post) {
      response.sendStatus(404);
      return;
    }

    const toBeComment = new Comment({
      from,
      post,
      content: createComment.content,
    });
    const createdComment = await commentRepository.save(toBeComment);
    await MessageBroker.sendCommentNotification(createdComment);
    response.status(201).json(createdComment.toJson());
  } catch (error) {
    console.error(error);
    response.sendStatus(500);
  }
};

export const removeComment: RequestHandler = async (request, response) => {
  try {
    const { id } = request.params;
    const commentRepository = getCommentRepository();
    const comment = await commentRepository.findOne({
      where: { id },
    });
    if (!comment) {
      response.sendStatus(404);
      return;
    }
    await commentRepository.remove(comment);
    response.sendStatus(204);
  } catch (error) {
    console.error(error);
    response.sendStatus(500);
  }
};
