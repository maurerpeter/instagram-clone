/* eslint-disable @typescript-eslint/no-unused-vars */
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  OneToMany,
} from 'typeorm';
import User, { UserDTO } from './user';
import { PostType } from '../../constants';
import Reaction from './reaction';
import Comment from './comment';

export interface PostProps {
  user: User;
  description: string;
  type: PostType;
  mediaUrl: string;
}

export interface PostDTO {
  id: string;
  user: UserDTO;
  description: string;
  type: string;
  mediaUrl: string;
}

@Entity()
export default class Post {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne((type) => User, (user) => user.posts)
  user: User;

  @Column()
  description: string;

  @Column()
  type: PostType;

  @Column()
  mediaUrl: string;

  @OneToMany((type) => Reaction, (reaction) => reaction.post)
  reactions: Reaction[];

  @OneToMany((type) => Comment, (comment) => comment.post)
  comments: Comment[];

  constructor(postProps?: PostProps) {
    if (postProps) {
      const { user, description, type, mediaUrl } = postProps;
      this.user = user;
      this.description = description;
      this.type = type;
      this.mediaUrl = mediaUrl;
    }
  }

  toJson = (): PostDTO => ({
    id: this.id,
    user: this.user.toJson(),
    description: this.description,
    type: this.type,
    mediaUrl: this.mediaUrl,
  });
}
