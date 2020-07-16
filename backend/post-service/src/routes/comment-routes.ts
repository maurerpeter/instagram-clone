import { Router } from 'express';
import { authorize } from '../controllers/auth-controller';
import { commentValidator } from '../validator';
import {
  createComment,
  getComments,
  getCommentById,
  removeComment,
} from '../controllers/comment-controller';

export const commentsRouter: Router = Router();

commentsRouter
  .route('/comments')
  .post(authorize, commentValidator, createComment)
  .get(authorize, getComments);

commentsRouter
  .route('/comments/:id')
  .get(authorize, getCommentById)
  .delete(authorize, removeComment);
