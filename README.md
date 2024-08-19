# Monkey CRM API

Monkey CRM API is a Ruby on Rails application that provides a backend for customer relationship management.

## Prerequisites

- Ruby 3.3.4
- Rails 7.2.0
- PostgreSQL 15+

## Setup and Running (without Docker)

1. Clone the repository:
   ```
   git clone https://github.com/mateoqac/monkey_crm_api.git
   cd monkey_crm_api
   ```

2. Install dependencies:
   ```
   bundle install
   ```

3. Set up the database:
   Edit `config/database.yml` and set your PostgreSQL credentials.

4. Set up environment variables:
   ```
   cp .env.example .env
   ```
   Edit `.env` and set the appropriate values for your environment. Make sure to set:
   ```
   DATABASE_HOST=localhost
   SECRET_KEY_BASE=your_generated_secret_key
   ```
   To generate a secret key, run:
   ```
   rake secret
   ```
   Copy the output and use it as the value for `SECRET_KEY_BASE` in your `.env` file.

5. Create and migrate the database:
   ```
   rails db:create db:migrate db:seed
   ```

6. Start the server:
   ```
   rails server
   ```

The API will be available at `http://localhost:3000`.

## Setup and Running (with Docker)

1. Clone the repository:
   ```
   git clone https://github.com/mateoqac/monkey_crm_api.git
   cd monkey_crm_api
   ```

2. Set up environment variables:
   ```
   cp .env.example .env
   ```
   Edit `.env` and set the appropriate values for your environment. For Docker setup, ensure:
   ```
   DATABASE_HOST=db
   SECRET_KEY_BASE=your_generated_secret_key
   ```
   To generate a secret key, run:
   ```
   docker-compose run web rake secret
   ```
   Copy the output and use it as the value for `SECRET_KEY_BASE` in your `.env` file.

3. Build the Docker image:
   ```
   docker-compose build
   ```

4. Start the services:
   ```
   docker-compose up
   ```

5. In a new terminal, run the database setup:
   ```
   docker-compose run web rails db:create db:migrate
   ```

The API will be available at `http://localhost:3000`.

Note: When using Docker, the `DATABASE_HOST` environment variable should be set to `db` in your `.env` file.

## Running Tests

Without Docker:
```
rspec
```

With Docker:
```
docker-compose run web rspec
```

## API Endpoints

- `POST /api/v1/auth/signup`: Sign up a new user
- `POST /api/v1/auth/login`: Log in a user
- `POST /api/v1/auth/logout`: Log out a user
- `GET /api/v1/customers`: List all customers
- `GET /api/v1/customers/:id`: Get a specific customer
- `POST /api/v1/customers`: Create a new customer
- `PATCH /api/v1/customers/:id`: Update a customer
- `DELETE /api/v1/customers/:id`: Delete a customer
- `POST /api/v1/customers/:id/upload_photo`: Upload a photo for a customer
- `DELETE /api/v1/customers/:id/delete_photo`: Delete a customer's photo
- `GET /api/v1/users`: List all users
- `GET /api/v1/users/:id`: Get a specific user
- `POST /api/v1/users`: Create a new user
- `PATCH /api/v1/users/:id`: Update a user
- `DELETE /api/v1/users/:id`: Delete a user
- `POST /api/v1/users/:id/add_admin_role`: Add admin role to a user
- `POST /api/v1/users/:id/remove_admin_role`: Remove admin role from a user
