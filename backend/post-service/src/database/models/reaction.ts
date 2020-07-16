/* eslint-disable @typescript-eslint/no-unused-vars */
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import User, { UserDTO } from './user';
import Post, { PostDTO } from './post';
import { ReactionType } from '../../constants';

export interface ReactionProps {
  from: User;
  post: Post;
  type: ReactionType;
}

export interface ReactionDTO {
  id: string;
  from: UserDTO;
  post: PostDTO;
  type: ReactionType;
}

@Entity()
export default class Reaction {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne((type) => User, (user) => user.reactions)
  from: User;

  @ManyToOne((type) => Post, (post) => post.reactions)
  post: Post;

  @Column()
  type: ReactionType;

  constructor(reactionProps?: ReactionProps) {
    if (reactionProps) {
      const { from, post, type } = reactionProps;
      this.from = from;
      this.post = post;
      this.type = type;
    }
  }

  toJson = (): ReactionDTO => ({
    id: this.id,
    from: this.from.toJson(),
    post: this.post.toJson(),
    type: this.type,
  });
}
