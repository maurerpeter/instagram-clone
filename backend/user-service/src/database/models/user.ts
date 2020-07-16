/* eslint-disable @typescript-eslint/no-unused-vars */
import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import Follow from './follow';

export interface UserProps {
  email: string;
  username: string;
  profilePictureUrl?: string;
  numberOffFollowers?: number;
}

export interface UserDTO {
  id?: string;
  email: string;
  username: string;
  profilePictureUrl?: string;
  numberOffFollowers: number;
}

@Entity()
export default class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  email: string;

  @Column()
  username: string;

  @Column({ nullable: true })
  profilePictureUrl?: string;

  @OneToMany((type) => Follow, (follow) => follow.followed)
  followers: Follow[];

  @OneToMany((type) => Follow, (follow) => follow.follower)
  follows: Follow[];

  @Column()
  numberOffFollowers: number;

  constructor(userProps?: UserProps) {
    if (userProps) {
      const {
        email,
        username,
        profilePictureUrl,
        numberOffFollowers,
      } = userProps;
      this.email = email;
      this.username = username;
      this.profilePictureUrl = profilePictureUrl;
      this.numberOffFollowers = numberOffFollowers || 0;
    }
  }

  toJson = (): UserDTO => ({
    id: this.id,
    email: this.email,
    username: this.username,
    profilePictureUrl: this.profilePictureUrl,
    numberOffFollowers: this.numberOffFollowers,
  });
}
