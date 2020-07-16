import { Router } from 'express';
import {
  createReaction,
  getReactions,
  getReactionById,
  removeReaction,
} from '../controllers/reaction-controller';
import { authorize } from '../controllers/auth-controller';
import { reactionValidator } from '../validator';

export const reactionsRouter: Router = Router();

reactionsRouter
  .route('/reactions')
  .post(authorize, reactionValidator, createReaction)
  .get(authorize, getReactions);

reactionsRouter
  .route('/reactions/:id')
  .get(authorize, getReactionById)
  .delete(authorize, removeReaction);
