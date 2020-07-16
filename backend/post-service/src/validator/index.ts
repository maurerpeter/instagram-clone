import Joi from '@hapi/joi';
import { RequestHandler } from 'express';
import { PostType, ReactionType } from '../constants';

const createRequestValidator = (schema: Joi.ObjectSchema): RequestHandler => (
  request,
  response,
  next
): void => {
  console.log(JSON.stringify(request.body));
  const { error } = schema.required().validate(request.body);
  if (error) {
    console.error(error);
    response.sendStatus(400);
  } else {
    next();
  }
};

const postSchema = Joi.object({
  description: Joi.string().required(),
  type: Joi.string().valid(PostType.image, PostType.video),
});

const reactionSchema = Joi.object({
  post: Joi.string().required(),
  type: Joi.string().valid(ReactionType.happy, ReactionType.sad),
});

const commentSchema = Joi.object({
  post: Joi.string().required(),
  content: Joi.string().required(),
});

export const postValidator = createRequestValidator(postSchema);

export const reactionValidator = createRequestValidator(reactionSchema);

export const commentValidator = createRequestValidator(commentSchema);
