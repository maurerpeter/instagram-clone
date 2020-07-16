import Joi from '@hapi/joi';
import { RequestHandler } from 'express';

const createRequestValidator = (schema: Joi.ObjectSchema): RequestHandler => (
  request,
  response,
  next
): void => {
  const { error } = schema.required().validate(request.body);
  if (error) {
    response.sendStatus(400);
  } else {
    next();
  }
};

const userSchema = Joi.object({
  email: Joi.string().min(5).required(),
  username: Joi.string().min(5).required(),
});

export const userValidator = createRequestValidator(userSchema);
