/* eslint-disable @typescript-eslint/no-unused-vars */
import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import Post from './post';
import Follow from './follow';
import Reaction from './reaction';
import Comment from './comment';

export interface UserProps {
  username: string;
  profilePictureUrl?: string;
}

export interface UserDTO {
  id: string;
  username: string;
  profilePictureUrl?: string;
}

@Entity()
export default class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  username: string;

  @Column({ nullable: true })
  profilePictureUrl?: string;

  @OneToMany((type) => Post, (post) => post.user)
  posts: Post[];

  @OneToMany((type) => Follow, (follow) => follow.followed)
  followers: Follow[];

  @OneToMany((type) => Follow, (follow) => follow.follower)
  follows: Follow[];

  @OneToMany((type) => Reaction, (reaction) => reaction.from)
  reactions: Reaction[];

  @OneToMany((type) => Comment, (comment) => comment.from)
  comments: Comment[];

  constructor(userProps?: UserProps) {
    if (userProps) {
      const { username, profilePictureUrl } = userProps;
      this.username = username;
      this.profilePictureUrl = profilePictureUrl;
    }
  }

  toJson = (): UserDTO => ({
    id: this.id,
    username: this.username,
    profilePictureUrl: this.profilePictureUrl,
  });
}
