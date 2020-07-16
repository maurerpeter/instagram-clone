import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

export interface UserProps {
  email: string;
  password: string;
}

@Entity()
export default class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  email: string;

  @Column()
  password: string;

  constructor(userProps?: UserProps) {
    if (userProps) {
      const { email, password } = userProps;
      this.email = email;
      this.password = password;
    }
  }
}
