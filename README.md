# C2S Test - Microservices Web Scraping System
#### The objective of this technical test is to implement a microservices architecture in Ruby on Rails that allows authenticated users to create web scraping tasks for car listings and receive notifications when the task is completed or fails.

#### The architecture consist of 3 microservices:
- **manager**, that "manage" the service of web scraping.
- **auth_service**, that is responsible for creating and authenticating the users with ```JWT```.
- **notification_service**, responsible for create and store the web scraping tasks notifications.

#### This project relies on:
- **Ruby 2.7.7**
- **Rails 5.2.0**
- **PostgreSQL 17, gem 1.6.3**
- **Redis 7, gem 4.5.1**
- **Sidekiq 5.2.10**
- **Docker** and **Docker-Compose**
<br>
<br>

## How to run

<br>
Clone the repository:

```bash
  git clone <repository_url>
  cd c2s_test
```

Build and start services:

```bash
  docker compose up --build
```

This will start:
- manage at port :3000
- auth_service at port :3001
- notification_service at port :3002
- postgres
- redis
<br>
<br>


## Architecture
```
               ┌─────────────────────┐
               │    Auth Service     │
               │  (Authentication)   │
               └──────────┬──────────┘
                          │ verify user
┌──────────────┐          │
│   Client     │ ─────────┼─────────────┐
└──────────────┘          │             │
                          │             │
                          ▼             ▼
              ┌───────────────────────────┐
              │     Manager Service       │
              │                           │
              │    - Creates tasks        │
              │    - Enqueues jobs        │
              │    - Tracks status        │
              └────────────┬──────────────┘
                           │ enqueue
                           │
                           ▼
                 ┌──────────────────┐
                 │  Sidekiq Worker  │
                 └────────┬─────────┘
                          │ scraping result
                          │
                          ▼
            ┌──────────────────────────┐
            │   Notification Service   │
            │                          │
            │  - Stores notifications  │
            └──────────────────────────┘
```

<br>
<br>

## API usage

#### Create users
```http
POST http://localhost:3001/auth/sign_up

Body:
{
  "name":     "your_users_name",
  "email":    "your_users_email",
  "password": "your_users_password"
}
```

#### Generate the user's ```token```
```http
POST ttp://localhost:3001/auth/sign_in
Body:
{
  "email": "your_users_email",
  "password": "you_users_password"
}
```

#### Validate the user's ```token```
That will be used in every request made in the **manager**.
```http
GET ttp://localhost:3001/auth/verify
Headers:
{
  Auth-token: <jwt_token>
}
```

#### Exhibit tasks
The user can only see the tasks the he/she created
```http
GET http://localhost:3000/tasks
Headers:
{
  Auth-token: <jwt_token>
}
```

#### Exhibit a specific task
Again, the user can only the tasks created by himself
```http
GET http://localhost:3000/tasks/:id
Headers:
{
  Auth-token: <jwt_token>
}
```

#### Create a task
```http
POST http://localhost:3000/tasks
Headers:
{
  Auth-token: <jwt_token>
}
Body:
{
  "title":         "your_title",
  "original_url": "the_url_to_be_scrapped"
}
```

#### Delete a task
An user can only delete a task the he/she created
```http
DELETE http://localhost:3000/tasks/:id
Headers:
{
  Auth-token: <jwt_token>
}
```

#### Exhibit the notifications
```http
GET http://localhost:3002/notifications
Body:
{
  "user_id": user_id
}
```

#### Exhibit a specific notification
```http
GET http://localhost:3002/notifications/:id
```

#### Create a notification
This endpoint is callled in the web scraping Job responsible for collect the data
```http
POST http://localhost:3002/notifications
Body:
{
  "task_id": task_id,
  "event_type": "task_event",
  "user_id": user_id,
  "user_email": "user_email",
  "collected_data": {
    "car_brand": "Honda",
    "car_model": "Civic Type R",
    "car_price": "200000"
  }
}
```

#### Delete a notification
```http
DELETE http://localhost:3002/notifications/:id
```

<br><br>
---






