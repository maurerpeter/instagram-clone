/* eslint-disable @typescript-eslint/no-unused-vars */
import { Entity, PrimaryGeneratedColumn, ManyToOne, Column } from 'typeorm';
import User, { UserDTO } from './user';

export interface MessageProps {
  from: User;
  to: User;
  content: string;
  date?: Date;
}

export interface MessageDTO {
  id: string;
  to: UserDTO;
  from: UserDTO;
  content: string;
  date: string;
}

@Entity()
export default class Message {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne((type) => User, (user) => user.receivedMessages)
  to: User;

  @ManyToOne((type) => User, (user) => user.sentMessages)
  from: User;

  @Column()
  content: string;

  @Column()
  date: Date;

  constructor(messageProps?: MessageProps) {
    if (messageProps) {
      const { from, to, content, date } = messageProps;
      this.to = to;
      this.from = from;
      this.content = content;
      this.date = date ? date : new Date();
    }
  }

  toJson = (): MessageDTO => ({
    id: this.id,
    to: this.to.toJson(),
    from: this.from.toJson(),
    content: this.content,
    date: this.date.toJSON(),
  });
}
