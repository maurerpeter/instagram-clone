/* eslint-disable @typescript-eslint/no-unused-vars */
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import User, { UserDTO } from './user';
import Post, { PostDTO } from './post';

export interface CommentProps {
  from: User;
  post: Post;
  content: string;
}

export interface CommentDTO {
  id: string;
  from: UserDTO;
  post: PostDTO;
  content: string;
}

@Entity()
export default class Comment {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne((type) => User, (user) => user.comments)
  from: User;

  @ManyToOne((type) => Post, (post) => post.comments)
  post: Post;

  @Column()
  content: string;

  constructor(commentProps?: CommentProps) {
    if (commentProps) {
      const { from, post, content } = commentProps;
      this.from = from;
      this.post = post;
      this.content = content;
    }
  }

  toJson = (): CommentDTO => ({
    id: this.id,
    from: this.from.toJson(),
    post: this.post.toJson(),
    content: this.content,
  });
}
