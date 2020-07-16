import { ReactionDTO } from '../database/models/reaction';
import { PostDTO } from '../database/models/post';
import { CommentDTO } from '../database/models/comment';

export interface ReactionNotification {
  type: 'reaction';
  reaction: ReactionDTO;
}

export interface PostNotification {
  type: 'post';
  post: PostDTO;
}

export interface CommentNotification {
  type: 'comment';
  comment: CommentDTO;
}
