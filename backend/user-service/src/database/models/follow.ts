/* eslint-disable @typescript-eslint/no-unused-vars */
import { Entity, PrimaryGeneratedColumn, ManyToOne } from 'typeorm';
import User, { UserDTO } from './user';

export interface FollowProps {
  follower: User;
  followed: User;
}

export interface FollowDTO {
  follower: UserDTO;
  followed: UserDTO;
}

@Entity()
export default class Follow {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne((type) => User, (user) => user.follows)
  follower: User;

  @ManyToOne((type) => User, (user) => user.followers)
  followed: User;

  constructor(followProps?: FollowProps) {
    if (followProps) {
      const { follower, followed } = followProps;
      this.follower = follower;
      this.followed = followed;
    }
  }

  toJson = (): FollowDTO => ({
    follower: this.follower.toJson(),
    followed: this.followed.toJson(),
  });
}
