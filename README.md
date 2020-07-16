# Instagram Clone

## Theme
Instagram-like application with more limited functionality

## Tasks

- [x] nginx reverse proxy
- [x] login
  - [x] auth-service
  - [x] frontend
- [x] signup
  - [x] auth-service: save user in db
  - [x] auth-service: send user information to user-service via http
  - [x] user-service: save user in db
  - [x] user-service: send user information to post-service and chat-service via rabbitmq
  - [x] post-service: save user in db
  - [x] chat-service: save user in db
  - [x] frontend
- [x] fetch not followed users
  - [x] user-service: return users excluding followed ones
  - [x] frontend
- [x] fetch followed users
  - [x] user-service: return users that the user follows
  - [x] frontend
- [x] follow other user
  - [x] user-service: save new follow to db, update user followers count
  - [x] user-service: send notification to frontend via rabbitmq
  - [x] frontend
- [ ] un-follow other user
  - [x] user-service: delete existing follow in db, update user followers count
  - [ ] frontend
- [x] create post
  - [x] post-service: save post to db and media(image/video) to disk
  - [x] post-service: send notification to followers of the user via rabbitmq
  - [x] frontend
- [x] get posts
  - [x] post-service: return posts from users that the current user follows
  - [x] post-service: pagination
  - [x] frontend
- [ ] delete post
  - [ ] post-service: delete post
  - [ ] post-service: delete every comment and reaction to post
- [x] react to post
  - [x] post-service: save reaction to db
  - [x] post-service: send notification to post owner via rabbitmq
- [ ] change react to post
  - [ ] post-service: update reaction in db
  - [ ] post-service: send notification to post owner via rabbitmq
- [ ] delete react to post
  - [ ] post-service: remove reaction from db
- [x] comment to post
  - [x] post-service: save comment to db
  - [x] post-service: send notification to post owner via rabbitmq
- [x] chat
  - [x] fronted: send messages via rabbitmq
  - [x] frontend: receive messages via rabbitmq
  - [x] frontend: UI
  - [x] chat-service: receive messages
  - [x] chat-service: save messages to db
  - [x] chat-service: forward messages to users

## Nice to have

- [ ] delete user
  - [ ] auth-service: delete user from db
  - [ ] auth-service: notify user-service of user deletion
  - [ ] user-service: delete user from db
  - [ ] user-service: delete profile picture of user from disk
  - [ ] user-service: notify post-service and chat-service of user deletion
  - [ ] post-service: delete user from db
  - [ ] post-service: delete profile picture of user from disk
  - [ ] post-service: delete all posts and related reactions and comments of user
  - [ ] post-service: `?` delete all reactions and comments made by user 
  - [ ] chat-service: delete user from db
  - [ ] chat-service: delete profile picture of user from disk
  - [ ] chat-service: ?delete all conversations with user
- [ ] user-service: users can't follow themselves

## Message Broker

### Sync user with services

##### Queues
- `post-service-user-sync`
- `chat-service-user-sync`

##### Message structure
```
UserMessage = {
  username: string;
  profilePictureUrl?: string;
}

{
  method: 'CREATE' | 'UPDATE' | 'DELETE';
  user: UserMessage;
  follow?: {
    followed: UserMessage;
    follower: UserMessage;
  };
}
```